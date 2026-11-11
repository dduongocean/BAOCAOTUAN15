import 'package:flutter/material.dart';
import 'demos/state_lifecycle_demo.dart';
import 'demos/local_state_limit_demo.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chủ đề 10: Quản lý State'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '1. Vòng đời & setState'),
              Tab(text: '2. Giới hạn Local State'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StateLifecycleDemo(),
            LocalStateLimitDemo(),
          ],
        ),
      ),
    );
  }
}
