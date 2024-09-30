import 'package:flutter/material.dart';

class PopupReport {
  static void show({
    required BuildContext context,
    required Function(String) onSubmit,
    String? hintTextField,
    String? textButtonCancel,
    String? textButtonSend,
    String? textTitle,
  }) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(textTitle ?? 'Mô tả lỗi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input TextArea để người dùng mô tả lỗi
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: hintTextField ?? 'Vui lòng mô tả lỗi...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup
              },
              child: Text(textButtonCancel ?? 'Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Gọi hàm được truyền vào khi nhấn nút
                onSubmit(_controller.text);
                Navigator.of(context).pop(); // Đóng popup
              },
              child: Text(textButtonSend ?? 'Gửi'),
            ),
          ],
        );
      },
    );
  }
}