import 'package:flutter/material.dart';
import 'agendamento.dart';
import 'cliente.dart';
import 'decoracao.dart';
import 'controle_agendamento.dart';
import 'relatorio.dart';
import 'lista_mercado.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color doceRosa = const Color(0xFFF06292);
  final Color doceRoxo = const Color(0xFF7E57C2);

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            height: screenHeight * 0.28,
            decoration: BoxDecoration(
              color: doceRosa,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: doceRosa.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/imagem/logo.jpeg',

                    height: screenHeight * 0.14,
                    width: screenHeight * 0.14,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.cake, size: 70, color: doceRosa),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
              child: GridView.count(

                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,

                childAspectRatio: 1.35,
                children: [
                  _itemMenu(context, "Clientes", Icons.people_alt_rounded, doceRoxo, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteScreen()));
                  }),
                  _itemMenu(context, "Doces", Icons.auto_awesome_mosaic_rounded, doceRosa, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DecoracaoScreen()));
                  }),
                  _itemMenu(context, "Agendar", Icons.calendar_month_rounded, doceRosa, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AgendamentoScreen()));
                  }),
                  _itemMenu(context, "Controle", Icons.analytics_rounded, doceRoxo, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ControleAgendamentoScreen()));
                  }),
                  _itemMenu(context, "Financeiro", Icons.bar_chart_rounded, Colors.green[400]!, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RelatorioFinanceiroScreen()));
                  }),
                  _itemMenu(context, "Mercado", Icons.shopping_basket_rounded, Colors.orange[400]!, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListaMercadoScreen()));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemMenu(BuildContext context, String rotulo, IconData icone, Color cor, VoidCallback acao) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: acao,
          borderRadius: BorderRadius.circular(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 32, color: cor),
              const SizedBox(height: 8),
              Text(
                rotulo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}