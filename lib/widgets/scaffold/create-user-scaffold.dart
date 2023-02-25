import 'package:flutter/material.dart';

class CreateUserScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const CreateUserScaffold({Key? key, required this.child, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: SafeArea(bottom: true, child: child)),
    );
  }
}
