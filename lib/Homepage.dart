import 'package:flutter/material.dart';
import 'package:project/page1.dart';
import 'package:project/route.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: TextButton(
            onPressed: () {
              Navigator.push(context, SlideRightRoute(page: Page1()));
            },
            child: Text('OK'),
          ),
        ),
      ),
    );
  }
}
