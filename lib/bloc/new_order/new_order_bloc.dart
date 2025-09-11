import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:com.example.order_management_application/bloc/cloud_firebase_data/firebase_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/new_order/new_order_bloc_events_state.dart';
import 'package:com.example.order_management_application/model/all_models.dart';

class NewOrderBloc extends Bloc<NewOrderEvents, NewOrderState> {
  FirebaseDbBloc apiBloc;
  NewOrderBloc(this.apiBloc) : super(NewOrderState()) {
    on<InitialState>(initialState);
    on<CustomerDetailGivenEvent>(customerDetailGivenEvent);
    on<TotalPriceChangedEvent>(totalPriceChangedEvent);
    on<OrderDeliveryStatusChangedEvent>(orderDeliveryStatusChangedEvent);
    on<OrderItemDetailedList>(orderItemDetailedList);
    on<AddNewOrderEvent>(addNewOrderEvent);
    on<ItemUnitChanged>(itemUnitChanged);
    on<RemoveItemFromList>(removeItemFromList);
    on<NewItemDetails>(newItemDetails);
  }

  FutureOr<void> initialState(InitialState event, Emitter<NewOrderState> emit) {
    emit(
      state.copyWith(totalPrice: 0, isDelivered: "Pending", itemDetails: []),
    );
  }

  FutureOr<void> customerDetailGivenEvent(
    CustomerDetailGivenEvent event,
    Emitter<NewOrderState> emit,
  ) {
    emit(
      state.copyWith(
        customerName: event.name,
        customerPhone: event.phone,
        address: event.address,
      ),
    );
  }

  FutureOr<void> totalPriceChangedEvent(
    TotalPriceChangedEvent event,
    Emitter<NewOrderState> emit,
  ) {
    int totalPrice = state.itemDetails.fold(
      0,
      (previousValue, element) =>
          previousValue + (element.totalItemsPrice ?? 0),
    );
    emit(state.copyWith(totalPrice: totalPrice));
  }

  addNewOrderEvent(AddNewOrderEvent event, Emitter<NewOrderState> emit) async {
    SalesOrderListItemModel newOrderItem = SalesOrderListItemModel(
      customer: state.customerName,
      customerPhone: state.customerPhone,
      address: state.address,
      amount: state.totalPrice,
      status: state.isDelivered,
      dateAndTime: DateTime.now().toString(),
      newOrderDetails: state.itemDetails,
    );
    apiBloc.add(AddItem(item: newOrderItem));
  }

  FutureOr<void> orderDeliveryStatusChangedEvent(
    OrderDeliveryStatusChangedEvent event,
    Emitter<NewOrderState> emit,
  ) {
    emit(state.copyWith(isDelivered: event.isDelivered));
  }

  FutureOr<void> orderItemDetailedList(
    OrderItemDetailedList event,
    Emitter<NewOrderState> emit,
  ) {
    final List<NewOrderDetailsItemModel> updatedList =
        List.from(state.itemDetails)..add(
          NewOrderDetailsItemModel(
            itemName: state.itemName,
            quantity: state.quantity,
            unit: state.selectedUnit,
            price: state.price,
            totalItemsPrice: (state.quantity * state.price),
          ),
        );
    emit(
      state.copyWith(
        itemDetails: updatedList,
        price: 0,
        quantity: 0,
        selectedUnit: 'kg',
        itemName: "",
        totalPrice: 0,
      ),
    );
  }

  FutureOr<void> removeItemFromList(
    RemoveItemFromList event,
    Emitter<NewOrderState> emit,
  ) {
    final List<NewOrderDetailsItemModel> updatedList = List.from(
      state.itemDetails,
    );
    updatedList.removeAt(event.itemIndex);
    emit(state.copyWith(itemDetails: updatedList));
  }

  FutureOr<void> newItemDetails(
    NewItemDetails event,
    Emitter<NewOrderState> emit,
  ) {
    emit(
      state.copyWith(
        itemName: event.itemName,
        price: event.price,
        quantity: event.quantity,
      ),
    );
  }

  FutureOr<void> itemUnitChanged(
    ItemUnitChanged event,
    Emitter<NewOrderState> emit,
  ) {
    emit(state.copyWith(selectedUnit: event.itemUnit));
  }
}
