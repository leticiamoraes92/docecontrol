import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/bancodados.dart';
import '../widgets/widget_input.dart';
import '../models/pedido_model.dart';
import '../services/firebase_service.dart';

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  State<AgendamentoScreen> createState() =>
      _AgendamentoScreenState();
}

class _AgendamentoScreenState
    extends State<AgendamentoScreen> {

  final Color doceRosa =
  const Color(0xFFF06292);

  final Color doceRoxo =
  const Color(0xFF7E57C2);

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

  final quantidadeController =
  TextEditingController();

  final entradaController =
  TextEditingController();

  final entregaValorController =
  TextEditingController(text: "0");

  final massaController =
  TextEditingController();

  final dataController =
  TextEditingController();

  final horarioController =
  TextEditingController();

  final enderecoController =
  TextEditingController();

  final observacaoController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {

    final c =
    await BancoDados.listarClientes();

    final d =
    await BancoDados.listarDecoracoes();

    setState(() {

      clientes = c;
      decoracoes = d;
    });
  }

  // CALCULAR
  void calcular() {

    setState(() {

      double qtd =
          double.tryParse(
              quantidadeController.text
                  .replaceAll(',', '.')
          ) ?? 0;

      double entrada =
          double.tryParse(
              entradaController.text
                  .replaceAll(',', '.')
          ) ?? 0;

      valorEntrega =
      tipoEntrega == "Entrega"

          ? (double.tryParse(
          entregaValorController.text
              .replaceAll(',', '.')
      ) ?? 0)

          : 0;

      total =
          (qtd * valorUnitario) +
              valorEntrega;

      restante = total - entrada;
    });
  }

  // DATA
  Future<void> _pickDate() async {

    DateTime? picked =
    await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),
    );

    if (picked != null) {

      setState(() {

        dataController.text =
        "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  Future<void> _pickTime() async {

    TimeOfDay? picked =
    await showTimePicker(

      context: context,

      initialTime:
      TimeOfDay.now(),
    );

    if (picked != null) {

      setState(() {

        horarioController.text =
            picked.format(context);
      });
    }
  }

  void salvar() async {

    if (clienteSelecionado == null ||
        decoracaoSelecionada == null ||
        dataController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          behavior:
          SnackBarBehavior.floating,

          backgroundColor:
          Colors.orange,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),

          content: const Text(
            "Preencha os campos obrigatórios!",
          ),
        ),
      );

      return;
    }

    setState(() {
      carregando = true;
    });

    try {

      var clienteObj =
      clientes.firstWhere(
              (c) =>
          c['id'] ==
              clienteSelecionado);

      var doceObj =
      decoracoes.firstWhere(
              (d) =>
          d['id'] ==
              decoracaoSelecionada);

      await BancoDados.inserirPedido(

        clienteSelecionado!,
        decoracaoSelecionada!,

        observacaoController.text,

        int.tryParse(
            quantidadeController.text
        ) ?? 0,

        total,

        double.tryParse(
            entradaController.text
                .replaceAll(',', '.')
        ) ?? 0.0,

        restante,

        massaController.text,

        dataController.text,

        horarioController.text,

        tipoEntrega,

        enderecoController.text,

        valorEntrega,
      );

      PedidoModel novoPedido =
      PedidoModel(

        cliente:
        clienteObj['nome'],

        doce:
        doceObj['nome'],

        quantidade:
        int.tryParse(
            quantidadeController.text
        ) ?? 0,

        total: total,

        data:
        dataController.text,

        status: 'Pendente',
      );

      await FirebaseService()
          .salvarPedido(novoPedido);

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          behavior:
          SnackBarBehavior.floating,

          backgroundColor:
          Colors.green,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),

          content: const Text(
            "Agendamento salvo com sucesso!",
          ),
        ),
      );

    } catch (e) {

      print("Erro ao salvar: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          behavior:
          SnackBarBehavior.floating,

          backgroundColor:
          Colors.red,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),

          content: const Text(
            "Erro ao salvar pedido.",
          ),
        ),
      );

    } finally {

      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xfff8f5f9),

      appBar: AppBar(

        centerTitle: true,

        title: const Text(

          "Novo Agendamento",

          style: TextStyle(
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
      ),

      body: carregando

          ? Center(
        child:
        CircularProgressIndicator(
          color: doceRosa,
        ),
      )

          : SingleChildScrollView(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),

        child: Column(

          children: [

            _buildCard(

              titulo:
              "1. CLIENTE E DOCE",

              icone:
              Icons.person_outline,

              conteudo: Column(

                children: [

                  DropdownButtonFormField<
                      int>(

                    value:
                    clienteSelecionado,

                    decoration:
                    _inputDecoration(
                      "Selecionar Cliente",
                    ),

                    onChanged: (v) {

                      setState(() {
                        clienteSelecionado =
                            v;
                      });
                    },

                    items: clientes
                        .map<
                        DropdownMenuItem<
                            int>>(
                          (c) =>
                          DropdownMenuItem(
                            value:
                            c['id'],

                            child: Text(
                              c['nome'],
                            ),
                          ),
                    ).toList(),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<
                      int>(

                    value:
                    decoracaoSelecionada,

                    decoration:
                    _inputDecoration(
                      "Tipo de Doce",
                    ),

                    onChanged: (v) {

                      setState(() {

                        decoracaoSelecionada =
                            v;

                        var d =
                        decoracoes
                            .firstWhere(
                                (item) =>
                            item['id'] ==
                                v);

                        valorUnitario =
                            double.tryParse(
                                d['valor']
                                    .toString()
                            ) ??
                                0;

                        calcular();
                      });
                    },

                    items: decoracoes
                        .map<
                        DropdownMenuItem<
                            int>>(
                          (d) =>
                          DropdownMenuItem(
                            value:
                            d['id'],

                            child: Text(
                              d['nome'],
                            ),
                          ),
                    ).toList(),
                  ),

                  const SizedBox(height: 16),

                  InputTextos(
                    "Massa/Sabor",
                    controller:
                    massaController,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _buildCard(

              titulo:
              "2. FINANCEIRO",

              icone:
              Icons.attach_money_outlined,

              conteudo: Column(

                children: [

                  InputTextos(

                    "Quantidade",

                    controller:
                    quantidadeController,

                    tipo:
                    TextInputType.number,

                    onChanged:
                        (v) =>
                        calcular(),
                  ),

                  const SizedBox(height: 14),

                  Container(

                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(
                      14,
                    ),

                    decoration:
                    BoxDecoration(

                      color: Colors
                          .grey
                          .shade100,

                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: Row(

                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        const Text(

                          "Valor Unitário",

                          style: TextStyle(
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),

                        Text(

                          "R\$ ${valorUnitario.toStringAsFixed(2)}",

                          style: TextStyle(
                            fontWeight:
                            FontWeight
                                .bold,
                            color:
                            doceRosa,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  InputTextos(

                    "Entrada (R\$)",

                    controller:
                    entradaController,

                    tipo:
                    TextInputType.number,

                    onChanged:
                        (v) =>
                        calcular(),
                  ),

                  Align(

                    alignment:
                    Alignment.centerRight,

                    child: TextButton(

                      onPressed: () {

                        setState(() {

                          entradaController
                              .text =
                              (total / 2)
                                  .toStringAsFixed(
                                2,
                              );

                          calcular();
                        });
                      },

                      child: Text(

                        "Usar entrada de 50%",

                        style: TextStyle(
                          color:
                          doceRoxo,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,

                    children: [

                      _resumoFinanceiro(
                        "VALOR TOTAL",
                        total,
                        Colors.black,
                      ),

                      _resumoFinanceiro(
                        "SALDO",
                        restante,
                        doceRosa,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _buildCard(

              titulo:
              "3. DATA E ENTREGA",

              icone:
              Icons.local_shipping_outlined,

              conteudo: Column(

                children: [

                  Row(

                    children: [

                      Expanded(

                        child: InkWell(

                          onTap:
                          _pickDate,

                          child:
                          AbsorbPointer(

                            child:
                            InputTextos(
                              "Data",
                              controller:
                              dataController,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(

                        child: InkWell(

                          onTap:
                          _pickTime,

                          child:
                          AbsorbPointer(

                            child:
                            InputTextos(
                              "Hora",
                              controller:
                              horarioController,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<
                      String>(

                    value:
                    tipoEntrega,

                    decoration:
                    _inputDecoration(
                      "Tipo de Entrega",
                    ),

                    onChanged: (v) {

                      setState(() {

                        tipoEntrega = v!;

                        if (tipoEntrega ==
                            "Retirada") {

                          entregaValorController
                              .text = "0";
                        }

                        calcular();
                      });
                    },

                    items: const [

                      DropdownMenuItem(
                        value:
                        "Retirada",

                        child: Text(
                          "Retirada",
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                        "Entrega",

                        child: Text(
                          "Entrega",
                        ),
                      ),
                    ],
                  ),

                  if (tipoEntrega ==
                      "Entrega") ...[

                    const SizedBox(
                      height: 16,
                    ),

                    InputTextos(

                      "Valor da Entrega",

                      controller:
                      entregaValorController,

                      tipo:
                      TextInputType.number,

                      onChanged:
                          (v) =>
                          calcular(),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    InputTextos(
                      "Endereço Completo",
                      controller:
                      enderecoController,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 14),

            _buildCard(

              titulo:
              "4. OBSERVAÇÕES",

              icone:
              Icons.edit_note_outlined,

              conteudo: InputTextos(

                "Detalhes extras...",

                controller:
                observacaoController,

                maxLines: 4,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(

              width: double.infinity,
              height: 58,

              child:
              ElevatedButton.icon(

                onPressed:
                carregando
                    ? null
                    : salvar,

                icon: carregando

                    ? const SizedBox(

                  width: 22,
                  height: 22,

                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2,
                    color:
                    Colors.white,
                  ),
                )

                    : const Icon(
                  Icons
                      .check_circle_outline,
                ),

                label: Text(

                  carregando

                      ? "SALVANDO..."

                      : "SALVAR NO DOCE CONTROL",

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight
                        .bold,
                    fontSize: 16,
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

                  shadowColor:
                  doceRosa
                      .withOpacity(
                    0.4,
                  ),

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

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // CARD
  Widget _buildCard({

    required String titulo,
    required IconData icone,
    required Widget conteudo,
  }) {

    return Container(

      padding:
      const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 18,
            spreadRadius: 1,
            offset:
            const Offset(0, 6),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Container(

                padding:
                const EdgeInsets.all(
                  10,
                ),

                decoration:
                BoxDecoration(

                  color: doceRoxo
                      .withOpacity(
                    0.1,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),

                child: Icon(
                  icone,
                  size: 22,
                  color:
                  doceRoxo,
                ),
              ),

              const SizedBox(width: 14),

              Text(

                titulo,

                style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  color:
                  doceRoxo,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          conteudo,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
      String label,
      ) {

    return InputDecoration(

      labelText: label,

      filled: true,

      fillColor:
      Colors.grey.shade50,

      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(
          16,
        ),

        borderSide:
        BorderSide.none,
      ),
    );
  }

  Widget _resumoFinanceiro(
      String label,
      double valor,
      Color cor,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),

      decoration: BoxDecoration(

        color:
        cor.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Column(

        children: [

          Text(

            label,

            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight:
              FontWeight.w600,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          Text(

            "R\$ ${valor.toStringAsFixed(2)}",

            style: TextStyle(
              fontSize: 22,
              fontWeight:
              FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}