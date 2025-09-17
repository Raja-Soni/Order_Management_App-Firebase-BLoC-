import 'dart:io';

import 'package:com.example.order_management_application/bloc/alert_pop_up/alert_popup_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/dark_theme_mode/dark_theme_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/new_order/new_order_bloc_events_state.dart';
import 'package:com.example.order_management_application/custom_widgets/import_all_custom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../AppColors/app_colors.dart';

class NewSalesOrderPage extends StatefulWidget {
  const NewSalesOrderPage({super.key});

  @override
  State<NewSalesOrderPage> createState() => NewSalesOrderPageState();
}

class NewSalesOrderPageState extends State<NewSalesOrderPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    context.read<NewOrderBloc>().add(InitialState());
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const double maxScreenWidth = 500;
    final message = ScaffoldMessenger.of(context);
    return SafeArea(
      child: Scaffold(
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
            text: "Add New Order",
            textSize: 30,
            textBoldness: FontWeight.bold,
            textColor: AppColor.appbarTitleTextColor,
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<DarkThemeBloc, DarkThemeState>(
          builder: (context, darkModeState) {
            return BlocBuilder<NewOrderBloc, NewOrderState>(
              builder: (context, newOrderState) {
                final navigator = Navigator.of(context);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Card(
                          color: darkModeState.darkTheme
                              ? AppColor.darkThemeColor
                              : AppColor.lightThemeColor,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: maxScreenWidth,
                            ),
                            child: CustomContainer(
                              padding: EdgeInsets.all(10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    CustomFormTextField(
                                      inputType: TextInputType.name,
                                      hintText: "Enter Customer/Company Name",
                                      icon: Icon(Icons.person_outlined),
                                      validate: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Name";
                                        }
                                        return null;
                                      },
                                      changedValue: (value) {
                                        context.read<NewOrderBloc>().add(
                                          CustomerDetailGivenEvent(
                                            name: value!,
                                          ),
                                        );
                                        return null;
                                      },
                                    ),
                                    CustomFormTextField(
                                      inputType: TextInputType.phone,
                                      hintText: "Enter Contact Number",
                                      icon: Icon(Icons.phone),
                                      validate: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Contact Number";
                                        } else if (value.length != 10) {
                                          return "Contact number must be 10 digits";
                                        } else if (!RegExp(
                                          r'^[0-9]+$',
                                        ).hasMatch(value)) {
                                          return "Only digits allowed";
                                        }
                                        return null;
                                      },
                                      changedValue: (value) {
                                        context.read<NewOrderBloc>().add(
                                          CustomerDetailGivenEvent(
                                            phone: value!,
                                          ),
                                        );
                                        return null;
                                      },
                                    ),
                                    CustomFormTextField(
                                      inputType: TextInputType.name,
                                      hintText: "Enter Address",
                                      icon: Icon(Icons.person_outlined),
                                      changedValue: (value) {
                                        context.read<NewOrderBloc>().add(
                                          CustomerDetailGivenEvent(
                                            address: value!,
                                          ),
                                        );
                                        return null;
                                      },
                                    ),
                                    if (newOrderState.itemDetails.isEmpty)
                                      SizedBox.shrink()
                                    else
                                      Column(
                                        children: [
                                          CustomContainer(
                                            backgroundColor:
                                                darkModeState.darkTheme
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
                                                            Orientation
                                                                .landscape
                                                        ? 6
                                                        : 5,
                                                    child: CustomText(
                                                      text: "   Items",
                                                      textColor:
                                                          AppColor.whiteColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex:
                                                        orientation ==
                                                            Orientation
                                                                .landscape
                                                        ? 3
                                                        : 3,
                                                    child: CustomText(
                                                      alignment:
                                                          TextAlign.start,
                                                      text: "   Price",
                                                      textColor:
                                                          AppColor.whiteColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex:
                                                        orientation ==
                                                            Orientation
                                                                .landscape
                                                        ? 2
                                                        : 2,
                                                    child: CustomText(
                                                      alignment:
                                                          TextAlign.start,
                                                      text: "  Qty",
                                                      textColor:
                                                          AppColor.whiteColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex:
                                                        orientation ==
                                                            Orientation
                                                                .landscape
                                                        ? 8
                                                        : 7,
                                                    child: CustomText(
                                                      alignment:
                                                          TextAlign.center,
                                                      text: "Total Price",
                                                      textColor:
                                                          AppColor.whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          CustomContainer(
                                            height: 200,
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            borderRadius: 10,
                                            backgroundColor:
                                                darkModeState.darkTheme
                                                ? AppColor
                                                      .containerDarkThemeColor
                                                : AppColor
                                                      .containerLightThemeColor,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: ListView.builder(
                                                itemCount: newOrderState
                                                    .itemDetails
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    color:
                                                        darkModeState.darkTheme
                                                        ? AppColor
                                                              .darkThemeColor
                                                        : AppColor
                                                              .lightThemeColor,
                                                    child: ListTile(
                                                      title: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) => AlertDialog(
                                                                  backgroundColor:
                                                                      darkModeState
                                                                          .darkTheme
                                                                      ? AppColor
                                                                            .darkThemeColor
                                                                      : AppColor
                                                                            .lightThemeColor,
                                                                  contentPadding:
                                                                      EdgeInsets.all(
                                                                        20,
                                                                      ),
                                                                  content: ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    child:
                                                                        kIsWeb
                                                                        ? (newOrderState.itemDetails[index].webLocalItemImage ==
                                                                                  null
                                                                              ? const Icon(
                                                                                  Icons.image_not_supported_rounded,
                                                                                  size: 80,
                                                                                )
                                                                              : Image.memory(
                                                                                  newOrderState.itemDetails[index].webLocalItemImage!,
                                                                                  height: 350,
                                                                                  width: 350,
                                                                                  fit: BoxFit.contain,
                                                                                ))
                                                                        : newOrderState.itemDetails[index].localItemImage ==
                                                                                  null ||
                                                                              newOrderState.itemDetails[index].localItemImage!.isEmpty
                                                                        ? const Icon(
                                                                            Icons.image_not_supported_rounded,
                                                                            size:
                                                                                80,
                                                                          )
                                                                        : Image.file(
                                                                            scale:
                                                                                60,
                                                                            File(
                                                                              newOrderState.itemDetails[index].localItemImage!,
                                                                            ),
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: kIsWeb
                                                                ? (newOrderState
                                                                              .itemDetails[index]
                                                                              .webLocalItemImage ==
                                                                          null
                                                                      ? const Icon(
                                                                          Icons
                                                                              .image_not_supported_rounded,
                                                                        )
                                                                      : ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                5,
                                                                              ),
                                                                          child: Image.memory(
                                                                            newOrderState.itemDetails[index].webLocalItemImage!,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                          ),
                                                                        ))
                                                                : newOrderState
                                                                              .itemDetails[index]
                                                                              .localItemImage ==
                                                                          null ||
                                                                      newOrderState
                                                                          .itemDetails[index]
                                                                          .localItemImage!
                                                                          .isEmpty
                                                                ? const Icon(
                                                                    Icons
                                                                        .image_not_supported_rounded,
                                                                  )
                                                                : ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          5,
                                                                        ),
                                                                    child: Image.file(
                                                                      scale:
                                                                          80.0,
                                                                      File(
                                                                        newOrderState
                                                                            .itemDetails[index]
                                                                            .localItemImage!,
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                          ),
                                                          Expanded(
                                                            child: SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: CustomText(
                                                                text:
                                                                    " ${index + 1}) ${newOrderState.itemDetails[index].itemName}",
                                                                maxLinesAllowed:
                                                                    1,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: CustomText(
                                                              maxLinesAllowed:
                                                                  1,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              alignment:
                                                                  TextAlign
                                                                      .right,
                                                              text:
                                                                  "₹${newOrderState.itemDetails[index].price}",
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: CustomText(
                                                              alignment:
                                                                  TextAlign
                                                                      .center,
                                                              text:
                                                                  "${newOrderState.itemDetails[index].quantity}${newOrderState.itemDetails[index].unit}",
                                                              maxLinesAllowed:
                                                                  1,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: CustomText(
                                                              alignment:
                                                                  TextAlign.end,
                                                              text:
                                                                  "₹${newOrderState.itemDetails[index].totalItemsPrice}",
                                                              maxLinesAllowed:
                                                                  1,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textColor:
                                                                  darkModeState
                                                                      .darkTheme
                                                                  ? AppColor
                                                                        .amountTextDarkThemeColor
                                                                  : AppColor
                                                                        .amountTextLightThemeColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: InkWell(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        hoverColor: AppColor
                                                            .cancelLightShadeColor,
                                                        splashColor: AppColor
                                                            .confirmColor,
                                                        child: Icon(
                                                          Icons.cancel_outlined,
                                                          color: AppColor
                                                              .cancelColor,
                                                        ),
                                                        onTap: () {
                                                          context
                                                              .read<
                                                                NewOrderBloc
                                                              >()
                                                              .add(
                                                                RemoveItemFromList(
                                                                  itemIndex:
                                                                      index,
                                                                ),
                                                              );
                                                          context
                                                              .read<
                                                                NewOrderBloc
                                                              >()
                                                              .add(
                                                                TotalPriceChangedEvent(),
                                                              );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                        GlobalKey<FormState> itemFormKey =
                                            GlobalKey();
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return LayoutBuilder(
                                              builder: (context, constraints) {
                                                final width =
                                                    constraints.maxWidth;
                                                final isSmallScreen =
                                                    width < 600;
                                                return AlertDialog(
                                                  insetPadding: kIsWeb
                                                      ? EdgeInsets.symmetric(
                                                          horizontal:
                                                              isSmallScreen
                                                              ? screenWidth / 20
                                                              : 0,
                                                        )
                                                      : (orientation ==
                                                                Orientation
                                                                    .portrait
                                                            ? EdgeInsets.symmetric(
                                                                horizontal:
                                                                    screenWidth /
                                                                    22,
                                                              )
                                                            : EdgeInsets.symmetric(
                                                                horizontal:
                                                                    screenWidth /
                                                                    5,
                                                              )),
                                                  backgroundColor:
                                                      darkModeState.darkTheme
                                                      ? AppColor
                                                            .dialogBackgroundDarkThemeColor
                                                      : AppColor
                                                            .dialogBackgroundLightThemeColor,
                                                  title: Center(
                                                    child: CustomText(
                                                      text:
                                                          "Enter Item Details",
                                                      textSize: 30,
                                                      textBoldness:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: isSmallScreen
                                                          ? screenWidth
                                                          : 400,
                                                      maxHeight:
                                                          constraints
                                                              .maxHeight *
                                                          0.85,
                                                    ),
                                                    child: SingleChildScrollView(
                                                      child: Form(
                                                        key: itemFormKey,
                                                        child: Column(
                                                          spacing: 10,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            CustomFormTextField(
                                                              inputType:
                                                                  TextInputType
                                                                      .name,
                                                              hintText:
                                                                  "Enter Item Name",
                                                              icon: Icon(
                                                                Icons
                                                                    .person_outlined,
                                                              ),
                                                              validate: (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please Enter Item Name";
                                                                }
                                                                return null;
                                                              },
                                                              savedValue: (value) {
                                                                context
                                                                    .read<
                                                                      NewOrderBloc
                                                                    >()
                                                                    .add(
                                                                      NewItemDetails(
                                                                        itemName:
                                                                            value!,
                                                                      ),
                                                                    );
                                                                return null;
                                                              },
                                                            ),
                                                            CustomFormTextField(
                                                              inputType:
                                                                  TextInputType
                                                                      .number,
                                                              hintText:
                                                                  "Enter Quantity",
                                                              icon: Icon(
                                                                Icons
                                                                    .numbers_rounded,
                                                              ),
                                                              validate: (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please Enter Quantity";
                                                                }
                                                                if (!RegExp(
                                                                  r'^[0-9]+$',
                                                                ).hasMatch(
                                                                  value,
                                                                )) {
                                                                  return "Only numbers allowed";
                                                                }
                                                                int quantity =
                                                                    int.parse(
                                                                      value
                                                                          .toString(),
                                                                    );
                                                                if (quantity <
                                                                    0) {
                                                                  return "Quantity must be more than 0";
                                                                }

                                                                return null;
                                                              },
                                                              savedValue: (value) {
                                                                int quantity =
                                                                    int.parse(
                                                                      value
                                                                          .toString(),
                                                                    );
                                                                context
                                                                    .read<
                                                                      NewOrderBloc
                                                                    >()
                                                                    .add(
                                                                      NewItemDetails(
                                                                        quantity:
                                                                            quantity,
                                                                      ),
                                                                    );
                                                                return null;
                                                              },
                                                            ),
                                                            BlocBuilder<
                                                              NewOrderBloc,
                                                              NewOrderState
                                                            >(
                                                              builder:
                                                                  (
                                                                    context,
                                                                    dialogNewItemState,
                                                                  ) {
                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        kIsWeb
                                                                            ? (dialogNewItemState.webLocalItemImage ==
                                                                                      null
                                                                                  ? const SizedBox.shrink()
                                                                                  : Image.memory(
                                                                                      dialogNewItemState.webLocalItemImage!,
                                                                                      scale: 20,
                                                                                      fit: BoxFit.cover,
                                                                                    ))
                                                                            : dialogNewItemState.localImagePath ==
                                                                                      null ||
                                                                                  dialogNewItemState.localImagePath!.isEmpty
                                                                            ? const SizedBox.shrink()
                                                                            : ClipRRect(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  10,
                                                                                ),
                                                                                child: Image.file(
                                                                                  scale: 30,
                                                                                  fit: BoxFit.scaleDown,
                                                                                  File(
                                                                                    dialogNewItemState.localImagePath!,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                        TextButton(
                                                                          onPressed: () async {
                                                                            XFile?
                                                                            pickedImage;
                                                                            if (kIsWeb) {
                                                                              final imagePicker = ImagePicker();
                                                                              pickedImage = await imagePicker.pickImage(
                                                                                source: ImageSource.gallery,
                                                                              );
                                                                              if (pickedImage !=
                                                                                  null) {
                                                                                final bytes = await pickedImage.readAsBytes();
                                                                                if (bytes.isNotEmpty) {
                                                                                  final bloc =
                                                                                      BlocProvider.of<
                                                                                        NewOrderBloc
                                                                                      >(
                                                                                        dialogContext,
                                                                                      );
                                                                                  bloc.add(
                                                                                    PickItemImage(
                                                                                      webImage: bytes,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              }
                                                                            } else {
                                                                              showModalBottomSheet(
                                                                                context: context,
                                                                                builder:
                                                                                    (
                                                                                      context,
                                                                                    ) => BottomSheet(
                                                                                      onClosing: () {},
                                                                                      builder:
                                                                                          (
                                                                                            context,
                                                                                          ) {
                                                                                            return Column(
                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(
                                                                                                    top: 8.0,
                                                                                                  ),
                                                                                                  child: CustomText(
                                                                                                    textSize: 25,
                                                                                                    text: "Select Media to Upload",
                                                                                                  ),
                                                                                                ),
                                                                                                Row(
                                                                                                  spacing: 20,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: EdgeInsets.only(
                                                                                                        left: 10.0,
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          IconButton(
                                                                                                            padding: EdgeInsets.all(
                                                                                                              10,
                                                                                                            ),
                                                                                                            onPressed: () async {
                                                                                                              Navigator.pop(
                                                                                                                context,
                                                                                                              );
                                                                                                              final imagePicker = ImagePicker();
                                                                                                              pickedImage = await imagePicker.pickImage(
                                                                                                                source: ImageSource.camera,
                                                                                                              );
                                                                                                              if (pickedImage !=
                                                                                                                  null) {
                                                                                                                final bloc =
                                                                                                                    BlocProvider.of<
                                                                                                                      NewOrderBloc
                                                                                                                    >(
                                                                                                                      dialogContext,
                                                                                                                    );
                                                                                                                bloc.add(
                                                                                                                  PickItemImage(
                                                                                                                    imagePath: pickedImage!.path,
                                                                                                                  ),
                                                                                                                );
                                                                                                              }
                                                                                                            },
                                                                                                            icon: Icon(
                                                                                                              Icons.camera_alt_rounded,
                                                                                                              size: 50,
                                                                                                            ),
                                                                                                          ),
                                                                                                          CustomText(
                                                                                                            text: "Camera",
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Column(
                                                                                                      children: [
                                                                                                        IconButton(
                                                                                                          padding: EdgeInsets.all(
                                                                                                            10,
                                                                                                          ),
                                                                                                          onPressed: () async {
                                                                                                            Navigator.pop(
                                                                                                              context,
                                                                                                            );
                                                                                                            final imagePicker = ImagePicker();
                                                                                                            pickedImage = await imagePicker.pickImage(
                                                                                                              source: ImageSource.gallery,
                                                                                                            );
                                                                                                            if (pickedImage !=
                                                                                                                null) {
                                                                                                              final bloc =
                                                                                                                  BlocProvider.of<
                                                                                                                    NewOrderBloc
                                                                                                                  >(
                                                                                                                    dialogContext,
                                                                                                                  );
                                                                                                              bloc.add(
                                                                                                                PickItemImage(
                                                                                                                  imagePath: pickedImage!.path,
                                                                                                                ),
                                                                                                              );
                                                                                                            }
                                                                                                          },
                                                                                                          icon: Icon(
                                                                                                            Icons.image,
                                                                                                            size: 50,
                                                                                                          ),
                                                                                                        ),
                                                                                                        CustomText(
                                                                                                          text: "Gallery",
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 30,
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                    ),
                                                                              );
                                                                            }
                                                                          },
                                                                          child: CustomText(
                                                                            text:
                                                                                kIsWeb
                                                                                ? (dialogNewItemState.webLocalItemImage ==
                                                                                          null
                                                                                      ? "Upload Image"
                                                                                      : "Upload New Image")
                                                                                : dialogNewItemState.localImagePath!.isEmpty
                                                                                ? "Take/Upload Image"
                                                                                : "ReTake/ReUpload Image",
                                                                            textColor:
                                                                                AppColor.linkTextColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                CustomText(
                                                                  text:
                                                                      "Select Unit: ",
                                                                ),
                                                                BlocBuilder<
                                                                  NewOrderBloc,
                                                                  NewOrderState
                                                                >(
                                                                  builder:
                                                                      (
                                                                        dialogContext,
                                                                        dialogOrderState,
                                                                      ) {
                                                                        return DropdownButton(
                                                                          style: TextStyle(
                                                                            color:
                                                                                darkModeState.darkTheme
                                                                                ? AppColor.textDarkThemeColor
                                                                                : AppColor.textLightThemeColor,
                                                                          ),
                                                                          dropdownColor:
                                                                              darkModeState.darkTheme
                                                                              ? AppColor.darkThemeColor
                                                                              : AppColor.lightThemeColor,
                                                                          icon: Icon(
                                                                            Icons.arrow_drop_down,
                                                                            color:
                                                                                darkModeState.darkTheme
                                                                                ? AppColor.iconDarkThemeColor
                                                                                : AppColor.iconLightThemeColor,
                                                                          ),
                                                                          iconSize:
                                                                              25,
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                          value:
                                                                              dialogOrderState.selectedUnit,
                                                                          items: dialogOrderState
                                                                              .units
                                                                              .map(
                                                                                (
                                                                                  unit,
                                                                                ) => DropdownMenuItem(
                                                                                  child: CustomText(
                                                                                    text: unit,
                                                                                  ),
                                                                                  value: unit,
                                                                                ),
                                                                              )
                                                                              .toList(),
                                                                          onChanged:
                                                                              (
                                                                                String?
                                                                                changedValue,
                                                                              ) {
                                                                                context
                                                                                    .read<
                                                                                      NewOrderBloc
                                                                                    >()
                                                                                    .add(
                                                                                      ItemUnitChanged(
                                                                                        itemUnit: changedValue!,
                                                                                      ),
                                                                                    );
                                                                              },
                                                                        );
                                                                      },
                                                                ),
                                                              ],
                                                            ),
                                                            CustomFormTextField(
                                                              inputType:
                                                                  TextInputType
                                                                      .number,
                                                              hintText:
                                                                  "Enter Price",
                                                              icon: Icon(
                                                                Icons
                                                                    .currency_rupee_rounded,
                                                              ),
                                                              validate: (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please Enter Price";
                                                                }
                                                                if (!RegExp(
                                                                  r'^[0-9]+$',
                                                                ).hasMatch(
                                                                  value,
                                                                )) {
                                                                  return "Only numbers allowed";
                                                                }
                                                                int
                                                                price = int.parse(
                                                                  value
                                                                      .toString(),
                                                                );
                                                                if (price < 0) {
                                                                  return "Price must be more than 0";
                                                                }

                                                                return null;
                                                              },
                                                              savedValue: (value) {
                                                                int
                                                                price = int.parse(
                                                                  value
                                                                      .toString(),
                                                                );
                                                                context
                                                                    .read<
                                                                      NewOrderBloc
                                                                    >()
                                                                    .add(
                                                                      NewItemDetails(
                                                                        price:
                                                                            price,
                                                                      ),
                                                                    );
                                                                return null;
                                                              },
                                                            ),
                                                            CustomButton(
                                                              backgroundColor:
                                                                  darkModeState
                                                                      .darkTheme
                                                                  ? AppColor
                                                                        .buttonDarkThemeColor
                                                                  : AppColor
                                                                        .confirmColor,
                                                              width:
                                                                  MediaQuery.of(
                                                                    dialogContext,
                                                                  ).size.width,
                                                              buttonText:
                                                                  "Add Item",
                                                              callback: () {
                                                                bool
                                                                isValidState =
                                                                    itemFormKey
                                                                        .currentState!
                                                                        .validate();

                                                                if (isValidState) {
                                                                  itemFormKey
                                                                      .currentState!
                                                                      .save();
                                                                  context
                                                                      .read<
                                                                        NewOrderBloc
                                                                      >()
                                                                      .add(
                                                                        OrderItemDetailedList(),
                                                                      );
                                                                  context
                                                                      .read<
                                                                        NewOrderBloc
                                                                      >()
                                                                      .add(
                                                                        TotalPriceChangedEvent(),
                                                                      );
                                                                  context
                                                                      .read<
                                                                        NewOrderBloc
                                                                      >()
                                                                      .add(
                                                                        ResetImageOnDialog(),
                                                                      );
                                                                  Navigator.of(
                                                                    dialogContext,
                                                                  ).pop();
                                                                }
                                                              },
                                                            ),
                                                            CustomButton(
                                                              backgroundColor:
                                                                  darkModeState
                                                                      .darkTheme
                                                                  ? AppColor
                                                                        .buttonDarkThemeColor
                                                                  : AppColor
                                                                        .cancelColor,
                                                              width:
                                                                  MediaQuery.of(
                                                                    dialogContext,
                                                                  ).size.width,
                                                              buttonText:
                                                                  "Cancel",
                                                              callback: () {
                                                                context
                                                                    .read<
                                                                      NewOrderBloc
                                                                    >()
                                                                    .add(
                                                                      ResetImageOnDialog(),
                                                                    );
                                                                Navigator.of(
                                                                  dialogContext,
                                                                ).pop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: CustomContainer(
                                        backgroundColor: darkModeState.darkTheme
                                            ? AppColor.alertBtnDarkColor
                                            : AppColor.blueGreyColor,
                                        borderRadius: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                text: " Add New Item",
                                                textBoldness: FontWeight.bold,
                                                textSize: 25,
                                                textColor: AppColor.whiteColor,
                                              ),
                                              Icon(
                                                Icons.add,
                                                size: 35,
                                                color: AppColor.whiteColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              text: "Status:",
                                              textSize: 22,
                                              textBoldness: FontWeight.w500,
                                            ),
                                          ),
                                          Radio(
                                            activeColor: AppColor.confirmColor,
                                            value: "Pending",
                                            groupValue:
                                                newOrderState.isDelivered,
                                            onChanged: (value) {
                                              context.read<NewOrderBloc>().add(
                                                OrderDeliveryStatusChangedEvent(
                                                  isDelivered: "Pending",
                                                ),
                                              );
                                            },
                                          ),
                                          CustomText(
                                            text: "Pending",
                                            textSize: 20,
                                          ),
                                          SizedBox(width: 30),
                                          Radio(
                                            activeColor: AppColor.confirmColor,
                                            value: "Delivered",
                                            groupValue:
                                                newOrderState.isDelivered,
                                            onChanged: (value) {
                                              context.read<NewOrderBloc>().add(
                                                OrderDeliveryStatusChangedEvent(
                                                  isDelivered: "Delivered",
                                                ),
                                              );
                                            },
                                          ),
                                          CustomText(
                                            text: "Delivered",
                                            textSize: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: CustomText(
                                              text: "Total Order: ",
                                              textSize: 22,
                                              textBoldness: FontWeight.w500,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: CustomText(
                                                text:
                                                    "${newOrderState.totalPrice}/-",
                                                textSize: 22,
                                                textBoldness: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomButton(
                                      backgroundColor: darkModeState.darkTheme
                                          ? AppColor.buttonDarkThemeColor
                                          : AppColor.buttonLightThemeColor,
                                      width: MediaQuery.of(context).size.width,
                                      buttonText: "Add Order",
                                      callback: () {
                                        bool isValidState = formKey
                                            .currentState!
                                            .validate();
                                        if (newOrderState.itemDetails.isEmpty) {
                                          message.showSnackBar(
                                            SnackBar(
                                              width: kIsWeb ? 450 : screenWidth,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons.cancel,
                                                    color: AppColor.cancelColor,
                                                  ),
                                                  Flexible(
                                                    child: CustomText(
                                                      text:
                                                          " Add at least 1 item",
                                                      textBoldness:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        } else if (newOrderState.totalPrice <=
                                            0) {
                                          message.showSnackBar(
                                            SnackBar(
                                              width: kIsWeb ? 450 : screenWidth,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info,
                                                    color: AppColor.cancelColor,
                                                  ),
                                                  CustomText(
                                                    text:
                                                        " Total Order must be more than zero",
                                                    textBoldness:
                                                        FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                        if (isValidState &&
                                            newOrderState
                                                .itemDetails
                                                .isNotEmpty &&
                                            newOrderState.totalPrice > 0) {
                                          message
                                              .showSnackBar(
                                                SnackBar(
                                                  width: kIsWeb
                                                      ? 450
                                                      : screenWidth,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Row(
                                                    spacing: 10,
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: AppColor
                                                            .confirmColor,
                                                      ),
                                                      CustomText(
                                                        text: " Order Added",
                                                        textBoldness:
                                                            FontWeight.bold,
                                                      ),
                                                    ],
                                                  ),
                                                  duration: Duration(
                                                    milliseconds: 600,
                                                  ),
                                                ),
                                              )
                                              .closed
                                              .then((_) {
                                                if (!context.mounted) return;
                                                context
                                                    .read<NewOrderBloc>()
                                                    .add(AddNewOrderEvent());
                                                if (newOrderState.totalPrice >
                                                    10000) {
                                                  context
                                                      .read<AlertPopUpBloc>()
                                                      .add(
                                                        LimitCrossedPopupShown(
                                                          show: false,
                                                        ),
                                                      );
                                                  context
                                                      .read<AlertPopUpBloc>()
                                                      .add(
                                                        InitHighOrderAlert(
                                                          name: newOrderState
                                                              .customerName,
                                                          amount: newOrderState
                                                              .totalPrice,
                                                        ),
                                                      );
                                                }
                                                navigator.pop();
                                              });
                                        }
                                      },
                                    ),
                                    CustomButton(
                                      backgroundColor: darkModeState.darkTheme
                                          ? AppColor.buttonDarkThemeColor
                                          : AppColor.cancelColor,
                                      width: MediaQuery.of(context).size.width,
                                      buttonText: "Cancel",
                                      callback: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
