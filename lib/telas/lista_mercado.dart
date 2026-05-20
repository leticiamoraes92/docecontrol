import 'package:flutter/material.dart';
import '../database/bancodados.dart';

class ListaMercadoScreen extends StatefulWidget {
  const ListaMercadoScreen({super.key});

  @override
  State<ListaMercadoScreen> createState() =>
      _ListaMercadoScreenState();
}

class _ListaMercadoScreenState
    extends State<ListaMercadoScreen> {

  final Color doceRosa =
  const Color(0xFFF06292);

  final Color doceRoxo =
  const Color(0xFF7E57C2);

  final TextEditingController
  _itemController =
  TextEditingController();

  List<Map<String, dynamic>> _itens = [];

  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  void _carregarItens() async {

    final dados =
    await BancoDados
        .listarItensMercado();

    setState(() {
      _itens = dados;
    });
  }

  void _adicionarItem() async {

    if (_itemController.text
        .trim()
        .isEmpty) {

      _avisar(
        "Digite um item",
        Colors.orange,
      );

      return;
    }

    setState(() {
      carregando = true;
    });

    try {

      await BancoDados
          .inserirItemMercado(
        _itemController.text.trim(),
      );

      _itemController.clear();

      _carregarItens();

      _avisar(
        "Item adicionado ✨",
        Colors.green,
      );

    } catch (e) {

      _avisar(
        "Erro ao adicionar item",
        Colors.red,
      );

    } finally {

      setState(() {
        carregando = false;
      });
    }
  }

  // EXCLUIR
  void _excluirItem(int id) async {

    await BancoDados
        .excluirItemMercado(id);

    _carregarItens();

    _avisar(
      "Item removido",
      Colors.red,
    );
  }

  // SNACKBAR
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

        title: const Text(

          "Lista de Mercado",

          style: TextStyle(
            color: Colors.white,
            fontWeight:
            FontWeight.bold,
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
      ),

      body: Column(

        children: [

          // TOPO
          Container(

            width: double.infinity,

            padding:
            const EdgeInsets.fromLTRB(
              20,
              12,
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
              const EdgeInsets.all(20),

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

              child: Row(

                children: [

                  Expanded(

                    child: TextField(

                      controller:
                      _itemController,

                      decoration:
                      InputDecoration(

                        hintText:
                        "Adicionar item...",

                        filled: true,

                        fillColor:
                        Colors.grey.shade100,

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),

                          borderSide:
                          BorderSide.none,
                        ),

                        prefixIcon:
                        Icon(
                          Icons
                              .shopping_cart_outlined,
                          color:
                          doceRoxo,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  SizedBox(

                    width: 56,
                    height: 56,

                    child:
                    ElevatedButton(

                      onPressed:
                      carregando
                          ? null
                          : _adicionarItem,

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        doceRoxo,

                        elevation: 6,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      child: carregando

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

                          : const Icon(
                        Icons.add,
                        color:
                        Colors.white,
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
                  Icons
                      .shopping_basket_outlined,
                  color: doceRoxo,
                  size: 22,
                ),

                const SizedBox(width: 10),

                Text(

                  "MINHA LISTA",

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

            child: _itens.isEmpty

                ? const Center(
              child: Text(
                "Sua lista está vazia!",
              ),
            )

                : ListView.builder(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              itemCount:
              _itens.length,

              itemBuilder:
                  (context, index) {

                final item =
                _itens[index];

                bool comprado =
                    item['comprado'] ==
                        1;

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
                      horizontal: 12,
                      vertical: 6,
                    ),

                    leading: Checkbox(

                      activeColor:
                      doceRosa,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          5,
                        ),
                      ),

                      value: comprado,

                      onChanged:
                          (val) async {

                        await BancoDados
                            .alternarStatusItem(

                          item['id'],

                          val!
                              ? 1
                              : 0,
                        );

                        _carregarItens();
                      },
                    ),

                    title: Text(

                      item['item'],

                      style: TextStyle(

                        decoration:
                        comprado

                            ? TextDecoration
                            .lineThrough

                            : null,

                        color:
                        comprado

                            ? Colors.grey

                            : Colors.black87,

                        fontWeight:
                        FontWeight.w600,

                        fontSize: 15,
                      ),
                    ),

                    trailing:
                    IconButton(

                      icon: const Icon(
                        Icons
                            .delete_outline,
                        color:
                        Colors.redAccent,
                      ),

                      onPressed: () {

                        showDialog(

                          context:
                          context,

                          builder:
                              (_) =>
                              AlertDialog(

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                                ),

                                title:
                                const Text(
                                  "Excluir item",
                                ),

                                content:
                                const Text(
                                  "Deseja remover este item da lista?",
                                ),

                                actions: [

                                  TextButton(

                                    onPressed:
                                        () {
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

                                    onPressed:
                                        () {

                                      Navigator.pop(
                                        context,
                                      );

                                      _excluirItem(
                                        item['id'],
                                      );
                                    },

                                    child:
                                    const Text(

                                      "Excluir",

                                      style: TextStyle(
                                        color:
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
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