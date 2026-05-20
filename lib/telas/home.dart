import 'package:flutter/material.dart';
import 'agendamento.dart';
import 'cliente.dart';
import 'decoracao.dart';
import 'controle_agendamento.dart';
import 'relatorio.dart';
import 'lista_mercado.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Padding(
          padding: EdgeInsets.all(18),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              CircleAvatar(
                radius: 30,
                backgroundColor: cor.withOpacity(0.15),

                child: Icon(
                  icone,
                  size: 34,
                  color: cor,
                ),
              ),

              SizedBox(height: 14),

              Text(
                titulo,
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xfff8f3f7),

      body: SafeArea(

        child: Column(
          children: [

            // TOPO
            Container(
              width: double.infinity,

              padding: EdgeInsets.all(25),

              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    Color(0xfff72585),
                    Color(0xffb5179e),
                  ],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                children: [

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: ClipOval(
                      child: Image.asset(
                        'assets/imagem/logo.jpeg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    'Doce Control',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Controle completo da sua confeitaria',

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),

                child: GridView.count(
                  crossAxisCount: 2,

                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,

                  childAspectRatio: 1,

                  children: [

                    itemMenu(
                      context: context,
                      icone: Icons.people,
                      titulo: 'Clientes',
                      tela: ClienteScreen(),
                      cor: Colors.pink,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.cake,
                      titulo: 'Decorações',
                      tela: DecoracaoScreen(),
                      cor: Colors.deepPurple,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.calendar_month,
                      titulo: 'Agendamentos',
                      tela: AgendamentoScreen(),
                      cor: Colors.orange,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.fact_check,
                      titulo: 'Controle',
                      tela: ControleAgendamentoScreen(),
                      cor: Colors.green,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.bar_chart,
                      titulo: 'Relatórios',
                      tela: RelatorioScreen(),
                      cor: Colors.indigo,
                    ),

                    itemMenu(
                      context: context,
                      icone: Icons.shopping_cart,
                      titulo: 'Mercado',
                      tela: ListaMercadoScreen(),
                      cor: Colors.redAccent,
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