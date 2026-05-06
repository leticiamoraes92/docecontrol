import 'package:flutter/material.dart';
import '../database/bancodados.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RelatorioFinanceiroScreen extends StatefulWidget {
  @override
  _RelatorioFinanceiroScreenState createState() => _RelatorioFinanceiroScreenState();
}

class _RelatorioFinanceiroScreenState extends State<RelatorioFinanceiroScreen> {
  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  List _pedidosMes = [];
  double _totalFaturado = 0;
  double _totalRecebido = 0;
  double _totalPendente = 0;


  int _mesSelecionado = DateTime.now().month;
  int _anoSelecionado = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _atualizarRelatorio();
  }


  void _atualizarRelatorio() async {
    final dados = await BancoDados.buscarRelatorioMensal(_mesSelecionado, _anoSelecionado);

    setState(() {
      _pedidosMes = dados;

      _totalFaturado = dados.fold(0, (sum, item) => sum + (item['total'] ?? 0));
      _totalRecebido = dados.fold(0, (sum, item) => sum + (item['entrada'] ?? 0));
      _totalPendente = _totalFaturado - _totalRecebido;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Relatório Mensal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: doceRosa,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _gerarRelatorioPdf,
          )
        ],
      ),
      body: Column(
        children: [
          _seletorPeriodo(),
          _cardsResumo(),
          Expanded(child: _listaDetalhada()),
        ],
      ),
    );
  }

  Widget _seletorPeriodo() {
    final meses = [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<int>(
              value: _mesSelecionado,
              isExpanded: true,
              items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(meses[i]))),
              onChanged: (val) {
                setState(() => _mesSelecionado = val!);
                _atualizarRelatorio();
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: DropdownButton<int>(
              value: _anoSelecionado,
              isExpanded: true,
              items: [2025, 2026, 2027].map((ano) => DropdownMenuItem(value: ano, child: Text(ano.toString()))).toList(),
              onChanged: (val) {
                setState(() => _anoSelecionado = val!);
                _atualizarRelatorio();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardsResumo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _itemResumo("FATURAMENTO TOTAL", _totalFaturado, Colors.black),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _itemResumo("RECEBIDO", _totalRecebido, Colors.green)),
              const SizedBox(width: 10),
              Expanded(child: _itemResumo("PENDENTE", _totalPendente, doceRosa)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemResumo(String label, double valor, Color cor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          Text("R\$ ${valor.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cor)),
        ],
      ),
    );
  }

  Widget _listaDetalhada() {
    return _pedidosMes.isEmpty
        ? const Center(child: Text("Nenhum dado para este período."))
        : ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _pedidosMes.length,
      itemBuilder: (context, index) {
        final p = _pedidosMes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(p['nome_cliente'] ?? "Cliente"),
            subtitle: Text(p['data']),
            trailing: Text("R\$ ${p['total'].toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Future<void> _gerarRelatorioPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Doce Control - Relatório Financeiro", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Text("Período: $_mesSelecionado/$_anoSelecionado"),
            pw.Divider(),
            pw.Text("Resumo Mensal:"),
            pw.Text("Total Faturado: R\$ ${_totalFaturado.toStringAsFixed(2)}"),
            pw.Text("Total Recebido: R\$ ${_totalRecebido.toStringAsFixed(2)}"),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Data', 'Cliente', 'Doce', 'Total'],
                ..._pedidosMes.map((p) => [p['data'], p['nome_cliente'], p['nome_doce'], "R\$ ${p['total']}"])
              ],
            ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}