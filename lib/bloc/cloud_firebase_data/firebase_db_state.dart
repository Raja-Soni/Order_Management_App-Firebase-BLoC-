import 'package:com.example.order_management_application/model/all_models.dart';
import 'package:equatable/equatable.dart';

import '../../utils/enums.dart';

class FirebaseDbState extends Equatable {
  final Status? apiStatus;
  final List<SalesOrderListItemModel> dataList;
  final String message;
  final Filters filter;
  final int selectedOrderIndex;
  final String searchOrderName;

  const FirebaseDbState({
    this.apiStatus = Status.loading,
    this.dataList = const [],
    this.message = "",
    this.filter = Filters.all,
    this.selectedOrderIndex = 0,
    this.searchOrderName = "",
  });

  FirebaseDbState copyWith({
    Status? apiStatus,
    List<SalesOrderListItemModel>? dataList,
    String? message,
    Filters? filter,
    int? selectedOrderIndex,
    String? searchOrderName,
  }) {
    return FirebaseDbState(
      apiStatus: apiStatus ?? this.apiStatus,
      dataList: dataList ?? this.dataList,
      message: message ?? this.message,
      filter: filter ?? this.filter,
      selectedOrderIndex: selectedOrderIndex ?? this.selectedOrderIndex,
      searchOrderName: searchOrderName ?? this.searchOrderName,
    );
  }

  @override
  List<Object?> get props => [
    apiStatus,
    dataList,
    message,
    filter,
    selectedOrderIndex,
    searchOrderName,
  ];
}
