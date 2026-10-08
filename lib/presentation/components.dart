import 'package:flutter/material.dart';

class GeneralComponent {
  GeneralComponent._();


  static Widget appButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7941D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }


  static Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }


  static Widget errorView({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }


  static Widget emptyView({
    String message = 'No flights found',
  }) {
    return Center(
      child: Text(message),
    );
  }
}