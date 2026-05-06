import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import '../widgets/widget_input.dart';
import '../widgets/widget_button.dart';

class DecoracaoScreen extends StatefulWidget {
  @override
  _DecoracaoScreenState createState() => _DecoracaoScreenState();
}

class _DecoracaoScreenState extends State<DecoracaoScreen> {

  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  TextEditingController nomeController = TextEditingController();
  TextEditingController valorController = TextEditingController();

  List<Map<String, dynamic>> lista = [];
  int? idParaEditar;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  @override
  void dispose() {
    nomeController.dispose();
    valorController.dispose();
    super.dispose();
  }

  void carregar() async {
    final dados = await BancoDados.listarDecoracoes();
    setState(() {
      lista = dados;
    });
  }

  void salvar() async {
    if (nomeController.text.isEmpty || valorController.text.isEmpty) {
      _avisar("Preencha o nome e o valor", Colors.orange);
      return;
    }

    double valor = double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0;

    if (idParaEditar == null) {
      // Inserir novo
      await BancoDados.inserirDecoracao(nomeController.text, valor);
      _avisar("✨ Decoração salva com sucesso!", Colors.green);
    } else {

      await BancoDados.atualizarDecoracao(idParaEditar!, nomeController.text, valor);
      _avisar("Alteração salva!", Colors.blue);
    }

    limparCampos();
    carregar();
  }

  void prepararEdicao(Map<String, dynamic> d) {
    setState(() {
      idParaEditar = d['id'];
      nomeController.text = d['nome'];
      valorController.text = d['valor'].toString();
    });
  }

  void excluir(int id) async {

    await BancoDados.deletarDecoracao(id);
    _avisar("Excluído com sucesso", Colors.redAccent);
    carregar();
  }

  void limparCampos() {
    setState(() {
      idParaEditar = null;
      nomeController.clear();
      valorController.clear();
    });
  }

  void _avisar(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(idParaEditar == null ? "Decorações" : "Editando Decoração"),
        backgroundColor: doceRosa,
        actions: [
          if (idParaEditar != null)
            IconButton(icon: Icon(Icons.close), onPressed: limparCampos)
        ],
      ),
      body: Column(
        children: [

          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: doceRosa,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    InputTextos("Nome da Decoração/Doce", controller: nomeController),
                    SizedBox(height: 10),
                    InputTextos(
                      "Valor (R\$)",
                      controller: valorController,
                      tipo: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 20),
                    Buttons(
                      idParaEditar == null ? "SALVAR DECORAÇÃO" : "ATUALIZAR DADOS",
                      onPressed: salvar,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // LISTAGEM
          Expanded(
            child: lista.isEmpty
                ? Center(child: Text("Nenhuma decoração cadastrada"))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: lista.length,
              itemBuilder: (_, i) {
                final d = lista[i];
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(Icons.cake, color: doceRoxo),
                    title: Text(d['nome'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("R\$ ${double.parse(d['valor'].toString()).toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => prepararEdicao(d),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarExclusao(d['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Excluir?"),
        content: Text("Tem certeza que deseja remover esta decoração?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancelar")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              excluir(id);
            },
            child: Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}