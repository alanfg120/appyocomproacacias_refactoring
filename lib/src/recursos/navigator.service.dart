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

  back() {
    return navigationKey.currentState!.pop();
  }
}
