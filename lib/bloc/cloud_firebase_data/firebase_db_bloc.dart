import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:com.example.order_management_application/bloc/cloud_firebase_data/firebase_bloc_events_state.dart';
import 'package:com.example.order_management_application/database/online_firebase/online_firebase.dart';

import '../../model/sales_order_list_item_model.dart';
import '../../utils/enums.dart';

class FirebaseDbBloc extends Bloc<FirebaseDbEvents, FirebaseDbState> {
  OnlineDataBase dataBase = OnlineDataBase();
  List<SalesOrderListItemModel> tempList = [];
  FirebaseDbBloc() : super(FirebaseDbState()) {
    on<InitialDashboardPageState>(initialDashboardPageState);
    on<FetchOnlineData>(fetchOnlineData);
    on<ApplyFilter>(applyFilter);
    on<DeleteItem>(deleteItem);
    on<AddItem>(addItem);
    on<SearchOrderEvent>(searchOrderEvent);
    on<OrderToFindNameChangedEvent>(orderToFindNameChangedEvent);
    on<DetailedOrderPage>(detailedOrderPage);
    on<UpdateSelectedOrderStatus>(updateSelectedOrderStatus);
  }

  void fetchOnlineData(
    FetchOnlineData event,
    Emitter<FirebaseDbState> emit,
  ) async {
    try {
      final value = await dataBase.fetchData();
      tempList = value;
      emit(
        state.copyWith(
          dataList: List.from(tempList),
          message: "Data fetch Success",
          apiStatus: Status.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(apiStatus: Status.failure, message: e.toString()));
    }
  }

  List<SalesOrderListItemModel> getFilterList({
    required Filters filter,
    required List<SalesOrderListItemModel> value,
  }) {
    if (filter == Filters.all) {
      return value;
    } else if (filter == Filters.today) {
      return value
          .where(
            (item) =>
                item.dateAndTime.toString().split(" ").first ==
                DateTime.now().toString().split(" ").first,
          )
          .toList();
    } else if (filter == Filters.delivered) {
      return value.where((item) => item.status == "Delivered").toList();
    } else if (filter == Filters.pending) {
      return value.where((item) => item.status == "Pending").toList();
    } else if (filter == Filters.cancelled) {
      return value.where((item) => item.status == "Cancelled").toList();
    } else {
      return [];
    }
  }

  applyFilter(ApplyFilter event, Emitter<FirebaseDbState> emit) async {
    emit(state.copyWith(apiStatus: Status.loading, message: "loading"));
    await dataBase.fetchData().then((value) {
      tempList = getFilterList(filter: event.filter, value: value);
      emit(
        state.copyWith(
          dataList: List.from(tempList),
          message: "Filter applied",
          apiStatus: Status.success,
          filter: event.filter,
        ),
      );
    });
  }

  FutureOr<void> initialDashboardPageState(
    InitialDashboardPageState event,
    Emitter<FirebaseDbState> emit,
  ) {
    emit(
      state.copyWith(searchOrderName: '', message: "DashBoard Page Refresh"),
    );
  }

  addItem(AddItem event, Emitter<FirebaseDbState> emit) async {
    emit(state.copyWith(apiStatus: Status.loading));
    await dataBase.addItem(event.item!);
    await dataBase.fetchData().then((value) {
      tempList = List.from(value);
      emit(
        state.copyWith(
          dataList: List.from(tempList),
          apiStatus: Status.success,
          message: "Item added",
          filter: Filters.all,
        ),
      );
    });
  }

  deleteItem(DeleteItem event, Emitter<FirebaseDbState> emit) async {
    emit(state.copyWith(apiStatus: Status.loading));
    String? id = event.id;
    await dataBase.deleteItem(id!);
    await dataBase.fetchData().then((value) {
      tempList = getFilterList(filter: event.filter, value: value);
      emit(
        state.copyWith(
          dataList: List.from(tempList),
          apiStatus: Status.success,
          message: "Item Deleted",
          filter: state.filter,
        ),
      );
    });
  }

  FutureOr<void> orderToFindNameChangedEvent(
    OrderToFindNameChangedEvent event,
    Emitter<FirebaseDbState> emit,
  ) {
    emit(
      state.copyWith(
        searchOrderName: event.orderToFindName.toString().toLowerCase(),
      ),
    );
  }

  FutureOr<void> searchOrderEvent(
    SearchOrderEvent event,
    Emitter<FirebaseDbState> emit,
  ) async {
    emit(state.copyWith(apiStatus: Status.loading));
    await dataBase.fetchData().then((value) {
      tempList = getFilterList(filter: state.filter, value: value);
      tempList = tempList
          .where(
            (order) => order.customer!.toLowerCase().contains(
              state.searchOrderName.toLowerCase(),
            ),
          )
          .toList();
      emit(
        state.copyWith(
          dataList: List.from(tempList),
          apiStatus: Status.success,
          message: "Order Search Complete",
        ),
      );
    });
  }

  FutureOr<void> updateSelectedOrderStatus(
    UpdateSelectedOrderStatus event,
    Emitter<FirebaseDbState> emit,
  ) async {
    emit(state.copyWith(apiStatus: Status.loading));
    await dataBase.updateStatus(event.id, event.updateStatus);
    await dataBase.fetchData().then((value) {
      tempList = List.from(value);
      emit(
        state.copyWith(
          dataList: List.from(tempList),
          apiStatus: Status.success,
          message: "Status Updated",
        ),
      );
    });
  }

  FutureOr<void> detailedOrderPage(
    DetailedOrderPage event,
    Emitter<FirebaseDbState> emit,
  ) {
    emit(state.copyWith(selectedOrderIndex: event.selectedOrderIndex));
  }
}
