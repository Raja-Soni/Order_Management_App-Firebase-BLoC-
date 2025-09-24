import 'dart:typed_data';

import 'package:com.example.order_management_application/model/all_models.dart';
import 'package:equatable/equatable.dart';

class NewOrderState extends Equatable {
  final String customerName;
  final String customerPhone;
  final String address;
  late final String itemName;
  late final int quantity;
  late final int price;
  final String isDelivered;
  final int totalPrice;
  final String? localImagePath;
  final Uint8List? webLocalItemImage;
  final List<NewOrderDetailsItemModel> itemDetails;
  final String selectedUnit;
  final bool isUpdatingItemDetails;
  final units = ['kg', 'g', 'L', 'ml', 'pc', 'dozen', 'box', 'meter', 'cm'];

  NewOrderState({
    this.customerName = "",
    this.customerPhone = "",
    this.address = "",
    this.itemName = "",
    this.quantity = 0,
    this.price = 0,
    this.totalPrice = 0,
    this.isDelivered = "Pending",
    this.itemDetails = const [],
    this.selectedUnit = 'kg',
    this.localImagePath,
    this.webLocalItemImage = null,
    this.isUpdatingItemDetails = false,
  });

  NewOrderState copyWith({
    String? customerName,
    String? customerPhone,
    String? address,
    String? itemName,
    int? quantity,
    int? price,
    String? isDelivered,
    int? totalPrice,
    List<NewOrderDetailsItemModel>? itemDetails,
    String? selectedUnit,
    String? localImagePath,
    Uint8List? webLocalItemImage,
    bool clearWebImage = false,
    bool? isUpdatingItemDetails,
  }) {
    return NewOrderState(
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      address: address ?? this.address,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      isDelivered: isDelivered ?? this.isDelivered,
      totalPrice: totalPrice ?? this.totalPrice,
      itemDetails: itemDetails ?? this.itemDetails,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      localImagePath: localImagePath ?? this.localImagePath,
      webLocalItemImage: clearWebImage
          ? null
          : webLocalItemImage ?? this.webLocalItemImage,
      isUpdatingItemDetails:
          isUpdatingItemDetails ?? this.isUpdatingItemDetails,
    );
  }

  @override
  List<Object?> get props => [
    customerName,
    customerPhone,
    address,
    itemName,
    quantity,
    price,
    isDelivered,
    totalPrice,
    itemDetails,
    selectedUnit,
    localImagePath,
    webLocalItemImage,
    isUpdatingItemDetails,
  ];
}
