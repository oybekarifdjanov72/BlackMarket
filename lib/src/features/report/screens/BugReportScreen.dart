import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});

  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final TextEditingController bugReportController = TextEditingController();
  String botToken = '8195029792:AAGSYJtE6cOw8sCM6dsSZF5W9xllFZ_PtNE';
  String chatId = '5045578026';

  int lastUpdateId = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (_) => getUpdates());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> getUpdates() async {
    final url =
        'https://api.telegram.org/bot$botToken/getUpdates?offset=${lastUpdateId + 1}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updates = data['result'];

        for (var update in updates) {
          final message = update['message']['text'];
          final from = update['message']['from']['username'];
          print('From @$from: $message');

          sendConfirmationMessage();

          lastUpdateId = update['update_id'];
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> sendConfirmationMessage() async {
    final String responseMessage =
        "Moderators will check your bug in 5-20 minutes, thank you for helping.";
    final url =
        'https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=${Uri.encodeFull(responseMessage)}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Confirmation message sent');
      } else {
        print('Failed to send confirmation message');
      }
    } catch (e) {
      print('Error sending confirmation message: $e');
    }
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Report a Bug"),
          content: TextField(
            controller: bugReportController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Describe the bug",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final message = bugReportController.text;
                sendUserBugToTelegram(message);
                Navigator.of(context).pop();
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendUserBugToTelegram(String message) async {
    final url =
        'https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=${Uri.encodeFull(message)}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Bug report sent');
      } else {
        print('Failed to send bug report');
      }
    } catch (e) {
      print('Error sending bug report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bug Report')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showBugReportDialog(context);
          },
          child: Text('Report Bug'),
        ),
      ),
    );
  }
}