import 'package:flutter/material.dart';
import 'agendamento.dart';
import 'cliente.dart';
import 'decoracao.dart';
import 'controle_agendamento.dart';
import 'relatorio.dart';
import 'lista_mercado.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        elevation: 5,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        child: Container(
          padding: const EdgeInsets.all(20),

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

              const SizedBox(width: 20),

              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF8F4F8),

      appBar: AppBar(
        title: const Text("Doce Control"),
        centerTitle: true,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [

            const SizedBox(height: 10),

            Center(
              child: Image.asset(
                'assets/imagem/logo.jpeg',
                height: 170,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Bem-vinda, Letícia 🍩",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Gerencie pedidos, clientes, entregas e pagamentos",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 30),

            cardMenu(
              context: context,
              icone: Icons.people,
              titulo: "Clientes",
              tela: ClienteScreen(),
            ),

            const SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.cake,
              titulo: "Decorações",
              tela: DecoracaoScreen(),
            ),

            const SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.calendar_month,
              titulo: "Agendamentos",
              tela: AgendamentoScreen(),
            ),

            const SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.fact_check,
              titulo: "Controle de Pedidos",
              tela: ControleAgendamentoScreen(),
            ),

            const SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.bar_chart,
              titulo: "Relatórios",
              tela: RelatorioFinanceiroScreen(),
            ),

            const SizedBox(height: 15),

            cardMenu(
              context: context,
              icone: Icons.shopping_cart,
              titulo: "Lista de Mercado",
              tela: ListaMercadoScreen(),
            ),

            const SizedBox(height: 30),

            Card(
              color: Colors.pink.shade50,
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Padding(
                padding: EdgeInsets.all(18),

                child: Column(
                  children: [

                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 40,
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Doce Control",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Sistema de gerenciamento para confeitaria",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}