import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pedido_model.dart';

class FirebaseService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> salvarPedido(PedidoModel pedido) async {
    try {

      await _db.collection('pedidos').add(pedido.toJson());
      print("Pedido salvo no Firestore com sucesso!");
    } catch (e) {
      print("Erro ao salvar no Firebase: $e");
    }
  }

  Stream<List<PedidoModel>> listarPedidos() {
    return _db.collection('pedidos')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PedidoModel.fromSnapshot(doc))
        .toList());
  }
}