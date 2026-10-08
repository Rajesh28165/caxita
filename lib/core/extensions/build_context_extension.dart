import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  Future<T?> showAppSheet<T>(Widget child) => showModalBottomSheet<T>(
    context: this,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  );

  void showSnack(String msg) => ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(msg)));
}