import 'package:flutter/material.dart';

class PopupReport {
  static void show({
    required BuildContext context,
    required Function(void) onCancel,
    required Function(String) onSubmit,
    String? hintTextField,
    String? textButtonCancel,
    String? textButtonSend,
    String? textTitle,
    String? textValidateValue,
  }) {
    TextEditingController _controller = TextEditingController();
    String? errorMessage; // Biến để lưu thông báo lỗi

    showDialog(
      context: context,
      barrierDismissible: false, // Không cho đóng khi nhấn ra ngoài
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
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
                    errorText: errorMessage, // Hiển thị lỗi nếu có
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onCancel;
                  Navigator.of(context).pop(); // Đóng popup
                },
                child: Text(textButtonCancel ?? 'Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Kiểm tra nếu người dùng chưa nhập mô tả
                  if (_controller.text.trim().isEmpty) {
                    setState(() {
                      errorMessage = textValidateValue ?? 'Vui lòng nhập mô tả lỗi'; // Đặt thông báo lỗi
                    });
                  } else {
                    // Nếu có mô tả, gọi hàm onSubmit và đóng popup
                    onSubmit(_controller.text);
                    Navigator.of(context).pop(); // Đóng popup
                  }
                },
                child: Text(textButtonSend ?? 'Gửi'),
              ),
            ],
          );
        });
      },
    );
  }
}