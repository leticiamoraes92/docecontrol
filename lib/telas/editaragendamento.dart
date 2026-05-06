import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import '../widgets/widget_input.dart';
import '../widgets/widget_button.dart';

class EditarAgendamentoScreen extends StatefulWidget {
  final Map pedido;
  const EditarAgendamentoScreen({super.key, required this.pedido});

  @override
  _EditarAgendamentoScreenState createState() => _EditarAgendamentoScreenState();
}

class _EditarAgendamentoScreenState extends State<EditarAgendamentoScreen> {
  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  late TextEditingController quantidadeController;
  late TextEditingController entradaController;
  late TextEditingController entregaValorController;
  late TextEditingController massaController;
  late TextEditingController dataController;
  late TextEditingController horarioController;
  late TextEditingController enderecoController;
  late TextEditingController observacaoController;

  String tipoEntrega = "Retirada";
  double total = 0;
  double restante = 0;
  double valorUnitario = 0;

  @override
  void initState() {
    super.initState();
    final p = widget.pedido;

    quantidadeController = TextEditingController(text: p['quantidade'].toString());
    entradaController = TextEditingController(text: p['entrada'].toString());
    entregaValorController = TextEditingController(text: p['valor_entrega']?.toString() ?? "0");
    massaController = TextEditingController(text: p['massa']);
    dataController = TextEditingController(text: p['data']);
    horarioController = TextEditingController(text: p['horario']);
    enderecoController = TextEditingController(text: p['endereco'] ?? "");
    observacaoController = TextEditingController(text: p['observacao'] ?? "");
    tipoEntrega = p['tipo_entrega'] ?? "Retirada";
    total = p['total'];
    restante = p['restante'];

    double frete = double.tryParse(entregaValorController.text) ?? 0;
    int qtd = int.tryParse(quantidadeController.text) ?? 1;
    valorUnitario = (total - frete) / (qtd > 0 ? qtd : 1);
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => dataController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}");
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => horarioController.text = picked.format(context));
  }

  void calcular() {
    setState(() {
      double qtd = double.tryParse(quantidadeController.text.replaceAll(',', '.')) ?? 0;
      double entrada = double.tryParse(entradaController.text.replaceAll(',', '.')) ?? 0;
      double frete = tipoEntrega == "Entrega"
          ? (double.tryParse(entregaValorController.text.replaceAll(',', '.')) ?? 0)
          : 0;

      total = (qtd * valorUnitario) + frete;
      restante = total - entrada;
    });
  }

  void salvarEdicao() async {
    try {
      final db = await BancoDados.abrirBanco();
      await db.update('pedidos', {
        'quantidade': int.tryParse(quantidadeController.text) ?? 0,
        'total': total,
        'entrada': double.tryParse(entradaController.text.replaceAll(',', '.')) ?? 0,
        'restante': restante,
        'massa': massaController.text,
        'data': dataController.text,
        'horario': horarioController.text,
        'tipo_entrega': tipoEntrega,
        'endereco': enderecoController.text,
        'valor_entrega': double.tryParse(entregaValorController.text.replaceAll(',', '.')) ?? 0,
        'observacao': observacaoController.text,
      }, where: 'id = ?', whereArgs: [widget.pedido['id']]);

      Navigator.pop(context, true);
    } catch (e) {
      print("Erro ao editar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Agendamento", style: TextStyle(color: Colors.white)),
        backgroundColor: doceRosa,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InputTextos("Quantidade", controller: quantidadeController, tipo: TextInputType.number, onChanged: (v) => calcular()),
            const SizedBox(height: 12),
            InputTextos("Massa/Sabor", controller: massaController),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: InkWell(onTap: _pickDate, child: AbsorbPointer(child: InputTextos("Data", controller: dataController)))),
                const SizedBox(width: 12),
                Expanded(child: InkWell(onTap: _pickTime, child: AbsorbPointer(child: InputTextos("Hora", controller: horarioController)))),
              ],
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: tipoEntrega,
              decoration: const InputDecoration(labelText: "Tipo de Entrega"),
              onChanged: (v) => setState(() { tipoEntrega = v!; calcular(); }),
              items: const [DropdownMenuItem(value: "Retirada", child: Text("Retirada")), DropdownMenuItem(value: "Entrega", child: Text("Entrega"))],
            ),
            if (tipoEntrega == "Entrega") ...[
              const SizedBox(height: 12),
              InputTextos("Valor Frete", controller: entregaValorController, tipo: TextInputType.number, onChanged: (v) => calcular()),
              const SizedBox(height: 12),
              InputTextos("Endereço", controller: enderecoController),
            ],
            const SizedBox(height: 12),
            InputTextos("Observação", controller: observacaoController, maxLines: 3),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [const Text("TOTAL"), Text("R\$ ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
                Column(children: [const Text("FALTA"), Text("R\$ ${restante.toStringAsFixed(2)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: doceRosa))]),
              ],
            ),
            const SizedBox(height: 30),
            Buttons("ATUALIZAR AGENDAMENTO", onPressed: salvarEdicao),
          ],
        ),
      ),
    );
  }
}