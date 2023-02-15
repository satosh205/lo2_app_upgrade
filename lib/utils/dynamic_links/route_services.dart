
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masterg/utils/dynamic_links/page/courses_page.dart';
import 'package:masterg/utils/dynamic_links/page/portfolio_page.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/portfoliopage':
        return CupertinoPageRoute(builder: (_) {
          return const PortfolioPage();
        });

      case "/coursespage":
        if (args is Map) {
          return CupertinoPageRoute(builder: (_) {
            return CoursesPage(
              coursesId: args["coursesId"],
            );
          });
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}
