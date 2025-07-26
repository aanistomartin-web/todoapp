import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TaskScreen.dart';
import 'login_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Todo List";

  final List<Map<String, dynamic>> categories = [
    {
      "title": "Today",
      "icon": Icons.calendar_today,
      "color": Colors.blueAccent
    },
    {
      "title": "Planned",
      "icon": Icons.event_note,
      "color": Colors.orangeAccent
    },
    {"title": "Personal", "icon": Icons.person, "color": Colors.green},
    {"title": "Work", "icon": Icons.work, "color": Colors.redAccent},
    {"title": "Shopping", "icon": Icons.shopping_cart, "color": Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('username');
    if (storedName != null && storedName.isNotEmpty) {
      setState(() {
        userName = storedName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb3e3b1), // Background color changed here
      appBar: AppBar(
        title: Text(userName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
              if (result == true) {
                loadUserName(); // Refresh username when returning from LoginPage
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome, $userName!",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskScreen(title: category["title"]),
                        ),
                      );
                    },
                    child: Card(
                      color: category["color"],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(category["icon"],
                                size: 40, color: Colors.white),
                            const SizedBox(height: 8),
                            Text(
                              category["title"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffbf8f8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
