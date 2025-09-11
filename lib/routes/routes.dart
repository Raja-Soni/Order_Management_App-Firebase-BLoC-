import 'package:com.example.order_management_application/routes/all_routes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../pages/all_pages.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.userAuthenticationPage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const UserAuthenticationPage(),
        );
      case RouteNames.myHomePage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const MyHomePage(),
        );
      case RouteNames.newSalesOrderPage:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: NewSalesOrderPage(),
        );
      case RouteNames.detailedOrderPage:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: DetailedOrderPage(),
        );
    }
    return null;
  }
}
