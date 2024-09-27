import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Hàm main là điểm bắt đầu của ứng dụng
void main() {
  runApp(const MainApp());
}

// Widget MainApp là widget gốc của ứng dụng, sử dụng một StatelessWidget
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng full-stack đơn giản',
      home: MyHomePage(),
    );
  }
}

// Widget MyHomePage là trang chính của ứng dụng, sử dụng StatefulWidget
// để quản lý trạng thái do có nội dung cần thay đổi trên trang này
class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Lớp state cho MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  // Controller để lấy dữ liệu từ Widget TextField
  final controllerName = TextEditingController();

  final controllerAge = TextEditingController();
    
  // Biến để lưu thông điệp phản hồi từ server
  String responseMessage = '';

  // Hàm gửi tên lên server
  Future<void> sendName() async {
    // Lấy tên từ TextField
    final name = controllerName.text;

    // Sau khi lấy được tên thì xóa nội dung trong controllerName
    // controllerName.clear();

    // Endpoint submit của server
    final url = Uri.parse('http://localhost:8080/api/v1/submit');
    try {
      // Gửi yêu cầu POST tới server
      final response = await http
        .post(
          url,
          headers: {'Content-Type': 'appication/json'},
          body: json.encode({'name': name})
        );
        // .timeout(const Duration(seconds: 10));

      // Kiểm tra nếu phản hồi có nội dung
      if(response.body.isNotEmpty) {
        // Giải mã phản hồi từ server
        final data = json.decode(response.body);

        // Cập nhật trạng thái với thông điệp nhận được từ server
        setState(() {
          responseMessage = data['message'];
        });
      } else {
          // Phản hồi không có nội dung
          setState(() {
            responseMessage = 'Không nhận được phản hồi từ server';
          });
      }
    } catch(e) {
        // Xử lý lỗi kết nối hoặc lỗi khác
        setState(() {
          responseMessage = 'Đã xảy ra lỗi: ${e.toString()}';
        });
    }
  }

  Future<void> sendAge() async {
    // Lấy tên từ TextField
    final age = controllerAge.text;

    // Sau khi lấy được tên thì xóa nội dungAge trong controller
    controllerAge.clear();

    // Endpoint submit của server
    final url = Uri.parse('http://localhost:8080/api/v1/submit');
    try {
      // Gửi yêu cầu POST tới server
      final response = await http
        .post(
          url,
          headers: {'Content-Type': 'appication/json'},
          body: json.encode({'age': age})
        )
        .timeout(const Duration(seconds: 10));

      // Kiểm tra nếu phản hồi có nội dung
      if(response.body.isNotEmpty) {
        // Giải mã phản hồi từ server
        final data = json.decode(response.body);

        // Cập nhật trạng thái với thông điệp nhận được từ server
        setState(() {
          responseMessage = data['message'];
        });
      } else {
          // Phản hồi không có nội dung
          setState(() {
            responseMessage = 'Không nhận được phản hồi từ server';
          });
      }
    } catch(e) {
        // Xử lý lỗi kết nối hoặc lỗi khác
        setState(() {
          responseMessage = 'Đã xảy ra lỗi: ${e.toString()}';
        });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ứng dụng full-stack đơn giản')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: controllerAge,
              decoration: const InputDecoration(labelText: 'Tuổi'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                sendName();
                sendAge();
              },
              child: const Text('Gửi')
            ),
            // Hiển thị thông điệp phản hồi từ server
            Text(
              responseMessage,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
          
        ),
      ),
    );
  }
}