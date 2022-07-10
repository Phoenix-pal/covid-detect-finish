import 'package:flutter/material.dart';

class contactpage extends StatefulWidget {
  const contactpage({ Key? key }) : super(key: key);

  @override
  _contactpageState createState() => _contactpageState();
}

class _contactpageState extends State<contactpage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(child: Column(children: [
          Text('Infomation',style: TextStyle(fontSize:30,fontFamily: 'space'),),
          SizedBox(height: 20,),
          Image.asset('assets/image/DSCF3300.jpg',height: 400,width: 400,),
          Text('Phoenix Palaray',style: TextStyle(fontSize: 20,fontFamily: 'space'),),
          SizedBox(height: 20,),
          Image.asset('assets/image/DSCF3243.jpg',height: 400,width: 400),
          Text('Awera Ruampornpanu',style: TextStyle(fontSize: 20,fontFamily: 'space'),),
          SizedBox(height: 20,),
        ]),)
      ],
    );
  }
}