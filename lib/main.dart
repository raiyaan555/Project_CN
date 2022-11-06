import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cn_test_app/pos_widget.dart';
import 'package:cn_test_app/udp/udp_test.dart';

import 'cds_widget.dart';

main() async {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
}

enum Permission { NODE, POS, CDS }



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'TCP/UDP', key: null,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Permission permission = Permission.NODE;

  void _selectPermission(Permission permission) {
    setState(() {
      this.permission = permission;
    });
  }

  Widget content() {
    if (permission == Permission.POS) {
      return POSWidget();
    } else if (permission == Permission.CDS) {
      return CDSWidget();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width:  MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.orange,

                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
              child: Center(
                  child:Text(
                    'Start the Server',
                    style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold, ),
                  ))),
            ),
            onTap: () {
          _selectPermission(Permission.POS);
            },
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width:  MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                        width: 7
                      ),

                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
              child: Center(
                  child: Text(
                'Start the Client',
                style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold, ),
              ))),
            ),
            onTap: () {
          _selectPermission(Permission.CDS);
            },
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0,

        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title, style: TextStyle(
            fontSize: 35,
            color: Colors.white,
          ),),
        ),
      ),
      body: Center(
        child: content(),
      ),
    );
  }
}
