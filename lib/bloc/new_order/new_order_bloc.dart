import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.example.order_management_application/bloc/cloud_firebase_data/firebase_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/new_order/new_order_bloc_events_state.dart';
import 'package:com.example.order_management_application/model/all_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewOrderBloc extends Bloc<NewOrderEvents, NewOrderState> {
  FirebaseDbBloc apiBloc;
  NewOrderBloc(this.apiBloc) : super(NewOrderState()) {
    on<InitialState>(initialState);
    on<ResetImageOnDialog>(resetImageOnDialog);
    on<CustomerDetailGivenEvent>(customerDetailGivenEvent);
    on<TotalPriceChangedEvent>(totalPriceChangedEvent);
    on<OrderDeliveryStatusChangedEvent>(orderDeliveryStatusChangedEvent);
    on<OrderItemDetailedList>(orderItemDetailedList);
    on<AddNewOrderEvent>(addNewOrderEvent);
    on<IsUpdatingItem>(isUpdatingItem);
    on<ItemUnitChanged>(itemUnitChanged);
    on<RemoveItemFromList>(removeItemFromList);
    on<UpdateItemFromList>(updateItemFromList);
    on<NewItemDetails>(newItemDetails);
    on<PickItemImage>(pickItemImage);
  }

  FutureOr<void> initialState(InitialState event, Emitter<NewOrderState> emit) {
    emit(
      state.copyWith(
        totalPrice: 0,
        isDelivered: "Pending",
        itemDetails: [],
        localImagePath: '',
        clearWebImage: true,
        address: '',
        customerPhone: '',
        itemName: '',
        quantity: 0,
        price: 0,
        customerName: '',
      ),
    );
  }

  FutureOr<void> resetImageOnDialog(
    ResetImageOnDialog event,
    Emitter<NewOrderState> emit,
  ) {
    emit(state.copyWith(clearWebImage: true, localImagePath: null));
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
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ordersRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders");

    // Generate a new document reference with a unique ID
    final orderDoc = ordersRef.doc(); // Firestore auto ID
    final orderId = orderDoc.id;

    // Upload images
    for (var item in state.itemDetails) {
      if (item.localItemImage != null) {
        final fileName =
            '${item.itemName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        try {
          if (kIsWeb) {
            final bytes = item.webLocalItemImage!;
            await Supabase.instance.client.storage
                .from('order_images')
                .uploadBinary('$uid/$orderId/items/$fileName', bytes);
          } else {
            final file = File(item.localItemImage!);
            await Supabase.instance.client.storage
                .from('order_images')
                .upload('$uid/$orderId/items/$fileName', file);
          }

          // Get public web image URL
          final urlResponse = Supabase.instance.client.storage
              .from('order_images')
              .getPublicUrl('$uid/$orderId/items/$fileName');
          if (urlResponse == null) {
            item.imageUrl = null;
          } else {
            item.imageUrl = urlResponse; // save URL
          }
        } catch (e) {
          print('Upload error: $e');
          item.imageUrl = null;
        }
      }
    }

    SalesOrderListItemModel newOrderItem = SalesOrderListItemModel(
      customer: state.customerName,
      customerPhone: state.customerPhone,
      address: state.address,
      amount: state.totalPrice,
      status: state.isDelivered,
      dateAndTime: DateTime.now().toString(),
      newOrderDetails: state.itemDetails,
    );
    try {
      apiBloc.add(AddItem(item: newOrderItem));
    } catch (e) {
      print("Failed to Add order: " + e.toString());
    }
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
            localItemImage: state.localImagePath,
            webLocalItemImage: state.webLocalItemImage,
            quantity: state.quantity,
            unit: state.selectedUnit,
            price: state.price,
            totalItemsPrice: (state.quantity * state.price),
          ),
        );
    emit(
      state.copyWith(
        itemDetails: updatedList,
        localImagePath: '',
        clearWebImage: true,
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

  FutureOr<void> pickItemImage(
    PickItemImage event,
    Emitter<NewOrderState> emit,
  ) {
    emit(
      state.copyWith(
        webLocalItemImage: event.webImage,
        localImagePath: event.imagePath,
      ),
    );
  }

  FutureOr<void> isUpdatingItem(
    IsUpdatingItem event,
    Emitter<NewOrderState> emit,
  ) {
    emit(state.copyWith(isUpdatingItemDetails: event.isUpdating));
  }

  FutureOr<void> updateItemFromList(
    UpdateItemFromList event,
    Emitter<NewOrderState> emit,
  ) {
    List<NewOrderDetailsItemModel> updatedList = List.from(state.itemDetails);
    final oldItem = updatedList[event.itemIndex];

    final updatedItem = oldItem.copyWith(
      itemName: state.itemName.isNotEmpty ? state.itemName : null,
      localItemImage:
          (state.localImagePath != null && state.localImagePath!.isNotEmpty)
          ? state.localImagePath
          : null,
      webLocalItemImage:
          (state.webLocalItemImage != null &&
              state.webLocalItemImage!.isNotEmpty)
          ? state.webLocalItemImage
          : null,
      quantity: state.quantity != 0 ? state.quantity : null,
      unit: state.selectedUnit.isNotEmpty ? state.selectedUnit : null,
      price: state.price != 0 ? state.price : null,
      totalItemsPrice:
          ((state.quantity != 0 ? state.quantity : (oldItem.quantity ?? 0)) *
          (state.price != 0 ? state.price : (oldItem.price ?? 0))),
    );

    updatedList[event.itemIndex] = updatedItem;

    emit(
      state.copyWith(
        itemDetails: updatedList,
        localImagePath: "",
        webLocalItemImage: null,
        price: 0,
        quantity: 0,
        selectedUnit: 'kg',
        itemName: "",
        totalPrice: 0,
      ),
    );
  }
}
