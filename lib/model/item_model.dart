import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class NewOrderDetailsItemModel extends Equatable {
  final String? itemName;
  final int? quantity;
  final String? localItemImage;
  final Uint8List? webLocalItemImage;
  String? imageUrl;
  final String? unit;
  final int? price;
  final int? totalItemsPrice;

  NewOrderDetailsItemModel({
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.unit,
    required this.totalItemsPrice,
    this.localItemImage,
    this.webLocalItemImage,
    this.imageUrl,
  });

  factory NewOrderDetailsItemModel.fromJson(Map<String, dynamic> json) {
    return NewOrderDetailsItemModel(
      itemName: json['itemName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      quantity: json['quantity'] as int?,
      unit: json['unit'] as String?,
      price: json['price'] as int?,
      totalItemsPrice: json['totalItemsPrice'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'totalItemsPrice': totalItemsPrice,
    };
  }

  @override
  List<Object?> get props => [
    itemName,
    localItemImage,
    webLocalItemImage,
    imageUrl,
    quantity,
    unit,
    price,
    totalItemsPrice,
  ];
}
