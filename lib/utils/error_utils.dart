import 'package:ai_improv/utils/api_exception.dart';
import 'package:flutter/material.dart';

class ErrorUtils {
  static void showErrorSnackbar(ApiException exception, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        'Error: ${exception.message}\nStatus Code: ${exception.statusCode}',
        style: const TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'Details',
        onPressed: () {
          showErrorDialog(exception, context);
        },
      ),
      backgroundColor: Colors.red,
    );
    // Find the ScaffoldMessenger in the widget tree and show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorDialog(ApiException exception, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Details'),
          content: SingleChildScrollView(
            child: Text(
              'Message: ${exception.message}\n'
              'Status Code: ${exception.statusCode}\n'
              'Details: ${exception.details ?? 'No details available'}',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
