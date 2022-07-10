import 'package:covid/pages/contact.dart';
import 'package:covid/pages/home.dart';
import 'package:covid/pages/scan.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_launcher_icons/xml_templates.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: mainpage(),
    );
  }
}
class mainpage extends StatefulWidget {
  const mainpage({ Key? key }) : super(key: key);

  @override
  _mainpageState createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
          ()=>Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder:
                                                          (context) => 
                                                          secondpage()
                                                         )
                                       )
         );
  }
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 243, 226, 139),
      child:Image.asset('assets/image/splash.PNG')
    );
  }
}
class secondpage extends StatefulWidget {
  const secondpage({ Key? key }) : super(key: key);

  @override
  _secondpageState createState() => _secondpageState();
}

class _secondpageState extends State<secondpage> {
  final _selectedItemColor = Colors.black;
  final _unselectedItemColor = Colors.grey;

  @override
 int _currentindex = 0;
  final tabs = [MyHomePage(),contactpage()];
  // This widget is the root of your application.
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentindex],
     bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        backgroundColor: Colors.white,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.document_scanner_outlined),label: 'Scan'),
        BottomNavigationBarItem(icon: Icon(Icons.contact_mail),label: 'Contact')],
        onTap: (index){
          setState((){
            print(index);
            _currentindex = index;
          });
        }
        
        ,),
      
    );
  }
}
