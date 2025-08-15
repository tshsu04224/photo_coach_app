import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
    BuildContext context,
    String message, {
      String confirmText = "確定",
      String cancelText = "取消",
    }) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    ),
  ) ??
      false; // user點空白處或返回
}
