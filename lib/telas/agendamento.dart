import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import '../widgets/widget_input.dart';
import '../widgets/widget_button.dart';

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  _AgendamentoScreenState createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  List clientes = [];
  List decoracoes = [];
  bool carregando = false;

  int? clienteSelecionado;
  int? decoracaoSelecionada;
  double valorUnitario = 0;
  double total = 0;
  double restante = 0;
  double valorEntrega = 0;
  String tipoEntrega = "Retirada";

  final quantidadeController = TextEditingController();
  final entradaController = TextEditingController();
  final entregaValorController = TextEditingController(text: "0");
  final massaController = TextEditingController();
  final dataController = TextEditingController();
  final horarioController = TextEditingController();
  final enderecoController = TextEditingController();
  final observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    final c = await BancoDados.listarClientes();
    final d = await BancoDados.listarDecoracoes();
    setState(() {
      clientes = c;
      decoracoes = d;
    });
  }

  void calcular() {
    setState(() {
      double qtd = double.tryParse(quantidadeController.text.replaceAll(',', '.')) ?? 0;
      double entrada = double.tryParse(entradaController.text.replaceAll(',', '.')) ?? 0;

      valorEntrega = tipoEntrega == "Entrega"
          ? (double.tryParse(entregaValorController.text.replaceAll(',', '.')) ?? 0)
          : 0;

      total = (qtd * valorUnitario) + valorEntrega;
      restante = total - entrada;
    });
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

  void salvar() async {
    if (clienteSelecionado == null || decoracaoSelecionada == null || dataController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Preencha os campos obrigatórios!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange));
      return;
    }
    setState(() => carregando = true);
    try {
      await BancoDados.inserirPedido(
        clienteSelecionado!,
        decoracaoSelecionada!,
        observacaoController.text,
        int.tryParse(quantidadeController.text) ?? 0,
        total,
        double.tryParse(entradaController.text.replaceAll(',', '.')) ?? 0.0,
        restante,
        massaController.text,
        dataController.text,
        horarioController.text,
        tipoEntrega,
        enderecoController.text,
        valorEntrega,
      );
      Navigator.pop(context, true);
    } catch (e) {
      print("Erro ao salvar: $e");
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Novo Agendamento", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: doceRosa,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: carregando
          ? Center(child: CircularProgressIndicator(color: doceRosa))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [

            _buildCard(
              titulo: "1. CLIENTE E DOCE",
              icone: Icons.person_outline,
              conteudo: Column(
                children: [
                  DropdownButtonFormField<int>(
                    value: clienteSelecionado,
                    decoration: const InputDecoration(labelText: "Selecionar Cliente"),
                    onChanged: (v) => setState(() => clienteSelecionado = v),
                    items: clientes.map<DropdownMenuItem<int>>((c) => DropdownMenuItem(value: c['id'], child: Text(c['nome']))).toList(),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<int>(
                    value: decoracaoSelecionada,
                    decoration: const InputDecoration(labelText: "Tipo de Doce"),
                    onChanged: (v) {
                      setState(() {
                        decoracaoSelecionada = v;
                        var d = decoracoes.firstWhere((item) => item['id'] == v);
                        valorUnitario = double.tryParse(d['valor'].toString()) ?? 0.0;
                        calcular();
                      });
                    },
                    items: decoracoes.map<DropdownMenuItem<int>>((d) => DropdownMenuItem(value: d['id'], child: Text(d['nome']))).toList(),
                  ),
                  const SizedBox(height: 15),
                  InputTextos("Massa/Sabor", controller: massaController),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              titulo: "2. FINANCEIRO",
              icone: Icons.monetization_on_outlined,
              conteudo: Column(
                children: [
                  InputTextos("Quantidade", controller: quantidadeController, tipo: TextInputType.number, onChanged: (v) => calcular()),
                  const SizedBox(height: 12),
                  InputTextos("Entrada (R\$)", controller: entradaController, tipo: TextInputType.number, onChanged: (v) => calcular()),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _resumoFinanceiro("TOTAL", total, Colors.black),
                      _resumoFinanceiro("FALTA", restante, doceRosa),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              titulo: "3. DATA E ENTREGA",
              icone: Icons.calendar_month_outlined,
              conteudo: Column(
                children: [
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
                    onChanged: (v) {
                      setState(() {
                        tipoEntrega = v!;
                        if (tipoEntrega == "Retirada") entregaValorController.text = "0";
                        calcular();
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: "Retirada", child: Text("Retirada")),
                      DropdownMenuItem(value: "Entrega", child: Text("Entrega")),
                    ],
                  ),
                  if (tipoEntrega == "Entrega") ...[
                    const SizedBox(height: 12),
                    InputTextos("Valor da Entrega (R\$)", controller: entregaValorController, tipo: TextInputType.number, onChanged: (v) => calcular()),
                    const SizedBox(height: 12),
                    InputTextos("Endereço Completo", controller: enderecoController),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              titulo: "4. OBSERVAÇÃO",
              icone: Icons.edit_note_outlined,
              conteudo: InputTextos("Detalhes extras...", controller: observacaoController, maxLines: 3),
            ),

            const SizedBox(height: 25),

            Buttons("SALVAR NO DOCE CONTROL", onPressed: salvar),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String titulo, required IconData icone, required Widget conteudo}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 20, color: doceRoxo),
              const SizedBox(width: 10),
              Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, color: doceRoxo, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),
          conteudo,
        ],
      ),
    );
  }

  Widget _resumoFinanceiro(String label, double valor, Color cor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
        Text("R\$ ${valor.toStringAsFixed(2)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cor)),
      ],
    );
  }
}