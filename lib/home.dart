import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Notification'),),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text('data'),
        ),
      ),
    );
  }
}