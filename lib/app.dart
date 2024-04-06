import 'package:flutter/cupertino.dart';
import 'package:flutter_proyecto_isr/screens/home.dart';

class IsrApp extends StatelessWidget {
  const IsrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'IsrApp',
      home: HomeIsr(),
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
    );
  }
}