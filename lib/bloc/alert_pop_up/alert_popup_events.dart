import 'package:equatable/equatable.dart';

abstract class AlertPopUpEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitHighOrderAlert extends AlertPopUpEvents {
  final String name;
  final int amount;
  InitHighOrderAlert({required this.name, required this.amount});

  @override
  List<Object?> get props => [name, amount];
}

class GetHighOrderAlert extends AlertPopUpEvents {}

class ClearHighOrderAlert extends AlertPopUpEvents {}

class GetPendingAndLimitCrossedOrders extends AlertPopUpEvents {}

class PendingPopupShown extends AlertPopUpEvents {
  final bool? isShown;
  PendingPopupShown({this.isShown});
  @override
  List<Object?> get props => [isShown];
}

class LimitCrossedPopupShown extends AlertPopUpEvents {
  final bool? show;
  LimitCrossedPopupShown({required this.show});
  @override
  List<Object?> get props => [show];
}
