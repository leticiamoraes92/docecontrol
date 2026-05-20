import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import 'editaragendamento.dart';

class ControleAgendamentoScreen extends StatefulWidget {
  const ControleAgendamentoScreen({super.key});

  @override
  State<ControleAgendamentoScreen> createState() =>
      _ControleAgendamentoScreenState();
}

class _ControleAgendamentoScreenState
    extends State<ControleAgendamentoScreen> {

  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  List _todosPedidos = [];
  List _pedidosFiltrados = [];

  String _filtroAtual = 'todos';

  int _mesSelecionado =
      DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() async {

    final dados =
    await BancoDados.listarPedidos();

    setState(() {

      _todosPedidos = dados;

      _aplicarFiltro(_filtroAtual);
    });
  }

  void _aplicarFiltro(String filtro) {

    setState(() {

      _filtroAtual = filtro;

      DateTime agora = DateTime.now();

      _pedidosFiltrados =
          _todosPedidos.where((p) {

            try {

              List<String> partes =
              p['data'].split('/');

              DateTime dataPedido =
              DateTime(
                int.parse(partes[2]),
                int.parse(partes[1]),
                int.parse(partes[0]),
              );

              if (filtro == 'hoje') {

                return dataPedido.day ==
                    agora.day &&
                    dataPedido.month ==
                        agora.month &&
                    dataPedido.year ==
                        agora.year;
              }

              else if (filtro == 'semanal') {

                final inicioSemana =
                agora.subtract(
                  Duration(
                    days: agora.weekday - 1,
                  ),
                );

                final fimSemana =
                inicioSemana.add(
                  const Duration(days: 6),
                );

                return dataPedido.isAfter(
                  inicioSemana.subtract(
                    const Duration(days: 1),
                  ),
                ) &&
                    dataPedido.isBefore(
                      fimSemana.add(
                        const Duration(days: 1),
                      ),
                    );
              }

              else if (filtro == 'mensal') {

                return dataPedido.month ==
                    _mesSelecionado &&
                    dataPedido.year ==
                        agora.year;
              }

            } catch (e) {

              return true;
            }

            return true;

          }).toList();
    });
  }

  Widget _badgeStatus(String status) {

    Color cor;

    switch (status) {

      case "CONCLUÍDO":
        cor = Colors.green;
        break;

      case "PRODUÇÃO":
        cor = Colors.blue;
        break;

      case "CANCELADO":
        cor = Colors.red;
        break;

      default:
        cor = Colors.orange;
    }

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: cor.withOpacity(0.15),

        borderRadius:
        BorderRadius.circular(12),
      ),

      child: Text(

        status,

        style: TextStyle(
          color: cor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // LINHA INFO
  Widget _linhaInfo(
      String label,
      String valor,
      ) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        vertical: 3,
      ),

      child: RichText(

        text: TextSpan(

          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),

          children: [

            TextSpan(
              text: "$label ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            TextSpan(
              text: valor,
            ),
          ],
        ),
      ),
    );
  }

  // CARD PEDIDO
  Widget _cardPedido(Map p) {

    bool isConcluido =
        p['status'] == "CONCLUÍDO";

    return Opacity(

      opacity:
      isConcluido ? 0.75 : 1,

      child: Container(

        margin:
        const EdgeInsets.only(
          bottom: 14,
        ),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(22),

          boxShadow: [

            BoxShadow(
              color: Colors.black
                  .withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: ExpansionTile(

          collapsedShape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(22),
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(22),
          ),

          leading: CircleAvatar(

            backgroundColor:
            isConcluido
                ? Colors.green
                .withOpacity(0.15)
                : doceRosa.withOpacity(0.15),

            child: Icon(
              Icons.cake_outlined,

              color:
              isConcluido
                  ? Colors.green
                  : doceRosa,
            ),
          ),

          title: Row(

            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

            children: [

              Expanded(
                child: Text(

                  p['nome_cliente']
                      ?? "Cliente",

                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),

              _badgeStatus(
                p['status']
                    ?? "PENDENTE",
              ),
            ],
          ),

          subtitle: Text(
            "${p['data']} às ${p['horario']}",
          ),

          children: [

            Padding(

              padding:
              const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  const Divider(),

                  // PRODUTO
                  _linhaInfo(
                    "Doce:",
                    p['nome_doce']
                        ?? "Não informado",
                  ),

                  _linhaInfo(
                    "Massa/Sabor:",
                    p['massa'] ?? "-",
                  ),

                  const SizedBox(height: 8),

                  // ENTREGA
                  _linhaInfo(
                    "Entrega:",
                    p['tipo_entrega']
                        ?? "-",
                  ),

                  if (p['tipo_entrega']
                      == "Entrega")

                    _linhaInfo(
                      "Endereço:",
                      p['endereco']
                          ?? "-",
                    ),

                  _linhaInfo(
                    "Obs:",
                    p['observacao']
                        ?? "Nenhuma",
                  ),

                  const Divider(),

                  _linhaInfo(
                    "Entrada:",
                    "R\$ ${p['entrada']?.toStringAsFixed(2) ?? '0.00'}",
                  ),

                  _linhaInfo(
                    "Restante:",
                    "R\$ ${p['restante']?.toStringAsFixed(2) ?? '0.00'}",
                  ),

                  const SizedBox(height: 10),

                  Align(

                    alignment:
                    Alignment.centerRight,

                    child: Text(

                      "R\$ ${p['total']?.toStringAsFixed(2) ?? '0.00'}",

                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 24,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: [

                      TextButton.icon(

                        icon: Icon(
                          Icons.edit,
                          color: doceRoxo,
                          size: 18,
                        ),

                        label: Text(

                          "EDITAR",

                          style: TextStyle(
                            color: doceRoxo,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        onPressed:
                            () async {

                          bool? mudou =
                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder:
                                  (context) =>
                                  EditarAgendamentoScreen(
                                    pedido: p,
                                  ),
                            ),
                          );

                          if (mudou == true) {
                            _atualizarLista();
                          }
                        },
                      ),

                      TextButton.icon(

                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),

                        label: const Text(

                          "EXCLUIR",

                          style: TextStyle(
                            color: Colors.red,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        onPressed: () {

                          showDialog(

                            context: context,

                            builder: (_) =>
                                AlertDialog(

                                  title:
                                  const Text(
                                    "Excluir Pedido",
                                  ),

                                  content:
                                  const Text(
                                    "Deseja realmente excluir este pedido?",
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

                                      onPressed:
                                          () async {

                                        await BancoDados
                                            .excluirPedido(
                                          p['id'],
                                        );

                                        Navigator.pop(
                                          context,
                                        );

                                        _atualizarLista();

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(

                                          SnackBar(

                                            behavior:
                                            SnackBarBehavior.floating,

                                            backgroundColor:
                                            Colors.red,

                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(14),
                                            ),

                                            content:
                                            const Text(
                                              "Pedido excluído!",
                                            ),
                                          ),
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
                      ),
                    ],
                  ),

                  // FINALIZAR
                  if (!isConcluido) ...[

                    const SizedBox(height: 14),

                    SizedBox(

                      width: double.infinity,

                      child: ElevatedButton.icon(

                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          Colors.green.shade600,

                          elevation: 4,

                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 14,
                          ),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: () {

                          showDialog(

                            context: context,

                            builder: (_) =>
                                AlertDialog(

                                  title:
                                  const Text(
                                    "Finalizar Pedido",
                                  ),

                                  content:
                                  const Text(
                                    "Deseja concluir este pedido?",
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

                                      onPressed:
                                          () async {

                                        await BancoDados
                                            .atualizarStatusPedido(
                                          p['id'],
                                          "CONCLUÍDO",
                                        );

                                        Navigator.pop(
                                          context,
                                        );

                                        _atualizarLista();

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(

                                          SnackBar(

                                            behavior:
                                            SnackBarBehavior.floating,

                                            backgroundColor:
                                            Colors.green,

                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(14),
                                            ),

                                            content:
                                            const Text(
                                              "Pedido finalizado!",
                                            ),
                                          ),
                                        );
                                      },

                                      child:
                                      const Text(
                                        "Confirmar",
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },

                        label: const Text(

                          "FINALIZAR PEDIDO",

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FILTROS
  Widget _sessaoFiltros() {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        vertical: 10,
      ),

      color: Colors.white,

      child: SingleChildScrollView(

        scrollDirection:
        Axis.horizontal,

        child: Row(

          children: [

            const SizedBox(width: 10),

            _botaoFiltro(
              "Todos",
              'todos',
            ),

            _botaoFiltro(
              "Hoje",
              'hoje',
            ),

            _botaoFiltro(
              "Semana",
              'semanal',
            ),

            _botaoFiltro(
              "Mês",
              'mensal',
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoFiltro(
      String label,
      String tipo,
      ) {

    bool selecionado =
        _filtroAtual == tipo;

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 4,
      ),

      child: ChoiceChip(

        elevation: 2,
        pressElevation: 4,

        shape:
        const StadiumBorder(),

        label: Text(label),

        selected: selecionado,

        onSelected: (val) {
          _aplicarFiltro(tipo);
        },

        selectedColor: doceRosa,

        backgroundColor:
        Colors.pink.shade50,

        labelStyle: TextStyle(
          color: selecionado
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  Widget _seletorDeMes() {

    final meses = [

      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro",
    ];

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),

      color: Colors.white,

      child: DropdownButton<int>(

        value: _mesSelecionado,

        isExpanded: true,

        underline: Container(
          height: 2,
          color: doceRosa,
        ),

        items: List.generate(
          12,
              (index) {

            return DropdownMenuItem(

              value: index + 1,

              child: Text(

                meses[index],

                style: TextStyle(
                  color: doceRoxo,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            );
          },
        ),

        onChanged: (novoMes) {

          setState(() {

            _mesSelecionado =
            novoMes!;

            _aplicarFiltro(
              'mensal',
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F5F5),

      appBar: AppBar(

        title: const Text(

          "Controle Doce",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
            color: Colors.white,
          ),
        ),

        centerTitle: true,

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

          _sessaoFiltros(),

          if (_filtroAtual == 'mensal')
            _seletorDeMes(),

          Expanded(

            child:
            _pedidosFiltrados.isEmpty

                ? const Center(
              child: Text(
                "Nenhum agendamento encontrado.",
              ),
            )

                : ListView.builder(

              padding:
              const EdgeInsets.all(12),

              itemCount:
              _pedidosFiltrados.length,

              itemBuilder:
                  (context, index) {

                final p =
                _pedidosFiltrados[index];

                return _cardPedido(p);
              },
            ),
          ),
        ],
      ),
    );
  }
}