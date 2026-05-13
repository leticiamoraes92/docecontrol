import 'package:flutter/material.dart';
import 'agendamento.dart';
import 'cliente.dart';
import 'decoracao.dart';
import 'controle_agendamento.dart';
import 'relatorio.dart';
import 'lista_mercado.dart';

class HomeScreen extends StatelessWidget {

  Widget cardMenu({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required Widget tela,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => tela),
        );
      },

      child: Card(
        elevation: 4,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        child: Container(
          padding: EdgeInsets.all(20),

          child: Row(
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.pink.shade100,

                child: Icon(
                  icone,
                  color: Colors.pink,
                  size: 30,
                ),
              ),

              SizedBox(width: 20),

              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Doce Control"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: ListView(
          children: [

            SizedBox(height: 10),


            Center(
              child: Image.asset(
                'assets/imagem/logo.jpeg',
                height: 160,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Bem-vinda, Letícia 🍩",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Gerencie pedidos, clientes e entregas",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 30),

            cardMenu(
              context: context,
              icone: Icons.people,
              titulo: "Clientes",
              tela: ClienteScreen(),
            ),

            SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.cake,
              titulo: "Decorações",
              tela: DecoracaoScreen(),
            ),

            SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.calendar_month,
              titulo: "Agendamentos",
              tela: AgendamentoScreen(),
            ),

            SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.fact_check,
              titulo: "Controle de Pedidos",
              tela: ControleAgendamentoScreen(),
            ),

            SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.bar_chart,
              titulo: "Relatórios",
              tela: RelatorioScreen(),
            ),

            SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.shopping_cart,
              titulo: "Lista de Mercado",
              tela: ListaMercadoScreen(),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}