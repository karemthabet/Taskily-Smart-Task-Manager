import 'package:flutter/material.dart';
import 'package:todo_app/UI/utils/app_colors.dart';

class Diaglogs {
  /// Dialog to show a loading indicator with a message.
  static void showLoading(BuildContext context,
      {bool dismissible = true, required String message}) {
    showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryColor, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Row(
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hide the currently open dialog.
  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  /// Dialog to show a message with optional positive and negative actions.
  static void showMessage(
    BuildContext context, {
    String? title,
    String? body,
    String? posActionTitle,
    String? negActionTitle,
    VoidCallback? posAction,
    VoidCallback? negAction,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800], 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: title != null
            ? Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white, 
                ),
              )
            : null,
        content: body != null
            ? Text(
                body,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, 
                ),
              )
            : null,
        actions: [
          if (negActionTitle != null)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, 
              ),
              onPressed: () {
                negAction?.call();
              },
              child: Text(negActionTitle),
            ),
          if (posActionTitle != null)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, 
              ),
              onPressed: () {
                posAction?.call();
              },
              child: Text(posActionTitle),
            ),
        ],
      ),
    );
  }
}
