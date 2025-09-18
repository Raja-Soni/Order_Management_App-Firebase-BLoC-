import 'package:com.example.order_management_application/model/all_models.dart';
import 'package:equatable/equatable.dart';

import '../../utils/enums.dart';

class FirebaseDbState extends Equatable {
  final Status apiStatus;
  final List<SalesOrderListItemModel> dataList;
  final Sorting sortList;
  final String message;
  final Filters filter;
  final int selectedOrderIndex;
  final String searchOrderName;
  final String? selectedDateToSearchOrders;
  final bool isRemoveFilterButtonVisible;

  const FirebaseDbState({
    this.apiStatus = Status.loading,
    this.dataList = const [],
    this.sortList = Sorting.newestFirst,
    this.message = "",
    this.filter = Filters.all,
    this.selectedOrderIndex = 0,
    this.searchOrderName = "",
    this.selectedDateToSearchOrders = null,
    this.isRemoveFilterButtonVisible = false,
  });

  FirebaseDbState copyWith({
    Status? apiStatus,
    List<SalesOrderListItemModel>? dataList,
    String? message,
    Filters? filter,
    int? selectedOrderIndex,
    String? searchOrderName,
    Sorting? sortList,
    String? selectedDateToSearchOrders,
    bool? isRemoveFilterButtonVisible,
  }) {
    return FirebaseDbState(
      apiStatus: apiStatus ?? this.apiStatus,
      dataList: dataList ?? this.dataList,
      sortList: sortList ?? this.sortList,
      message: message ?? this.message,
      filter: filter ?? this.filter,
      selectedOrderIndex: selectedOrderIndex ?? this.selectedOrderIndex,
      searchOrderName: searchOrderName ?? this.searchOrderName,
      selectedDateToSearchOrders:
          selectedDateToSearchOrders ?? this.selectedDateToSearchOrders,
      isRemoveFilterButtonVisible:
          isRemoveFilterButtonVisible ?? this.isRemoveFilterButtonVisible,
    );
  }

  @override
  List<Object?> get props => [
    apiStatus,
    dataList,
    sortList,
    message,
    filter,
    selectedOrderIndex,
    searchOrderName,
    isRemoveFilterButtonVisible,
  ];
}
