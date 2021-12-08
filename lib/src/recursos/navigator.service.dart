import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey;

  static NavigationService _instance =
      NavigationService._internal(GlobalKey<NavigatorState>());

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal(this.navigationKey);

  Future<dynamic> navigateToReplacement(String _rn) {
    return navigationKey.currentState!.pushReplacementNamed(_rn);
  }

  Future<dynamic> navigateTo(String _rn) {
    return navigationKey.currentState!.pushNamed(_rn);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _rn) {
    return navigationKey.currentState!.push(_rn);
  }
  Future<dynamic> navigateToRouteReplace(MaterialPageRoute _rn) {
    return navigationKey.currentState!.pushReplacement(_rn);
  }
  Future<dynamic> navigateToRouteReplaceUntil(MaterialPageRoute _rn) {
    return navigationKey.currentState!.pushAndRemoveUntil(_rn, (route) => false);
  }

  back() {
    return navigationKey.currentState!.pop();
  }
}
