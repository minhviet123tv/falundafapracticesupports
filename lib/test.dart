import 'package:flutter/material.dart';

void main() {
  runApp(Test());
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: TestHome(),
      )),
    );
  }
}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Content !!!")));
          },
          child: Text("Button")),
    );
  }
}
