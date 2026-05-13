import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoModel {
  String? id;
  String cliente;
  String doce;
  int quantidade;
  double total;
  String data;
  String status;

  PedidoModel({
    this.id,
    required this.cliente,
    required this.doce,
    required this.quantidade,
    required this.total,
    required this.data,
    this.status = 'Pendente',
  });

  Map<String, dynamic> toJson() {
    return {
      'cliente': cliente,
      'doce': doce,
      'quantidade': quantidade,
      'total': total,
      'data': data,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory PedidoModel.fromSnapshot(DocumentSnapshot doc) {
    return PedidoModel(
      id: doc.id,
      cliente: doc['cliente'],
      doce: doc['doce'],
      quantidade: doc['quantidade'],
      total: doc['total'],
      data: doc['data'],
      status: doc['status'],
    );
  }
}