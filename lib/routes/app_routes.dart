import 'package:flutter/material.dart';

class AppRoutes {
  static void push(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void pushReplacement(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void pushAndRemoveUntil(
    BuildContext context,
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
