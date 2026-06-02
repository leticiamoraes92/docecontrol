import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import '../widgets/widget_input.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {

  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  final TextEditingController nomeController =
  TextEditingController();

  final TextEditingController telefoneController =
  TextEditingController();

  List<Map<String, dynamic>> lista = [];

  bool carregando = false;

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

  // CARREGAR CLIENTES
  void carregar() async {

    final dados =
    await BancoDados.listarClientes();

    setState(() {
      lista = dados;
    });
  }

  // SALVAR CLIENTE
  void salvarCliente() async {

    String nome =
    nomeController.text.trim();

    String telefone =
    telefoneController.text.trim();

    if (nome.isEmpty) {

      _avisar(
        "Digite o nome do cliente",
        Colors.orange,
      );

      return;
    }

    setState(() {
      carregando = true;
    });

    try {

      await BancoDados.inserirCliente(
        nome,
        telefone,
      );

      nomeController.clear();
      telefoneController.clear();

      carregar();

      _avisar(
        "Cliente cadastrado com sucesso ✨",
        Colors.green,
      );

    } catch (e) {

      _avisar(
        "Erro ao salvar cliente",
        Colors.red,
      );

    } finally {

      setState(() {
        carregando = false;
      });
    }
  }

  void excluirCliente(int id) async {

    await BancoDados.excluirCliente(id);

    carregar();

    _avisar(
      "Cliente removido",
      Colors.red,
    );
  }

  // SNACKBAR
  void _avisar(
      String mensagem,
      Color cor,
      ) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        content: Text(
          mensagem,

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xfff8f5f9),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor: doceRosa,

        title: const Text(
          "Clientes",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Column(

        children: [

          // TOPO
          Container(

            width: double.infinity,

            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),

            decoration: BoxDecoration(

              gradient: LinearGradient(
                colors: [
                  doceRosa,
                  doceRoxo,
                ],
              ),

              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),

            child: Container(

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(

                children: [

                  // NOME
                  InputTextos(
                    "Nome Completo",
                    controller: nomeController,
                  ),

                  const SizedBox(height: 16),

                  // TELEFONE
                  InputTextos(
                    "Telefone / WhatsApp",
                    controller: telefoneController,
                    tipo: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  // BOTÃO
                  SizedBox(

                    width: double.infinity,
                    height: 56,

                    child: ElevatedButton.icon(

                      onPressed:
                      carregando
                          ? null
                          : salvarCliente,

                      icon: carregando

                          ? const SizedBox(
                        width: 20,
                        height: 20,

                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )

                          : const Icon(
                        Icons.person_add_alt_1,
                      ),

                      label: Text(

                        carregando
                            ? "SALVANDO..."
                            : "CADASTRAR CLIENTE",

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(

                        backgroundColor: doceRosa,
                        foregroundColor: Colors.white,

                        elevation: 8,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TÍTULO
          Padding(

            padding: const EdgeInsets.fromLTRB(
              20,
              22,
              20,
              12,
            ),

            child: Row(

              children: [

                Icon(
                  Icons.people_alt,
                  color: doceRoxo,
                  size: 22,
                ),

                const SizedBox(width: 10),

                Text(

                  "CLIENTES CADASTRADOS",

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: doceRoxo,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // LISTA
          Expanded(

            child: lista.isEmpty

                ? const Center(
              child: Text(
                "Nenhum cliente cadastrado",
              ),
            )

                : ListView.builder(

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              itemCount: lista.length,

              itemBuilder: (_, i) {

                final c = lista[i];

                return Container(

                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(20),

                    boxShadow: [

                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: ListTile(

                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    leading: CircleAvatar(

                      radius: 26,

                      backgroundColor:
                      doceRoxo.withOpacity(0.12),

                      child: Text(

                        c['nome'][0]
                            .toUpperCase(),

                        style: TextStyle(
                          color: doceRoxo,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    title: Text(

                      c['nome'],

                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Padding(

                      padding:
                      const EdgeInsets.only(
                        top: 4,
                      ),

                      child: Text(

                        c['telefone']
                            ?? "Sem telefone",

                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    trailing: PopupMenuButton(

                      icon: Icon(
                        Icons.more_vert,
                        color: doceRoxo,
                      ),

                      itemBuilder: (_) => [

                        PopupMenuItem(

                          child: const Text(
                            "Excluir",
                          ),

                          onTap: () {

                            Future.delayed(
                              Duration.zero,
                                  () {

                                showDialog(

                                  context: context,

                                  builder: (_) =>
                                      AlertDialog(

                                        title:
                                        const Text(
                                          "Excluir Cliente",
                                        ),

                                        content:
                                        const Text(
                                          "Deseja realmente excluir este cliente?",
                                        ),

                                        actions: [

                                          TextButton(

                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                              );
                                            },

                                            child:
                                            const Text(
                                              "Cancelar",
                                            ),
                                          ),

                                          TextButton(

                                            onPressed: () {

                                              excluirCliente(
                                                c['id'],
                                              );

                                              Navigator.pop(
                                                context,
                                              );
                                            },

                                            child:
                                            const Text(
                                              "Excluir",
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            );
                          },
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
}

