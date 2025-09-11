import 'package:equatable/equatable.dart';

abstract class NewOrderEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends NewOrderEvents {}

class CustomerDetailGivenEvent extends NewOrderEvents {
  final String? name;
  final String? phone;
  final String? address;
  CustomerDetailGivenEvent({this.name, this.phone, this.address});

  @override
  List<Object?> get props => [name];
}

class QuantityChangedEvent extends NewOrderEvents {
  final int quantity;
  QuantityChangedEvent({required this.quantity});
  @override
  List<Object?> get props => [quantity];
}

class PriceChangedEvent extends NewOrderEvents {
  final int price;
  PriceChangedEvent({required this.price});

  @override
  List<Object?> get props => [price];
}

class TotalPriceChangedEvent extends NewOrderEvents {}

class OrderDeliveryStatusChangedEvent extends NewOrderEvents {
  final String isDelivered;
  OrderDeliveryStatusChangedEvent({required this.isDelivered});
}

class OrderItemDetailedList extends NewOrderEvents {}

class AddNewOrderEvent extends NewOrderEvents {}

class NewItemDetails extends NewOrderEvents {
  final String? itemName;
  final int? price;
  final int? quantity;
  NewItemDetails({this.price, this.quantity, this.itemName});

  @override
  List<Object?> get props => [itemName, price, quantity];
}

class RemoveItemFromList extends NewOrderEvents {
  final int itemIndex;
  RemoveItemFromList({required this.itemIndex});

  @override
  List<Object?> get props => [itemIndex];
}

class ItemUnitChanged extends NewOrderEvents {
  final String itemUnit;
  ItemUnitChanged({required this.itemUnit});

  @override
  List<Object?> get props => [itemUnit];
}
