import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:provider/provider.dart';

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

  Future<void> changePassword() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse(''),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'newpassword': userProvider.newpassword,
        }),
      );

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('비밀번호 변경'),
      content: Column(
        children: [
          TextField(
            controller: currentPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: '현재 비밀번호'),
          ),
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: '새로운 비밀번호'),
          ),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: '비밀번호 확인'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 취소 버튼
          },
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            // 현재 비밀번호를 서버와 비교하고, 새로운 비밀번호와 확인 비밀번호가 일치하는지 확인하여 처리

            // 예시: 일치하는지 확인
            if (currentPasswordController.text == '현재비밀번호') {
              if (newPasswordController.text == confirmPasswordController.text) {
                // 예시: 비밀번호 변경 성공
                // 여기서 변경된 비밀번호를 서버로 전송할 수 있습니다.
                await changePassword();

                // 비밀번호 변경 성공 후 다이얼로그 닫기
                Navigator.of(context).pop();
              } else {
                // 예시: 새로운 비밀번호와 확인 비밀번호가 일치하지 않음
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('새로운 비밀번호와 확인 비밀번호가 일치하지 않습니다.')),
                );
              }
            } else {
              // 예시: 현재 비밀번호가 일치하지 않음
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('현재 비밀번호가 일치하지 않습니다.')),
              );
            }
          },
          child: Text('확인'),
        ),
      ],
    );
  }
}
