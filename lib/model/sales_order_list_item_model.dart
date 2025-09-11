import 'package:com.example.order_management_application/model/all_models.dart';
import 'package:equatable/equatable.dart';

class SalesOrderListItemModel extends Equatable {
  final String? id;
  final String? customer;
  final String? customerPhone;
  final String? address;
  final int? amount;
  final String? status;
  final String? dateAndTime;
  final List<NewOrderDetailsItemModel>? newOrderDetails;

  const SalesOrderListItemModel({
    this.id,
    required this.customer,
    required this.customerPhone,
    required this.address,
    required this.amount,
    required this.status,
    required this.dateAndTime,
    required this.newOrderDetails,
  });

  @override
  List<Object?> get props => [
    id,
    customer,
    customerPhone,
    address,
    amount,
    status,
    dateAndTime,
    newOrderDetails,
  ];
}
