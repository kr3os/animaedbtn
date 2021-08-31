import 'package:flutter/material.dart';

import 'package:animatedbutton/widgets/animated_button_widget.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FLutter simple Animation',
      home: Scaffold(
        body: Center(
          child: Container(
            child: AnimatedButton(
              onTap: (){
                print("animated button pressed");
              },
              animationDuration: const Duration(milliseconds: 1000),
              initialText: "Confirm",
              finalText: "Submited",
              iconData: Icons.check,
              iconSize: 32.0,
              buttonAnimStyle: ButtonAnimStyle(
                pirmaryColor: Colors.green.shade600,
                secondaryColor: Colors.white,
                elevation: 20.0,
                initialTextStyle: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
                finalTextStyle: TextStyle(
                  fontSize: 22.0,
                  color: Colors.green.shade600
                ),
                borderRadius: 10.0
              ),
            ),
          ),
        ),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
    );
  }
}