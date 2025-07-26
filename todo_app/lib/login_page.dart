import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    final enteredName = _nameController.text.trim();
    if (enteredName.isNotEmpty) {
      await prefs.setString('username', enteredName);
      Navigator.pop(context, true); // Return to HomeScreen and refresh name
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your name",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveName,
              child: const Text("Save and Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
