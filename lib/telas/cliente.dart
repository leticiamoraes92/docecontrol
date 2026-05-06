import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import '../widgets/widget_input.dart';
import '../widgets/widget_button.dart';

class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {

  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  List<Map<String, dynamic>> lista = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  void carregar() async {
    final dados = await BancoDados.listarClientes();
    setState(() {
      lista = dados;
    });
  }

  void salvarCliente() async {
    String nome = nomeController.text;
    String telefone = telefoneController.text;

    if (nome.isEmpty) {
      _avisar("Por favor, digite o nome do cliente", Colors.orange);
      return;
    }

    try {
      await BancoDados.inserirCliente(nome, telefone);
      nomeController.clear();
      telefoneController.clear();
      carregar();
      _avisar("✨ Cliente cadastrado com sucesso!", Colors.green);
    } catch (e) {
      _avisar("Erro ao salvar: $e", Colors.red);
    }
  }

  void _avisar(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: c),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Clientes", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: doceRosa,
        elevation: 0,
      ),
      body: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: doceRosa,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    InputTextos(
                      "Nome Completo",
                      controller: nomeController,
                    ),
                    const SizedBox(height: 15),
                    InputTextos(
                      "Telefone / WhatsApp",
                      controller: telefoneController,
                      tipo: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    Buttons(
                      "CADASTRAR CLIENTE",
                      onPressed: salvarCliente,
                    ),
                  ],
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(Icons.people_alt, color: doceRoxo, size: 20),
                const SizedBox(width: 8),
                Text(
                  "MEUS CLIENTES",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: doceRoxo,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text("Nenhum cliente cadastrado"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: lista.length,
              itemBuilder: (_, i) {
                final c = lista[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: doceRoxo.withOpacity(0.1),
                      child: Text(
                        c['nome'][0].toUpperCase(),
                        style: TextStyle(color: doceRoxo, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      c['nome'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(c['telefone'] ?? 'Sem telefone'),

                    trailing: const Icon(Icons.chat_bubble_outline, color: Colors.green, size: 20),
                    onTap: () {

                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

