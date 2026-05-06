import 'package:flutter/material.dart';
import '../database/bancodados.dart';

class ListaMercadoScreen extends StatefulWidget {
  const ListaMercadoScreen({super.key});

  @override
  _ListaMercadoScreenState createState() => _ListaMercadoScreenState();
}

class _ListaMercadoScreenState extends State<ListaMercadoScreen> {
  final Color doceRosa = const Color(0xFFF06292); //
  final Color doceRoxo = const Color(0xFF7E57C2); //
  final TextEditingController _itemController = TextEditingController();
  List<Map<String, dynamic>> _itens = [];

  @override
  void initState() {
    super.initState();
    _carregarItens(); //
  }

  void _carregarItens() async {
    final dados = await BancoDados.listarItensMercado(); //
    setState(() {
      _itens = dados;
    });
  }

  void _adicionarItem() async {
    if (_itemController.text.isNotEmpty) {
      await BancoDados.inserirItemMercado(_itemController.text); //
      _itemController.clear();
      _carregarItens();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Lista de Mercado", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: doceRosa,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintText: "Ex: Farinha de trigo, Leite condensado...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _adicionarItem,
                  backgroundColor: doceRoxo, //
                  mini: true,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),

          Expanded(
            child: _itens.isEmpty
                ? const Center(child: Text("Sua lista está vazia!"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _itens.length,
              itemBuilder: (context, index) {
                final item = _itens[index];
                bool comprado = item['comprado'] == 1;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: doceRosa, //
                      value: comprado,
                      onChanged: (val) async {
                        await BancoDados.alternarStatusItem(item['id'], val! ? 1 : 0); //
                        _carregarItens();
                      },
                    ),
                    title: Text(
                      item['item'],
                      style: TextStyle(
                        decoration: comprado ? TextDecoration.lineThrough : null,
                        color: comprado ? Colors.grey : Colors.black87,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () async {
                        await BancoDados.excluirItemMercado(item['id']); //
                        _carregarItens();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}