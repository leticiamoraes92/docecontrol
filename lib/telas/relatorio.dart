import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RelatorioFinanceiroScreen extends StatefulWidget {
  const RelatorioFinanceiroScreen({super.key});

  @override
  State<RelatorioFinanceiroScreen> createState() =>
      _RelatorioFinanceiroScreenState();
}

class _RelatorioFinanceiroScreenState
    extends State<RelatorioFinanceiroScreen> {

  final Color doceRosa =
  const Color(0xFFF06292);

  final Color doceRoxo =
  const Color(0xFF7E57C2);

  List _pedidosMes = [];

  double _totalFaturado = 0;
  double _totalRecebido = 0;
  double _totalPendente = 0;

  int _mesSelecionado =
      DateTime.now().month;

  int _anoSelecionado =
      DateTime.now().year;

  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _atualizarRelatorio();
  }

  void _atualizarRelatorio() async {

    setState(() {
      carregando = true;
    });

    final dados =
    await BancoDados.buscarRelatorioMensal(
      _mesSelecionado,
      _anoSelecionado,
    );

    setState(() {

      _pedidosMes = dados;

      _totalFaturado =
          dados.fold(
            0,
                (sum, item) =>
            sum + (item['total'] ?? 0),
          );

      _totalRecebido =
          dados.fold(
            0,
                (sum, item) =>
            sum + (item['entrada'] ?? 0),
          );

      _totalPendente =
          _totalFaturado -
              _totalRecebido;

      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xfff8f5f9),

      appBar: AppBar(

        centerTitle: true,

        title: const Text(

          "Relatório Financeiro",

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

        actions: [

          IconButton(

            icon: const Icon(
              Icons.picture_as_pdf,
            ),

            onPressed:
            _gerarRelatorioPdf,
          ),
        ],
      ),

      body: carregando

          ? Center(
        child:
        CircularProgressIndicator(
          color: doceRosa,
        ),
      )

          : Column(

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

            child: Column(

              children: [

                Container(

                  padding:
                  const EdgeInsets.all(18),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),

                    boxShadow: [

                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.08,
                        ),

                        blurRadius: 18,

                        offset:
                        const Offset(
                          0,
                          6,
                        ),
                      ),
                    ],
                  ),

                  child:
                  _seletorPeriodo(),
                ),

                const SizedBox(height: 18),

                // RESUMO
                _cardsResumo(),
              ],
            ),
          ),

          // LISTA
          Expanded(
            child:
            _listaDetalhada(),
          ),
        ],
      ),
    );
  }

  Widget _seletorPeriodo() {

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
      "Dezembro"
    ];

    return Row(

      children: [

        // MÊS
        Expanded(

          child: DropdownButtonFormField<int>(

            value: _mesSelecionado,

            decoration: InputDecoration(

              labelText: "Mês",

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
            ),

            items: List.generate(

              12,

                  (i) =>
                  DropdownMenuItem(

                    value: i + 1,

                    child: Text(
                      meses[i],
                    ),
                  ),
            ),

            onChanged: (val) {

              setState(() {
                _mesSelecionado = val!;
              });

              _atualizarRelatorio();
            },
          ),
        ),

        const SizedBox(width: 14),

        Expanded(

          child: DropdownButtonFormField<int>(

            value: _anoSelecionado,

            decoration: InputDecoration(

              labelText: "Ano",

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
            ),

            items: [
              2025,
              2026,
              2027,
            ].map(

                  (ano) =>
                  DropdownMenuItem(

                    value: ano,

                    child: Text(
                      ano.toString(),
                    ),
                  ),
            ).toList(),

            onChanged: (val) {

              setState(() {
                _anoSelecionado = val!;
              });

              _atualizarRelatorio();
            },
          ),
        ),
      ],
    );
  }

  Widget _cardsResumo() {

    return Column(

      children: [

        _itemResumo(
          "FATURAMENTO TOTAL",
          _totalFaturado,
          Colors.white,
          Colors.black87,
        ),

        const SizedBox(height: 12),

        Row(

          children: [

            Expanded(
              child: _itemResumo(
                "RECEBIDO",
                _totalRecebido,
                Colors.white,
                Colors.green,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _itemResumo(
                "PENDENTE",
                _totalPendente,
                Colors.white,
                doceRosa,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _itemResumo(
      String label,
      double valor,
      Color fundo,
      Color corValor,
      ) {

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: fundo,

        borderRadius:
        BorderRadius.circular(22),

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.06,
            ),

            blurRadius: 14,

            offset:
            const Offset(0, 5),
          ),
        ],
      ),

      child: Column(

        children: [

          Text(

            label,

            style: const TextStyle(
              fontSize: 11,
              fontWeight:
              FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 8),

          Text(

            "R\$ ${valor.toStringAsFixed(2)}",

            style: TextStyle(
              fontSize: 24,
              fontWeight:
              FontWeight.bold,
              color: corValor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaDetalhada() {

    return _pedidosMes.isEmpty

        ? const Center(
      child: Text(
        "Nenhum dado encontrado.",
      ),
    )

        : ListView.builder(

      padding:
      const EdgeInsets.all(16),

      itemCount:
      _pedidosMes.length,

      itemBuilder:
          (context, index) {

        final p =
        _pedidosMes[index];

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
                color: Colors.black
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
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),

            leading:
            CircleAvatar(

              backgroundColor:
              doceRoxo.withOpacity(
                0.12,
              ),

              child: Icon(
                Icons
                    .attach_money_outlined,
                color: doceRoxo,
              ),
            ),

            title: Text(

              p['nome_cliente']
                  ?? "Cliente",

              style:
              const TextStyle(
                fontWeight:
                FontWeight.w600,
              ),
            ),

            subtitle: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 4),

                Text(
                  p['nome_doce']
                      ?? "-",
                ),

                Text(
                  p['data'],
                ),
              ],
            ),

            trailing: Text(

              "R\$ ${p['total'].toStringAsFixed(2)}",

              style: const TextStyle(
                fontWeight:
                FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }

  // PDF
  Future<void>
  _gerarRelatorioPdf() async {

    final pdf = pw.Document();

    pdf.addPage(

      pw.Page(

        build:
            (pw.Context context) {

          return pw.Column(

            crossAxisAlignment:
            pw.CrossAxisAlignment.start,

            children: [

              pw.Text(

                "DOCE CONTROL",

                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight:
                  pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Text(
                "Relatório Financeiro",
              ),

              pw.Text(
                "Período: $_mesSelecionado/$_anoSelecionado",
              ),

              pw.Divider(),

              pw.SizedBox(height: 12),

              pw.Text(
                "Resumo Financeiro",
                style: pw.TextStyle(
                  fontWeight:
                  pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                "Faturamento Total: R\$ ${_totalFaturado.toStringAsFixed(2)}",
              ),

              pw.Text(
                "Total Recebido: R\$ ${_totalRecebido.toStringAsFixed(2)}",
              ),

              pw.Text(
                "Total Pendente: R\$ ${_totalPendente.toStringAsFixed(2)}",
              ),

              pw.SizedBox(height: 24),

              pw.Table.fromTextArray(

                context: context,

                headers: [
                  'Data',
                  'Cliente',
                  'Doce',
                  'Total'
                ],

                data:
                _pedidosMes.map(
                      (p) {

                    return [

                      p['data']
                          .toString(),

                      p['nome_cliente']
                          .toString(),

                      p['nome_doce']
                          .toString(),

                      "R\$ ${p['total']}",
                    ];
                  },
                ).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(

      onLayout:
          (format) async =>
          pdf.save(),
    );
  }
}