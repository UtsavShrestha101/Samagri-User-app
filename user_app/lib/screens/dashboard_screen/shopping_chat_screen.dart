import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShoppingChatScreen extends StatefulWidget {
  const ShoppingChatScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingChatScreen> createState() => _ShoppingChatScreenState();
}

class _ShoppingChatScreenState extends State<ShoppingChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Shopping Chat Screen"),
      ),
    );
  }
}