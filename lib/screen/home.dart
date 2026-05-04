import 'package:flutter/material.dart';
import 'package:kotlin_shared_preferences/screen/number.dart';
import 'package:kotlin_shared_preferences/screen/text.dart';

import 'list.dart';
import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TextScreen()),
              ),
              child: Text('text'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NumberScreen()),
              ),
              child: Text('number'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListScreen()),
              ),
              child: Text('list'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ModelScreen()),
              ),
              child: Text('model'),
            ),
          ],
        ),
      ),
    );
  }
}
