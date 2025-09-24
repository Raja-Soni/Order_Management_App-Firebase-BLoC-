import 'package:com.example.order_management_application/bloc/firebase_auth/firebase_auth_bloc_events_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../AppColors/app_colors.dart';
import '../bloc/cloud_firebase_data/firebase_bloc_events_state.dart';
import '../bloc/dark_theme_mode/dark_theme_bloc_events_state.dart';
import '../custom_widgets/import_all_custom_widgets.dart';
import '../routes/all_routes.dart';
import '../utils/enums.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<FormState> searchFormKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    context.read<FirebaseDbBloc>().add(InitialDashboardPageState());
  }

  final searchBarTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    const double maxScreenWidth = 500;
    return SafeArea(
      child: BlocBuilder<DarkThemeBloc, DarkThemeState>(
        builder: (context, darkModeState) {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: AppColor.transparentColor,
              leading: kIsWeb
                  ? null
                  : Icon(Icons.list, size: 40, color: Colors.white),
              title: Row(
                mainAxisAlignment: kIsWeb
                    ? (isSmallScreen
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center)
                    : MainAxisAlignment.start,
                spacing: 10,
                children: [
                  kIsWeb
                      ? Icon(Icons.list, size: 60, color: Colors.white)
                      : SizedBox.shrink(),
                  CustomText(
                    text: "Order Manager",
                    textSize: 33,
                    textBoldness: FontWeight.bold,
                    textColor: AppColor.appbarTitleTextColor,
                  ),
                ],
              ),
              actions: [
                PopupMenuButton(
                  iconSize: 30,
                  popUpAnimationStyle: AnimationStyle(
                    curve: Curves.fastOutSlowIn,
                  ),
                  iconColor: AppColor.whiteColor,
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: BlocBuilder<DarkThemeBloc, DarkThemeState>(
                        buildWhen: (previous, current) =>
                            previous.darkTheme != current.darkTheme,
                        builder: (context, darkModeState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "  Dark Mode",
                                textColor: darkModeState.darkTheme
                                    ? AppColor.textDarkThemeColor
                                    : AppColor.textLightThemeColor,
                              ),
                              Switch(
                                hoverColor: AppColor.confirmColor,
                                focusColor: AppColor.focusColor,
                                splashRadius: 18,
                                trackOutlineColor: WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
                                activeTrackColor:
                                    AppColor.switchActiveTrackColor,
                                inactiveTrackColor:
                                    AppColor.switchInactiveTrackColor,
                                activeThumbImage: AssetImage(
                                  "assets/images/dark_mode.jpg",
                                ),
                                inactiveThumbImage: AssetImage(
                                  "assets/images/light_mode.png",
                                ),
                                value: darkModeState.darkTheme,
                                onChanged: (value) {
                                  context.read<DarkThemeBloc>().add(
                                    DarkModeToggleAndPreference(
                                      darkModeToggle: value,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        context.read<FirebaseAuthBloc>().add(LogoutUser());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.userAuthenticationPage,
                          (route) => false,
                        );
                      },
                      child: CustomText(
                        text: "  Logout",
                        textColor: AppColor.cancelColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: BlocBuilder<DarkThemeBloc, DarkThemeState>(
              builder: (context, darkModeState) {
                return BlocBuilder<FirebaseDbBloc, FirebaseDbState>(
                  builder: (context, apiDbState) {
                    final dataList = apiDbState.dataList;
                    if (apiDbState.apiStatus == Status.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: darkModeState.darkTheme
                              ? AppColor.circularProgressDarkColor
                              : AppColor.circularProgressLightColor,
                        ),
                      );
                    } else if (apiDbState.apiStatus == Status.failure) {
                      return Center(
                        child: CustomText(
                          text: apiDbState.message.toString(),
                          textColor: darkModeState.darkTheme
                              ? AppColor.textDarkThemeColor
                              : AppColor.textLightThemeColor,
                        ),
                      );
                    } else {
                      return Center(
                        child: Card(
                          color: darkModeState.darkTheme
                              ? (kIsWeb
                                    ? AppColor.darkThemeColor
                                    : AppColor.scaffoldDarkBackgroundColor)
                              : (kIsWeb
                                    ? AppColor.lightThemeColor
                                    : AppColor.scaffoldLightBackgroundColor),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: maxScreenWidth,
                            ),
                            child: Column(
                              children: [
                                CustomContainer(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 15.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 7.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: "Order List",
                                          textSize: 30,
                                          textColor: darkModeState.darkTheme
                                              ? AppColor.textDarkThemeColor
                                              : AppColor.textLightThemeColor,
                                        ),
                                        Card(
                                          elevation: 6,
                                          color: darkModeState.darkTheme
                                              ? (kIsWeb
                                                    ? AppColor
                                                          .scaffoldDarkBackgroundColor
                                                    : AppColor.darkThemeColor)
                                              : AppColor.lightThemeColor,
                                          child: DropdownButton(
                                            focusColor: AppColor.focusColor,
                                            style: TextStyle(
                                              color: darkModeState.darkTheme
                                                  ? AppColor.textDarkThemeColor
                                                  : AppColor
                                                        .textLightThemeColor,
                                            ),
                                            dropdownColor:
                                                darkModeState.darkTheme
                                                ? AppColor.darkThemeColor
                                                : AppColor.lightThemeColor,
                                            icon: Icon(
                                              Icons.tune,
                                              color: darkModeState.darkTheme
                                                  ? AppColor.iconDarkThemeColor
                                                  : AppColor
                                                        .iconLightThemeColor,
                                            ),
                                            iconSize: 25,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            value: apiDbState.filter,
                                            underline: SizedBox.shrink(),
                                            items: [
                                              DropdownMenuItem(
                                                value: Filters.all,
                                                child: CustomText(
                                                  text: "All Orders",
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: Filters.today,
                                                child: CustomText(
                                                  text: "Today Orders",
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: Filters.pending,
                                                child: CustomText(
                                                  text: "Pending Orders",
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: Filters.delivered,
                                                child: CustomText(
                                                  text: "Delivered Orders",
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: Filters.cancelled,
                                                child: CustomText(
                                                  text: "Cancelled Orders",
                                                ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              if (value != null) {
                                                context
                                                    .read<FirebaseDbBloc>()
                                                    .add(
                                                      ApplyFilter(
                                                        filter: value,
                                                      ),
                                                    );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Form(
                                    key: searchFormKey,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: CustomFormTextField(
                                            textEditingController:
                                                searchBarTextController,
                                            inputType: TextInputType.text,
                                            changedValue: (value) {
                                              if (value != null) {
                                                context
                                                    .read<FirebaseDbBloc>()
                                                    .add(
                                                      OrderToFindNameChangedEvent(
                                                        orderToFindName: value,
                                                      ),
                                                    );
                                              }
                                              return null;
                                            },
                                            validate: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Search field is empty!!!";
                                              }
                                              return null;
                                            },
                                            hintText: "Search",
                                            icon: Icon(Icons.search),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: CustomButton(
                                            backgroundColor:
                                                darkModeState.darkTheme
                                                ? AppColor.buttonDarkThemeColor
                                                : AppColor
                                                      .buttonLightThemeColor,
                                            height: kIsWeb ? 48.0 : 54.0,
                                            buttonText: "Go",
                                            callback: () {
                                              final isValidated = searchFormKey
                                                  .currentState!
                                                  .validate();
                                              if (isValidated) {
                                                context
                                                    .read<FirebaseDbBloc>()
                                                    .add(SearchOrderEvent());
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText(
                                        text: "Sort by: ",
                                        textSize: 15,
                                        textColor: darkModeState.darkTheme
                                            ? AppColor.textDarkThemeColor
                                            : AppColor.textLightThemeColor,
                                      ),
                                      Card(
                                        color: darkModeState.darkTheme
                                            ? AppColor.buttonDarkThemeColor
                                            : AppColor.lightThemeColor,
                                        child: DropdownButton(
                                          isDense: true,
                                          underline: SizedBox.shrink(),
                                          padding: EdgeInsets.only(left: 8),
                                          focusColor: AppColor.focusColor,
                                          style: TextStyle(
                                            color: darkModeState.darkTheme
                                                ? AppColor.textDarkThemeColor
                                                : AppColor.textLightThemeColor,
                                          ),
                                          dropdownColor: darkModeState.darkTheme
                                              ? AppColor.darkThemeColor
                                              : AppColor.lightThemeColor,
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          value: apiDbState.sortList,
                                          items: [
                                            DropdownMenuItem(
                                              value: Sorting.newestFirst,
                                              child: CustomText(
                                                text: "Newest First",
                                                textSize: 15,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: Sorting.oldestFirst,
                                              child: CustomText(
                                                text: "Oldest First",
                                                textSize: 15,
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              context
                                                  .read<FirebaseDbBloc>()
                                                  .add(
                                                    SortOrdersEvent(
                                                      sort: value,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      CustomText(
                                        text: "Date: ",
                                        textSize: 15,
                                        textColor: darkModeState.darkTheme
                                            ? AppColor.textDarkThemeColor
                                            : AppColor.textLightThemeColor,
                                      ),
                                      Card(
                                        color: darkModeState.darkTheme
                                            ? AppColor.buttonDarkThemeColor
                                            : AppColor.lightThemeColor,
                                        child: InkWell(
                                          focusColor: AppColor.focusColor,
                                          splashColor: AppColor.confirmColor,
                                          radius: 10,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          onTap: () async {
                                            final pickedDate =
                                                await showDatePicker(
                                                  firstDate: DateTime(2025),
                                                  lastDate: DateTime(2150),
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendarOnly,
                                                  context: (context),
                                                );
                                            if (pickedDate != null) {
                                              print(
                                                "Picked Date: ${pickedDate.toString().split(" ").first}",
                                              );
                                              context
                                                  .read<FirebaseDbBloc>()
                                                  .add(
                                                    ShowOrdersByDateEvent(
                                                      selectedDate: pickedDate
                                                          .toString(),
                                                    ),
                                                  );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0,
                                              vertical: 4.0,
                                            ),
                                            child: Icon(
                                              Icons.calendar_month_rounded,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                apiDbState.isRemoveFilterButtonVisible
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              searchBarTextController.clear();
                                              context
                                                  .read<FirebaseDbBloc>()
                                                  .add(
                                                    RemoveAllFilters(
                                                      reset: false,
                                                    ),
                                                  );
                                            },
                                            child: CustomText(
                                              text: "Reset Filters",
                                              textSize: 15,
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                dataList.isEmpty
                                    ? Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 10,
                                            children: [
                                              CustomText(
                                                alignment: TextAlign.center,
                                                textSize: 35,
                                                text: "No Orders Found",
                                                textBoldness: FontWeight.bold,
                                                textColor: AppColor.cancelColor,
                                              ),
                                              CustomText(
                                                alignment: TextAlign.center,
                                                textSize: 30,
                                                text:
                                                    "${apiDbState.filter.name.toString().substring(0, 1).toUpperCase() + apiDbState.filter.name.toString().substring(1).toLowerCase()} orders: ${dataList.length}",
                                                textBoldness: FontWeight.bold,
                                                textColor:
                                                    darkModeState.darkTheme
                                                    ? AppColor
                                                          .textDarkThemeColor
                                                    : AppColor
                                                          .textLightThemeColor,
                                              ),
                                              CustomText(
                                                alignment: TextAlign.center,
                                                textColor:
                                                    darkModeState.darkTheme
                                                    ? AppColor
                                                          .textDarkThemeColor
                                                    : AppColor
                                                          .textLightThemeColor,
                                                textSize: 20,
                                                text:
                                                    "Press Add New Order button below to add orders",
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.separated(
                                          itemCount: dataList.length,
                                          padding: EdgeInsets.only(
                                            top: 3,
                                            left: 10,
                                            right: 10,
                                            bottom: 80,
                                          ),
                                          separatorBuilder: (context, index) =>
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                    ),
                                                child: Divider(
                                                  color: darkModeState.darkTheme
                                                      ? AppColor
                                                            .dividerDarkColor
                                                      : AppColor
                                                            .dividerLightColor,
                                                ),
                                              ),
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 6,
                                              color: darkModeState.darkTheme
                                                  ? (kIsWeb
                                                        ? AppColor
                                                              .scaffoldDarkBackgroundColor
                                                        : AppColor
                                                              .darkThemeColor)
                                                  : AppColor.lightThemeColor,
                                              child: InkWell(
                                                hoverColor:
                                                    AppColor.onHoverColor,
                                                focusColor: AppColor.focusColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                splashColor:
                                                    AppColor.confirmColor,
                                                onTap: () {
                                                  context
                                                      .read<FirebaseDbBloc>()
                                                      .add(
                                                        DetailedOrderPage(
                                                          selectedOrderIndex:
                                                              index,
                                                        ),
                                                      );
                                                  Navigator.pushNamed(
                                                    context,
                                                    RouteNames
                                                        .detailedOrderPage,
                                                  );
                                                },
                                                child: ListTile(
                                                  textColor:
                                                      darkModeState.darkTheme
                                                      ? AppColor
                                                            .textDarkThemeColor
                                                      : AppColor
                                                            .textLightThemeColor,
                                                  isThreeLine: true,
                                                  leading: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 3.0,
                                                    ),
                                                    child: CustomText(
                                                      textSize: 20,
                                                      text:
                                                          "${(index + 1).toString()})",
                                                    ),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      CustomContainer(
                                                        width: 120,
                                                        child: SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: CustomText(
                                                            alignment:
                                                                TextAlign.start,
                                                            textSize: 20,
                                                            text:
                                                                dataList[index]
                                                                    .customer
                                                                    .toString()
                                                                    .substring(
                                                                      0,
                                                                      1,
                                                                    )
                                                                    .toUpperCase() +
                                                                dataList[index]
                                                                    .customer
                                                                    .toString()
                                                                    .substring(
                                                                      1,
                                                                    )
                                                                    .toLowerCase(),
                                                            maxLinesAllowed: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        textSize: 16,
                                                        text:
                                                            '${dataList[index].dateAndTime.toString().split(' ').first}',
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: CustomText(
                                                          textSize: 16,
                                                          text:
                                                              '₹ ${dataList[index].amount}/-',
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
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        spacing: 25,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CustomContainer(
                                                            height: 28,
                                                            width: 90,
                                                            backgroundColor:
                                                                getStatusColor(
                                                                  dataList[index]
                                                                      .status
                                                                      .toString(),
                                                                ),
                                                            borderRadius: 20,
                                                            child: Center(
                                                              child: CustomText(
                                                                text: dataList[index]
                                                                    .status
                                                                    .toString(),
                                                                textSize: 15,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                textBoldness:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            splashColor: AppColor
                                                                .confirmColor,
                                                            focusColor: AppColor
                                                                .focusColor,
                                                            hoverColor: AppColor
                                                                .cancelLightShadeColor,
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (dialogCotext) {
                                                                  return BlocBuilder<
                                                                    FirebaseDbBloc,
                                                                    FirebaseDbState
                                                                  >(
                                                                    buildWhen:
                                                                        (
                                                                          prev,
                                                                          curr,
                                                                        ) =>
                                                                            prev.apiStatus !=
                                                                            curr.apiStatus,
                                                                    builder:
                                                                        (
                                                                          dialogCotext,
                                                                          dialogApiState,
                                                                        ) {
                                                                          return AlertDialog(
                                                                            backgroundColor:
                                                                                darkModeState.darkTheme
                                                                                ? AppColor.darkThemeColor
                                                                                : AppColor.lightThemeColor,
                                                                            title: CustomText(
                                                                              text: "Delete Order?",
                                                                              textSize: 20,
                                                                              textBoldness: FontWeight.bold,
                                                                              textColor: darkModeState.darkTheme
                                                                                  ? AppColor.textDarkThemeColor
                                                                                  : AppColor.textLightThemeColor,
                                                                            ),
                                                                            content: CustomText(
                                                                              text: "Delete order permanently?\nThis action can’t be undone.",
                                                                            ),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: AppColor.confirmColor,
                                                                                ),
                                                                                onPressed: () {
                                                                                  context
                                                                                      .read<
                                                                                        FirebaseDbBloc
                                                                                      >()
                                                                                      .add(
                                                                                        DeleteItem(
                                                                                          id: dataList[index].id,
                                                                                          filter: apiDbState.filter,
                                                                                        ),
                                                                                      );
                                                                                  Navigator.pop(
                                                                                    context,
                                                                                  );
                                                                                },
                                                                                child: CustomText(
                                                                                  text: "Yes",
                                                                                  textColor: AppColor.whiteColor,
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: AppColor.cancelColor,
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.pop(
                                                                                    context,
                                                                                  );
                                                                                },
                                                                                child: CustomText(
                                                                                  text: "No",
                                                                                  textColor: AppColor.whiteColor,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 35,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: BlocBuilder<FirebaseDbBloc, FirebaseDbState>(
              builder: (context, apiDbState) {
                return BlocBuilder<DarkThemeBloc, DarkThemeState>(
                  builder: (context, darkModeState) {
                    if (apiDbState.apiStatus == Status.loading ||
                        apiDbState.apiStatus == Status.failure) {
                      return SizedBox.shrink();
                    } else {
                      return CustomButton(
                        height: 50,
                        backgroundColor: darkModeState.darkTheme
                            ? AppColor.buttonDarkThemeColor
                            : AppColor.buttonLightThemeColor,
                        width: kIsWeb
                            ? 200
                            : (orientation == Orientation.portrait
                                  ? screenWidth / 2
                                  : screenWidth / 4),
                        buttonText: "Add New Order",
                        callback: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.newSalesOrderPage,
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
