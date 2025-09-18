import 'dart:ui';

import 'package:flutter/material.dart';

import '../AppColors/app_colors.dart';

enum Status { loading, success, failure }

enum Sorting { newestFirst, oldestFirst }

enum Filters { all, today, pending, delivered, cancelled }

Color getStatusColor(String status) {
  if (status == "Delivered") {
    return AppColor.deliveredOrderColor;
  } else if (status == "Pending") {
    return AppColor.pendingOrderColor;
  } else if (status == "Cancelled") {
    return AppColor.cancelledOrderColor;
  } else {
    return AppColor.cancelColor;
  }
}
