import 'package:com.example.order_management_application/bloc/cloud_firebase_data/firebase_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/dark_theme_mode/dark_theme_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/new_order/new_order_bloc_events_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../AppColors/app_colors.dart';
import '../custom_widgets/import_all_custom_widgets.dart';
import '../utils/enums.dart';

class DetailedOrderPage extends StatefulWidget {
  const DetailedOrderPage();
  @override
  State<DetailedOrderPage> createState() => DetailedOrderPageState();
}

class DetailedOrderPageState extends State<DetailedOrderPage> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const double maxScreenWidth = 500;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColor.transparentColor,
        leading: kIsWeb
            ? SizedBox.shrink()
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColor.lightThemeColor,
                ),
              ),
        title: CustomText(
          text: "Order Details",
          textSize: 30,
          textBoldness: FontWeight.bold,
          textColor: AppColor.appbarTitleTextColor,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DarkThemeBloc, DarkThemeState>(
        builder: (context, darkThemeState) {
          return BlocBuilder<FirebaseDbBloc, FirebaseDbState>(
            buildWhen: (prev, curr) => prev.dataList != curr.dataList,
            builder: (context, apiState) {
              final selectedOrder =
                  apiState.dataList[apiState.selectedOrderIndex];
              if (apiState.apiStatus == Status.success)
                return SingleChildScrollView(
                  child: Center(
                    child: Card(
                      color: darkThemeState.darkTheme
                          ? AppColor.darkThemeColor
                          : AppColor.scaffoldLightBackgroundColor,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxScreenWidth),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomContainer(
                                borderRadius: 10,
                                backgroundColor: darkThemeState.darkTheme
                                    ? AppColor.darkThemeColor
                                    : AppColor.scaffoldLightBackgroundColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CustomText(
                                          text: "Name: ",
                                          textSize: 24,
                                          textBoldness: FontWeight.bold,
                                          textColor: darkThemeState.darkTheme
                                              ? AppColor.textDarkThemeColor
                                              : AppColor.textLightThemeColor,
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text:
                                                "${selectedOrder.customer.toString().substring(0, 1).toUpperCase() + selectedOrder.customer.toString().substring(1).toLowerCase()}",
                                            textSize: 24,
                                            textBoldness: FontWeight.bold,
                                            textColor: darkThemeState.darkTheme
                                                ? AppColor.textDarkThemeColor
                                                : AppColor.textLightThemeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: darkThemeState.darkTheme
                                          ? AppColor.dividerDarkColor
                                          : AppColor.dividerLightColor,
                                    ),
                                    CustomText(
                                      text:
                                          "Phone: ${selectedOrder.customerPhone}",
                                      textSize: 20,
                                      textBoldness: FontWeight.bold,
                                      textColor: darkThemeState.darkTheme
                                          ? AppColor.textDarkThemeColor
                                          : AppColor.textLightThemeColor,
                                    ),
                                    Divider(
                                      color: darkThemeState.darkTheme
                                          ? AppColor.dividerDarkColor
                                          : AppColor.dividerLightColor,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          text:
                                              "Date: ${selectedOrder.dateAndTime.toString().split(" ").first}",
                                          textSize: 20,
                                          textBoldness: FontWeight.bold,
                                          textColor: darkThemeState.darkTheme
                                              ? AppColor.textDarkThemeColor
                                              : AppColor.textLightThemeColor,
                                        ),
                                        SizedBox(width: 50),
                                        CustomText(
                                          text:
                                              "Time: ${selectedOrder.dateAndTime.toString().split(" ").last.split(".").first}",
                                          textSize: 20,
                                          textBoldness: FontWeight.bold,
                                          textColor: darkThemeState.darkTheme
                                              ? AppColor.textDarkThemeColor
                                              : AppColor.textLightThemeColor,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: darkThemeState.darkTheme
                                          ? AppColor.dividerDarkColor
                                          : AppColor.dividerLightColor,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: "Address: ",
                                          textSize: 20,
                                          textBoldness: FontWeight.bold,
                                          textColor: darkThemeState.darkTheme
                                              ? AppColor.textDarkThemeColor
                                              : AppColor.textLightThemeColor,
                                        ),
                                        Expanded(
                                          child: CustomContainer(
                                            borderRadius: 10,
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              right: 2,
                                              top: 2,
                                            ),
                                            backgroundColor:
                                                darkThemeState.darkTheme
                                                ? AppColor
                                                      .containerDarkThemeColor
                                                : AppColor
                                                      .containerLightThemeColor,
                                            child: SingleChildScrollView(
                                              child: CustomText(
                                                text:
                                                    selectedOrder.address!
                                                        .trim()
                                                        .isEmpty
                                                    ? "Address was not given"
                                                    : "${selectedOrder.address}",
                                                textSize: 20,
                                                textBoldness: FontWeight.bold,
                                                textColor:
                                                    darkThemeState.darkTheme
                                                    ? AppColor
                                                          .textDarkThemeColor
                                                    : AppColor
                                                          .textLightThemeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: darkThemeState.darkTheme
                                          ? AppColor.dividerDarkColor
                                          : AppColor.dividerLightColor,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: "Total: ",
                                          textSize: 20,
                                          textBoldness: FontWeight.bold,
                                          textColor: darkThemeState.darkTheme
                                              ? AppColor.textDarkThemeColor
                                              : AppColor.textLightThemeColor,
                                        ),
                                        CustomText(
                                          text: " ₹${selectedOrder.amount}/-",
                                          textSize: 20,
                                          textBoldness: FontWeight.bold,
                                          textColor: darkThemeState.darkTheme
                                              ? AppColor
                                                    .amountTextDarkThemeColor
                                              : AppColor
                                                    .amountTextLightThemeColor,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: darkThemeState.darkTheme
                                          ? AppColor.dividerDarkColor
                                          : AppColor.dividerLightColor,
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<NewOrderBloc, NewOrderState>(
                                builder: (context, orderState) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: " Order Status:  ",
                                        textSize: 29,
                                        textBoldness: FontWeight.bold,
                                        textColor: darkThemeState.darkTheme
                                            ? AppColor.textDarkThemeColor
                                            : AppColor.textLightThemeColor,
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            height: 30,
                                            width: 120,
                                            backgroundColor: getStatusColor(
                                              selectedOrder.status.toString(),
                                            ),
                                            borderRadius: 20,
                                            child: Center(
                                              child: CustomText(
                                                text: selectedOrder.status
                                                    .toString(),
                                                textSize: 18,
                                                textColor: AppColor.whiteColor,
                                                textBoldness: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (dialogCotext) {
                                                  return BlocBuilder<
                                                    FirebaseDbBloc,
                                                    FirebaseDbState
                                                  >(
                                                    buildWhen: (prev, curr) =>
                                                        prev.apiStatus !=
                                                        curr.apiStatus,
                                                    builder:
                                                        (
                                                          dialogCotext,
                                                          dialogApiState,
                                                        ) {
                                                          final currentOrder =
                                                              dialogApiState
                                                                  .dataList[apiState
                                                                  .selectedOrderIndex];
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                darkThemeState
                                                                    .darkTheme
                                                                ? AppColor
                                                                      .darkThemeColor
                                                                : AppColor
                                                                      .lightThemeColor,
                                                            title: Center(
                                                              child: CustomText(
                                                                text:
                                                                    dialogApiState
                                                                            .apiStatus ==
                                                                        Status
                                                                            .loading
                                                                    ? "Changing Order Status"
                                                                    : "Order Status",
                                                                textSize: 20,
                                                                textBoldness:
                                                                    FontWeight
                                                                        .bold,
                                                                textColor:
                                                                    darkThemeState
                                                                        .darkTheme
                                                                    ? AppColor
                                                                          .textDarkThemeColor
                                                                    : AppColor
                                                                          .textLightThemeColor,
                                                              ),
                                                            ),
                                                            content:
                                                                dialogApiState
                                                                        .apiStatus ==
                                                                    Status
                                                                        .loading
                                                                ? SizedBox(
                                                                    height: 50,
                                                                    child: Center(
                                                                      child: CircularProgressIndicator(
                                                                        color:
                                                                            darkThemeState.darkTheme
                                                                            ? AppColor.circularProgressDarkColor
                                                                            : AppColor.circularProgressLightColor,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SingleChildScrollView(
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              activeColor: AppColor.confirmColor,
                                                                              value: "Pending",
                                                                              groupValue: currentOrder.status,
                                                                              onChanged:
                                                                                  (
                                                                                    value,
                                                                                  ) {
                                                                                    dialogCotext
                                                                                        .read<
                                                                                          FirebaseDbBloc
                                                                                        >()
                                                                                        .add(
                                                                                          UpdateSelectedOrderStatus(
                                                                                            id: selectedOrder.id!,
                                                                                            updateStatus: value!,
                                                                                          ),
                                                                                        );
                                                                                  },
                                                                            ),
                                                                            CustomText(
                                                                              text: "Order Pending",
                                                                              textSize: 20,
                                                                              textColor: darkThemeState.darkTheme
                                                                                  ? AppColor.textDarkThemeColor
                                                                                  : AppColor.textLightThemeColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              30,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              activeColor: AppColor.confirmColor,
                                                                              value: "Delivered",
                                                                              groupValue: currentOrder.status,
                                                                              onChanged:
                                                                                  (
                                                                                    value,
                                                                                  ) {
                                                                                    dialogCotext
                                                                                        .read<
                                                                                          FirebaseDbBloc
                                                                                        >()
                                                                                        .add(
                                                                                          UpdateSelectedOrderStatus(
                                                                                            id: selectedOrder.id!,
                                                                                            updateStatus: value!,
                                                                                          ),
                                                                                        );
                                                                                  },
                                                                            ),
                                                                            CustomText(
                                                                              text: "Order Delivered",
                                                                              textSize: 20,
                                                                              textColor: darkThemeState.darkTheme
                                                                                  ? AppColor.textDarkThemeColor
                                                                                  : AppColor.textLightThemeColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              30,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              activeColor: AppColor.confirmColor,
                                                                              value: "Cancelled",
                                                                              groupValue: currentOrder.status,
                                                                              onChanged:
                                                                                  (
                                                                                    value,
                                                                                  ) {
                                                                                    dialogCotext
                                                                                        .read<
                                                                                          FirebaseDbBloc
                                                                                        >()
                                                                                        .add(
                                                                                          UpdateSelectedOrderStatus(
                                                                                            id: selectedOrder.id!,
                                                                                            updateStatus: value!,
                                                                                          ),
                                                                                        );
                                                                                  },
                                                                            ),
                                                                            CustomText(
                                                                              text: "Order Cancelled",
                                                                              textSize: 20,
                                                                              textColor: darkThemeState.darkTheme
                                                                                  ? AppColor.textDarkThemeColor
                                                                                  : AppColor.textLightThemeColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            actions:
                                                                apiState.apiStatus ==
                                                                    Status
                                                                        .loading
                                                                ? []
                                                                : [
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            darkThemeState.darkTheme
                                                                            ? AppColor.alertBtnDarkColor
                                                                            : AppColor.alertBtnLightColor,
                                                                      ),
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: CustomText(
                                                                        text:
                                                                            "OK",
                                                                        textColor:
                                                                            darkThemeState.darkTheme
                                                                            ? AppColor.textDarkThemeColor
                                                                            : AppColor.textLightThemeColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                          );
                                                        },
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              size: 29,
                                              color: darkThemeState.darkTheme
                                                  ? AppColor
                                                        .editIconDarkThemeColor
                                                  : AppColor
                                                        .editIconLightThemeColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Column(
                                spacing: 10,
                                children: [
                                  CustomContainer(
                                    width: kIsWeb
                                        ? screenWidth / 1
                                        : screenWidth,
                                    backgroundColor: darkThemeState.darkTheme
                                        ? AppColor.darkBlueGreyColor
                                        : AppColor.blueGreyColor,
                                    borderRadius: 10,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.0,
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex:
                                                orientation ==
                                                    Orientation.landscape
                                                ? 5
                                                : 4,
                                            child: CustomText(
                                              text: " Items",
                                              textColor: AppColor.whiteColor,
                                            ),
                                          ),
                                          Expanded(
                                            flex:
                                                orientation ==
                                                    Orientation.landscape
                                                ? 3
                                                : 2,
                                            child: CustomText(
                                              alignment: TextAlign.start,
                                              text: "Price",
                                              textColor: AppColor.whiteColor,
                                            ),
                                          ),
                                          Expanded(
                                            flex:
                                                orientation ==
                                                    Orientation.landscape
                                                ? 2
                                                : 1,
                                            child: CustomText(
                                              alignment: TextAlign.start,
                                              text: "Qty",
                                              textColor: AppColor.whiteColor,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              alignment: TextAlign.center,
                                              text: "Total",
                                              textColor: AppColor.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    height:
                                        MediaQuery.of(context).size.height /
                                        2.5,
                                    width: MediaQuery.of(context).size.width,
                                    backgroundColor: darkThemeState.darkTheme
                                        ? AppColor.containerDarkThemeColor
                                        : AppColor.containerLightThemeColor,
                                    borderRadius: 10,
                                    child: ListView.builder(
                                      itemCount:
                                          selectedOrder.newOrderDetails!.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          margin: EdgeInsets.all(5.0),
                                          color: darkThemeState.darkTheme
                                              ? AppColor.darkThemeColor
                                              : AppColor.lightThemeColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        backgroundColor:
                                                            darkThemeState
                                                                .darkTheme
                                                            ? AppColor
                                                                  .darkThemeColor
                                                            : AppColor
                                                                  .lightThemeColor,
                                                        contentPadding:
                                                            EdgeInsets.all(20),
                                                        content: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          child:
                                                              selectedOrder
                                                                      .newOrderDetails![index]
                                                                      .imageUrl ==
                                                                  null
                                                              ? const Icon(
                                                                  Icons
                                                                      .image_not_supported_rounded,
                                                                  size: 100,
                                                                )
                                                              : Image.network(
                                                                  height: 350,
                                                                  width: 350,
                                                                  selectedOrder
                                                                      .newOrderDetails![index]
                                                                      .imageUrl!,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child:
                                                      selectedOrder
                                                              .newOrderDetails![index]
                                                              .imageUrl ==
                                                          null
                                                      ? const Icon(
                                                          Icons
                                                              .image_not_supported_rounded,
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          child: Image.network(
                                                            height: 30,
                                                            width: 30,
                                                            selectedOrder
                                                                .newOrderDetails![index]
                                                                .imageUrl!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: CustomText(
                                                      text:
                                                          " ${index + 1}) ${selectedOrder.newOrderDetails![index].itemName}",
                                                      maxLinesAllowed: 1,
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                  child: CustomText(
                                                    alignment: TextAlign.end,
                                                    text:
                                                        "${selectedOrder.newOrderDetails![index].price}/-",
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                    textColor:
                                                        darkThemeState.darkTheme
                                                        ? AppColor
                                                              .textDarkThemeColor
                                                        : AppColor
                                                              .textLightThemeColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CustomText(
                                                    alignment: TextAlign.end,
                                                    text:
                                                        "${selectedOrder.newOrderDetails![index].quantity}${apiState.dataList[apiState.selectedOrderIndex].newOrderDetails![index].unit}",
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                    textColor:
                                                        darkThemeState.darkTheme
                                                        ? AppColor
                                                              .textDarkThemeColor
                                                        : AppColor
                                                              .textLightThemeColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CustomText(
                                                    alignment: TextAlign.end,
                                                    text:
                                                        "₹${selectedOrder.newOrderDetails![index].totalItemsPrice}/-",
                                                    maxLinesAllowed: 1,
                                                    textColor:
                                                        darkThemeState.darkTheme
                                                        ? AppColor
                                                              .amountTextDarkThemeColor
                                                        : AppColor
                                                              .amountTextLightThemeColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    backgroundColor: darkThemeState.darkTheme
                                        ? AppColor.buttonDarkThemeColor
                                        : AppColor.buttonLightThemeColor,
                                    height: 50,
                                    width: 120,
                                    buttonText: "Go Back",
                                    callback: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              else
                return Center(
                  child: CircularProgressIndicator(
                    color: darkThemeState.darkTheme
                        ? AppColor.circularProgressDarkColor
                        : AppColor.circularProgressLightColor,
                  ),
                );
            },
          );
        },
      ),
    );
  }
}
