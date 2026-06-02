import 'package:flutter/material.dart';
import 'agendamento.dart';
import 'cliente.dart';
import 'decoracao.dart';
import 'controle_agendamento.dart';
import 'relatorio.dart';
import 'lista_mercado.dart';
import 'configuracoes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {

  Widget itemMenu({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required Widget tela,
    required Color cor,
  }) {

    return GestureDetector(

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => tela),
        );
      },

      child: Container(

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: cor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icone,
                color: cor,
                size: 24,
              ),
            ),

            SizedBox(height: 10),

            Text(
              titulo,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xfff8f5f9),

      body: SafeArea(

        child: Column(
          children: [

            // TOPO
            Container(

              padding: EdgeInsets.fromLTRB(18, 12, 18, 16),

              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    Color(0xfff72585),
                    Color(0xffb5179e),
                  ],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),

              child: Column(
                children: [

                  Container(

                    padding: EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),

                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,

                      backgroundImage: AssetImage(
                        'assets/imagem/logo.jpeg',
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Controle completo da sua confeitaria",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // MENU
            Expanded(
              child: Padding(

                padding: EdgeInsets.all(14),

                child: GridView.count(

                  physics: BouncingScrollPhysics(),

                  crossAxisCount: 2,

                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,

                  childAspectRatio: 1.28,

                  children: [

                    itemMenu(
                      context: context,
                      icone: Icons.calendar_month,
                      titulo: "Agendamentos",
                      tela: AgendamentoScreen(),
                      cor: Colors.orange,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.fact_check,
                      titulo: "Pedidos",
                      tela: ControleAgendamentoScreen(),
                      cor: Colors.green,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.people,
                      titulo: "Clientes",
                      tela: ClienteScreen(),
                      cor: Colors.pink,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.cake,
                      titulo: "Decorações",
                      tela: DecoracaoScreen(),
                      cor: Colors.deepPurple,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.bar_chart,
                      titulo: "Financeiro",
                      tela: RelatorioFinanceiroScreen(),
                      cor: Colors.indigo,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.shopping_cart,
                      titulo: "Mercado",
                      tela: ListaMercadoScreen(),
                      cor: Colors.redAccent,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.settings,
                      titulo: "Configurações",
                      tela: ConfiguracoesScreen(),
                      cor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}