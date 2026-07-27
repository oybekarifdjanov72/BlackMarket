import 'package:black_market/src/features/auth/location/screens/MapScreen.dart';
import 'package:black_market/src/features/favorites/screens/FavoritesScreen.dart';
import 'package:black_market/src/features/history/screens/PurchaseHistoryScreen.dart';
import 'package:black_market/src/features/home/screens/NoPageScreen.dart';
import 'package:black_market/src/features/home/screens/ProductDetailsScreen.dart';
import 'package:black_market/src/features/profile/screens/TermsAndServices.dart';
import 'package:flutter/material.dart';

import '../../../features/auth/screens/ForgotPasswordScreen.dart';
import '../../../features/auth/screens/SignInScreen.dart';
import '../../../features/auth/screens/SignUpScreen.dart';
import '../../../features/home/screens/HomeScreen.dart';
import '../../../features/home/widget/BottomNavigationBarWidget.dart';
import '../../../features/profile/screens/AboutAppScreen.dart';
import '../../../features/profile/screens/ProfileScreen.dart';
import '../../../features/settings/screens/SettingsScreen.dart';
import '../../../features/splash/screens/SplashScreen.dart';
import '../../model/ProductsModel.dart';

class AppRoutes {
  static const splash = '/splash';
  static const signUp = '/sign-up';
  static const signIn = '/sign-in';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const bottomNav = '/bottom-nav';
  static const profile = '/profile';
  static const favorites = '/favorites';
  static const sellPage = '/sell-page';
  static const termsAndServices = '/terms-services';
  static const aboutApp = '/about-app';
  static const settings = '/settings';
  static const purchaseHistory = '/history';
  static const mapScreen = '/map';
}

class AppRouter {
  AppRouter._();

  static Widget _buildPage(String routeName, Object? arguments,) {
    switch (routeName) {
      case AppRoutes.splash:
        return SplashScreen();
      case AppRoutes.signUp:
        return const SignUpScreen();
      case AppRoutes.signIn:
        return const SignInScreen();
      case AppRoutes.forgotPassword:
        return const ForgotPasswordScreen();
      case AppRoutes.home:
        return const HomeScreen();
      case AppRoutes.bottomNav:
        return const BottomNavigationBarWidget();
      case AppRoutes.settings:
        return const SettingsScreen();
      case AppRoutes.profile:
        return const ProfileScreen();
      case AppRoutes.favorites:
        return const FavoritePage();
      case AppRoutes.termsAndServices:
        return const TermsAndServices();
      case AppRoutes.aboutApp:
        return const AboutAppPage();
      case AppRoutes.purchaseHistory:
        return const PurchaseHistoryPage();
      case AppRoutes.mapScreen:
        return const LocationPage();
      case AppRoutes.sellPage:
        return SellPage(model: arguments as ProductModel,);
      default:
        return ErrorPage();
    }
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => _buildPage(settings.name ?? AppRoutes.splash, settings.arguments),
    );
  }

  static Future<T?> push<T extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
        TO? result,
      }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
      BuildContext context,
      String routeName,
      bool Function(Route<dynamic>) predicate, {
        Object? arguments,
      }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate,
      arguments: arguments,
    );
  }
}
