import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/all_models.dart';

class OnlineDataBase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _getUserOrdersRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return _db.collection("users").doc(user.uid).collection("orders");
  }

  Future<List<SalesOrderListItemModel>> fetchData() async {
    final snapshot = await _getUserOrdersRef()
        .orderBy("datetime", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SalesOrderListItemModel(
        id: doc.id,
        customer: data['customer'] ?? "",
        customerPhone: data['phone'] ?? "",
        address: data['address'] ?? "",
        amount: data['amount'] ?? 0,
        status: data['status'] ?? "",
        dateAndTime: (data['datetime'] is Timestamp)
            ? (data['datetime'] as Timestamp).toDate().toString()
            : data['datetime'].toString(),
        newOrderDetails: (data['orderdetail'] as List<dynamic>? ?? [])
            .map((item) => NewOrderDetailsItemModel.fromJson(item))
            .toList(),
      );
    }).toList();
  }

  Future<void> addItem(SalesOrderListItemModel item) async {
    await _getUserOrdersRef().add({
      "customer": item.customer,
      "phone": item.customerPhone,
      "address": item.address,
      "amount": item.amount,
      "status": item.status,
      "datetime": DateTime.now(),
      "orderdetail": item.newOrderDetails?.map((e) => e.toJson()).toList(),
    });
  }

  Future<void> deleteItem(String id) async {
    await _getUserOrdersRef().doc(id).delete();
  }

  Future<void> updateStatus(String id, String newStatus) async {
    await _getUserOrdersRef().doc(id).update({"status": newStatus});
  }
}
