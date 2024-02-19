import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/TokenSave.dart';
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

  // 비밀번호 변경 요청
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = await TokenStorage.getToken();

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('http://skhugdsc.duckdns.org/user/password'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'currentPassword': currentPassword,
            'newPassword': newPassword,
          }),
        );

        if (response.statusCode == 200) {
          // 비밀번호 변경 성공
          print('Success: ${response.body}');
          Navigator.of(context).pop(); // 다이얼로그 닫기
        } else if (response.statusCode == 400) {
          // 현재 비밀번호가 일치하지 않음
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('현재 비밀번호가 일치하지 않습니다.')),
          );
        } else {
          // 기타 오류
          print('Failed with status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('비밀번호 변경에 실패했습니다. 다시 시도해주세요.')),
          );
        }
      } catch (error) {
        // 오류 발생
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호 변경 중 오류가 발생했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('비밀번호 변경'),
      content: SizedBox(
        height: 250,
      child: Column(
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

            // 현재 비밀번호가 일치하는지 확인
            if (currentPasswordController.text.isNotEmpty) {
              // 새로운 비밀번호와 확인 비밀번호가 일치하는지 확인
              if (newPasswordController.text == confirmPasswordController.text) {
                // 비밀번호 변경 요청
                await changePassword(
                  currentPasswordController.text,
                  newPasswordController.text,
                );

                // 비밀번호 변경 성공 후 다이얼로그 닫기
                Navigator.of(context).pop();
              } else {
                // 새로운 비밀번호와 확인 비밀번호가 일치하지 않음
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('새로운 비밀번호와 확인 비밀번호가 일치하지 않습니다.')),
                );
              }
            } else {
              // 현재 비밀번호가 입력되지 않음
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('현재 비밀번호를 입력하세요.')),
              );
            }
          },
          child: Text('확인'),
        ),
      ],
      
      
    );
  }
}
