import 'package:flutter/material.dart';

class WidgetUtils {
  static AppBar CreateAppBar(String title) {//appbarの再利用
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        "title",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
