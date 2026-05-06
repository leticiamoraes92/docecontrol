import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pedido_model.dart'; // Importe seu model aqui

class FirebaseService {
  // 1. Instância do Firestore (a "ponte" para o banco NoSQL)
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 2. Função para SALVAR um pedido (Create)
  Future<void> salvarPedido(PedidoModel pedido) async {
    try {
      // O Danilo explicou que usamos coleções para organizar os documentos JSON
      await _db.collection('pedidos').add(pedido.toJson());
      print("Pedido salvo no Firestore com sucesso!");
    } catch (e) {
      print("Erro ao salvar no Firebase: $e");
    }
  }

  // 3. Função para LISTAR pedidos em tempo real (Read)
  Stream<List<PedidoModel>> listarPedidos() {
    // O snapshot permite a sincronização em tempo real que o Danilo destacou
    return _db.collection('pedidos')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PedidoModel.fromSnapshot(doc))
        .toList());
  }
}