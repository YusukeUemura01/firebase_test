import 'package:firebase_test/view/acount_page.dart';
import 'package:firebase_test/view/post_page.dart';
import 'package:firebase_test/view/time_line_page.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;
  List<Widget> pageList = [TimeLinePage(),AccountPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index){
          selectedIndex = index;
          setState(() {

          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ""
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>PostPage()));
        },
      ),
    );
  }
}
