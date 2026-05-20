import 'package:flutter/material.dart';
import 'agendamento.dart';
import 'cliente.dart';
import 'decoracao.dart';
import 'controle_agendamento.dart';
import 'relatorio.dart';
import 'lista_mercado.dart';

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
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: cor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icone,
                color: cor,
                size: 34,
              ),
            ),

            SizedBox(height: 18),

            Text(
              titulo,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardInfo({
    required IconData icon,
    required String titulo,
    required String valor,
    required Color cor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),

        padding: EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),

        child: Column(
          children: [

            Icon(
              icon,
              color: cor,
              size: 28,
            ),

            SizedBox(height: 10),

            Text(
              valor,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text(
              titulo,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
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
        child: ListView(
          children: [

            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 30),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfff72585),
                    Color(0xffb5179e),
                  ],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),

              child: Column(
                children: [

                  // LOGO MELHORADO
                  Container(
                    padding: EdgeInsets.all(6),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                        ),
                      ],
                    ),

                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,

                      backgroundImage: AssetImage(
                        'assets/imagem/logo.jpeg',
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Controle completo da sua confeitaria",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 28),

                  Row(
                    children: [

                      cardInfo(
                        icon: Icons.shopping_bag,
                        titulo: "Pedidos",
                        valor: "0",
                        cor: Colors.pink,
                      ),

                      cardInfo(
                        icon: Icons.attach_money,
                        titulo: "Faturamento",
                        valor: "R\$ 0.00",
                        cor: Colors.green,
                      ),

                      cardInfo(
                        icon: Icons.pending_actions,
                        titulo: "Pendentes",
                        valor: "0",
                        cor: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20),

              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                crossAxisCount: 2,

                crossAxisSpacing: 18,
                mainAxisSpacing: 18,

                childAspectRatio: 1.05,

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}