import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import '../widgets/widget_input.dart';

class DecoracaoScreen extends StatefulWidget {
  const DecoracaoScreen({super.key});

  @override
  State<DecoracaoScreen> createState() =>
      _DecoracaoScreenState();
}

class _DecoracaoScreenState
    extends State<DecoracaoScreen> {

  final Color doceRosa =
  const Color(0xFFF06292);

  final Color doceRoxo =
  const Color(0xFF7E57C2);

  final TextEditingController
  nomeController =
  TextEditingController();

  final TextEditingController
  valorController =
  TextEditingController();

  List<Map<String, dynamic>> lista = [];

  int? idParaEditar;

  bool carregando = false;

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

    final dados =
    await BancoDados.listarDecoracoes();

    setState(() {
      lista = dados;
    });
  }

  void salvar() async {

    if (nomeController.text.isEmpty ||
        valorController.text.isEmpty) {

      _avisar(
        "Preencha nome e valor",
        Colors.orange,
      );

      return;
    }

    setState(() {
      carregando = true;
    });

    double valor = double.tryParse(
      valorController.text
          .replaceAll(',', '.'),
    ) ?? 0;

    try {

      if (idParaEditar == null) {

        // NOVO
        await BancoDados.inserirDecoracao(
          nomeController.text,
          valor,
        );

        _avisar(
          "Decoração salva ✨",
          Colors.green,
        );

      } else {

        await BancoDados.atualizarDecoracao(
          idParaEditar!,
          nomeController.text,
          valor,
        );

        _avisar(
          "Alteração salva!",
          Colors.blue,
        );
      }

      limparCampos();

      carregar();

    } catch (e) {

      _avisar(
        "Erro ao salvar",
        Colors.red,
      );

    } finally {

      setState(() {
        carregando = false;
      });
    }
  }

  void prepararEdicao(
      Map<String, dynamic> d,
      ) {

    setState(() {

      idParaEditar = d['id'];

      nomeController.text =
      d['nome'];

      valorController.text =
          d['valor'].toString();
    });
  }

  void excluir(int id) async {

    await BancoDados.deletarDecoracao(id);

    carregar();

    _avisar(
      "Excluído com sucesso",
      Colors.red,
    );
  }

  void limparCampos() {

    setState(() {

      idParaEditar = null;

      nomeController.clear();

      valorController.clear();
    });
  }

  void _avisar(
      String mensagem,
      Color cor,
      ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        behavior:
        SnackBarBehavior.floating,

        backgroundColor: cor,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),

        content: Text(

          mensagem,

          style: const TextStyle(
            color: Colors.white,
            fontWeight:
            FontWeight.bold,
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

        centerTitle: true,

        title: Text(

          idParaEditar == null
              ? "Decorações"
              : "Editar Decoração",

          style: const TextStyle(
            fontWeight:
            FontWeight.bold,
            color: Colors.white,
          ),
        ),

        iconTheme:
        const IconThemeData(
          color: Colors.white,
        ),

        flexibleSpace: Container(

          decoration: BoxDecoration(

            gradient: LinearGradient(
              colors: [
                doceRosa,
                doceRoxo,
              ],
            ),
          ),
        ),

        actions: [

          if (idParaEditar != null)

            IconButton(

              icon: const Icon(
                Icons.close,
              ),

              onPressed:
              limparCampos,
            ),
        ],
      ),

      body: Column(

        children: [

          Container(

            width: double.infinity,

            padding:
            const EdgeInsets.fromLTRB(
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

              borderRadius:
              const BorderRadius.only(
                bottomLeft:
                Radius.circular(35),
                bottomRight:
                Radius.circular(35),
              ),
            ),

            child: Container(

              padding:
              const EdgeInsets.all(22),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.08),
                    blurRadius: 18,
                    offset:
                    const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(

                children: [

                  // NOME
                  InputTextos(
                    "Nome da Decoração",
                    controller:
                    nomeController,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // VALOR
                  InputTextos(
                    "Valor (R\$)",
                    controller:
                    valorController,

                    tipo:
                    const TextInputType
                        .numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // BOTÃO
                  SizedBox(

                    width: double.infinity,
                    height: 56,

                    child:
                    ElevatedButton.icon(

                      onPressed:
                      carregando
                          ? null
                          : salvar,

                      icon: carregando

                          ? const SizedBox(
                        width: 20,
                        height: 20,

                        child:
                        CircularProgressIndicator(
                          strokeWidth:
                          2,
                          color:
                          Colors.white,
                        ),
                      )

                          : Icon(

                        idParaEditar ==
                            null

                            ? Icons
                            .add

                            : Icons
                            .save,
                      ),

                      label: Text(

                        carregando

                            ? "SALVANDO..."

                            : idParaEditar ==
                            null

                            ? "SALVAR DECORAÇÃO"

                            : "ATUALIZAR DADOS",

                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight
                              .bold,

                          fontSize: 15,

                          letterSpacing:
                          1,
                        ),
                      ),

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        doceRosa,

                        foregroundColor:
                        Colors.white,

                        elevation: 8,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
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

            padding:
            const EdgeInsets.fromLTRB(
              20,
              22,
              20,
              12,
            ),

            child: Row(

              children: [

                Icon(
                  Icons.cake_outlined,
                  color: doceRoxo,
                  size: 22,
                ),

                const SizedBox(width: 10),

                Text(

                  "DECORAÇÕES CADASTRADAS",

                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
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
                "Nenhuma decoração cadastrada",
              ),
            )

                : ListView.builder(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              itemCount:
              lista.length,

              itemBuilder:
                  (_, i) {

                final d = lista[i];

                return Container(

                  margin:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),

                  decoration:
                  BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),

                    boxShadow: [

                      BoxShadow(
                        color: Colors
                            .black
                            .withOpacity(
                          0.04,
                        ),

                        blurRadius: 14,

                        offset:
                        const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),

                  child: ListTile(

                    contentPadding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    leading:
                    CircleAvatar(

                      radius: 26,

                      backgroundColor:
                      doceRoxo
                          .withOpacity(
                        0.12,
                      ),

                      child: Icon(
                        Icons
                            .cake_outlined,
                        color:
                        doceRoxo,
                      ),
                    ),

                    title: Text(

                      d['nome'],

                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight
                            .w600,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Padding(

                      padding:
                      const EdgeInsets.only(
                        top: 4,
                      ),

                      child: Text(

                        "R\$ ${double.parse(d['valor'].toString()).toStringAsFixed(2)}",

                        style: TextStyle(
                          color:
                          Colors.grey[700],
                        ),
                      ),
                    ),

                    trailing: Row(

                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        IconButton(

                          icon: Icon(
                            Icons.edit,
                            color:
                            Colors.blue,
                          ),

                          onPressed:
                              () =>
                              prepararEdicao(
                                d,
                              ),
                        ),


                        IconButton(

                          icon: const Icon(
                            Icons
                                .delete_outline,
                            color:
                            Colors.red,
                          ),

                          onPressed:
                              () =>
                              _confirmarExclusao(
                                d['id'],
                              ),
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

  // CONFIRMAR EXCLUSÃO
  void _confirmarExclusao(
      int id,
      ) {

    showDialog(

      context: context,

      builder: (ctx) => AlertDialog(

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),

        title: const Text(
          "Excluir decoração",
        ),

        content: const Text(
          "Deseja realmente excluir esta decoração?",
        ),

        actions: [

          TextButton(

            onPressed: () {
              Navigator.pop(ctx);
            },

            child: const Text(
              "Cancelar",
            ),
          ),

          TextButton(

            onPressed: () {

              Navigator.pop(ctx);

              excluir(id);
            },

            child: const Text(

              "Excluir",

              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}