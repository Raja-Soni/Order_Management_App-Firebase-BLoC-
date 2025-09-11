import 'package:com.example.order_management_application/model/sales_order_list_item_model.dart';
import 'package:equatable/equatable.dart';

import '../../utils/enums.dart';

abstract class FirebaseDbEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchOnlineData extends FirebaseDbEvents {}

class ApplyFilter extends FirebaseDbEvents {
  final Filters filter;
  ApplyFilter({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class DeleteItem extends FirebaseDbEvents {
  final String? id;
  final Filters filter;
  DeleteItem({required this.id, required this.filter});

  @override
  List<Object?> get props => [id];
}

class AddItem extends FirebaseDbEvents {
  final SalesOrderListItemModel? item;
  AddItem({required this.item});
  @override
  List<Object?> get props => [item];
}

class DetailedOrderPage extends FirebaseDbEvents {
  final int selectedOrderIndex;
  DetailedOrderPage({required this.selectedOrderIndex});

  @override
  List<Object?> get props => [selectedOrderIndex];
}

class UpdateSelectedOrderStatus extends FirebaseDbEvents {
  final String id;
  final String updateStatus;
  UpdateSelectedOrderStatus({required this.id, required this.updateStatus});
}
