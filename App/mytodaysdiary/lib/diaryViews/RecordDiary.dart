import 'package:flutter/material.dart';

class PasswordChangeDialog extends StatefulWidget {
  const PasswordChangeDialog({Key? key}) : super(key: key);

  @override
  _PasswordChangeDialogState createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<PasswordChangeDialog> {
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Password Change'),
      content: Column(
        children: [
          TextField(
            controller: currentPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Current Password'),
          ),
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'New Password'),
          ),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Confirm Password'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel button
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // TODO: Check the current password with the server, check if the new password and confirm password match, and process

            // Assume: Check for a match
            if (currentPasswordController.text == 'CurrentPassword') {
              if (newPasswordController.text == confirmPasswordController.text) {
                // Assume: Password change successful
                // Here you can send the changed password to the server.

                // Close the dialog after a successful password change
                Navigator.of(context).pop();
              } else {
                // Assume: New password and confirm password do not match
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('New password and confirm password do not match.')),
                );
              }
            } else {
              // Assume: Current password does not match
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Current password does not match.')),
              );
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}