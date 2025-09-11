import 'package:com.example.order_management_application/bloc/alert_pop_up/alert_popup_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/cloud_firebase_data/firebase_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/dark_theme_mode/dark_theme_bloc_events_state.dart';
import 'package:com.example.order_management_application/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:com.example.order_management_application/bloc/new_order/new_order_bloc_events_state.dart';
import 'package:com.example.order_management_application/custom_widgets/import_all_custom_widgets.dart';
import 'package:com.example.order_management_application/firebase_options.dart';
import 'package:com.example.order_management_application/pages/all_pages.dart';
import 'package:com.example.order_management_application/routes/all_routes.dart';
import 'package:com.example.order_management_application/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AppColors/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FirebaseDbBloc()),
        BlocProvider(create: (_) => FirebaseAuthBloc()),
        BlocProvider(create: (_) => DarkThemeBloc()),
        BlocProvider(
          create: (context) => NewOrderBloc(context.read<FirebaseDbBloc>()),
        ),
        BlocProvider(
          create: (context) => (AlertPopUpBloc(context.read<FirebaseDbBloc>())),
        ),
      ],
      child: BlocBuilder<DarkThemeBloc, DarkThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Order Manager',
            debugShowCheckedModeBanner: false,
            themeMode: state.darkTheme ? ThemeMode.dark : ThemeMode.light,
            // Dark Theme
            darkTheme: ThemeData.dark().copyWith(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColor.scaffoldDarkBackgroundColor,
              appBarTheme: AppBarTheme(
                surfaceTintColor: AppColor.transparentColor,
                elevation: 0,
                backgroundColor: AppColor.appbarDarkThemeColor,
              ),
            ),
            // Light Theme
            theme: ThemeData.light().copyWith(
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColor.scaffoldLightBackgroundColor,
              appBarTheme: AppBarTheme(
                surfaceTintColor: AppColor.transparentColor,
                elevation: 0,
                backgroundColor: AppColor.appbarLightThemeColor,
              ),
            ),
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? RouteNames.userAuthenticationPage
                : RouteNames.myHomePage,
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AlertPopUpBloc>().add(GetHighOrderAlert());
    context.read<FirebaseDbBloc>().add(FetchOnlineData());
    context.read<DarkThemeBloc>().add(GetDarkModePreference());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FirebaseDbBloc, FirebaseDbState>(
          listener: (context, apiState) {
            if (apiState.apiStatus == Status.success) {
              context.read<AlertPopUpBloc>().add(
                GetPendingAndLimitCrossedOrders(),
              );
            }
          },
        ),
        BlocListener<AlertPopUpBloc, AlertPopUpStates>(
          listenWhen: (old, latest) =>
              old.limitCrossedOrders != latest.limitCrossedOrders,
          listener: (context, alertPopUpState) {
            bool pendingPopUpShown = alertPopUpState.pendingPopUpShow;
            Future<void> showPopUP(String title, String message) async {
              await showDialog(
                context: context,
                builder: (context) =>
                    BlocBuilder<DarkThemeBloc, DarkThemeState>(
                      builder: (context, darkThemeState) => CustomAlertBox(
                        backgroundColor: darkThemeState.darkTheme
                            ? AppColor.darkThemeColor
                            : AppColor.lightThemeColor,
                        buttonTextColor: darkThemeState.darkTheme
                            ? AppColor.alertBtnTextDarkColor
                            : AppColor.alertBtnTextLightColor,
                        confirmationButtonColor: darkThemeState.darkTheme
                            ? AppColor.alertBtnDarkColor
                            : AppColor.alertBtnLightColor,
                        title: title,
                        message: message,
                      ),
                    ),
              );
            }

            if (alertPopUpState.lastHighOrderCustomerName.isNotEmpty &&
                alertPopUpState.lastHighOrderCustomerAmount > 0 &&
                alertPopUpState.highOrderAlertPopupShow == false) {
              showPopUP(
                "High Order Alert",
                "Last Highest amount Order was ₹ ${alertPopUpState.lastHighOrderCustomerAmount}/- from (${alertPopUpState.lastHighOrderCustomerName})",
              ).then((_) {
                if (!context.mounted) return;
                context.read<AlertPopUpBloc>().add(ClearHighOrderAlert());
                if (!pendingPopUpShown) {
                  int pendingOrders = alertPopUpState.pendingOrders;
                  int totalPendingAmount =
                      alertPopUpState.totalPendingOrderAmount;
                  showPopUP(
                    "Pending Orders",
                    "In the last 10 orders, $pendingOrders are pending worth ₹$totalPendingAmount.",
                  ).then((_) {
                    if (!context.mounted) return;
                    context.read<AlertPopUpBloc>().add(
                      PendingPopupShown(isShown: true),
                    );
                  });
                }
              });
            } else {
              if (!pendingPopUpShown) {
                int pendingOrders = alertPopUpState.pendingOrders;
                int totalPendingAmount =
                    alertPopUpState.totalPendingOrderAmount;
                showPopUP(
                  "Pending Orders",
                  "In the last 10 orders, $pendingOrders are pending worth ₹$totalPendingAmount.",
                ).then((_) {
                  if (!context.mounted) return;
                  context.read<AlertPopUpBloc>().add(
                    PendingPopupShown(isShown: true),
                  );
                });
              }
            }
            bool limitCrossPopUpShow = alertPopUpState.limitPopUpShow;
            if (limitCrossPopUpShow == false &&
                alertPopUpState.apiStatus == Status.success) {
              showPopUP(
                "High Amount Orders",
                "Among the latest 10 orders, ${alertPopUpState.limitCrossedOrders} have crossed ₹ 10,000/-",
              ).then((_) {
                if (!context.mounted) return;
                context.read<AlertPopUpBloc>().add(
                  LimitCrossedPopupShown(show: true),
                );
              });
            }
          },
        ),
      ],
      child: DashboardPage(),
    );
  }
}
