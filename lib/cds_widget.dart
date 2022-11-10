import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cn_test_app/terminal_widget.dart';
import 'package:cn_test_app/udp/udp_test.dart';

/// CDS Screen
class CDSWidget extends StatefulWidget {
  @override
  _CDSWidgetState createState() => _CDSWidgetState();
}

class _CDSWidgetState extends State<CDSWidget> {
  String ip = '224.0.2.200';
  int port = 7777; // default server port is 7777
  bool isConnected = false;

  List<String> terminals = [];

  var controller = ScrollController();

  UDPTest _udpTest = UDPTest();

  TextEditingController _myPortController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  connectPOS(int myPort) async {
    _udpTest.addReceiveEventListener(RESPONSE, (Datagram datagram) {
      // Add new message of the CDS to terminals
      terminals.add(
          'Res-[${datagram.address.address}:${datagram.port}]:\n${ascii.decode(datagram.data)}');

      setState(() {
        if (ascii.decode(datagram.data) == ACCEPT) isConnected = true;
      });
    });

    // Add my message sending to terminals
    _udpTest.addSenderEventListener(SENDER, (String str) {
      terminals.add('Send-[$ip:$port]:\n$str');
      setState(() {});
    });
    await _udpTest.connectServer(ip, port, myPort);
  }

  widgetConnect() => isConnected
      ? Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),

            Expanded(

              child: Padding(

                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    cursorColor: Colors.white,
                    style:TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    controller: _messageController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        //Outline border type for TextFeild
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 2,
                          )),
                      focusedBorder: OutlineInputBorder(
                        //Outline border type for TextFeild
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 2,
                          )),
                      hintText: ' Enter Message',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white60,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            TextButton(
              onPressed: () {
                _udpTest.send(_messageController.text);
              },
              child: Text('Send',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  )),
            )
          ],
        )
      : Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  cursorColor: Colors.white,
                  style:TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  controller: _myPortController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        //Outline border type for TextFeild
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2,
                        )),
                    focusedBorder: OutlineInputBorder(
                        //Outline border type for TextFeild
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2,
                        )),
                    hintText: ' Port Number (Minimum 4)',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.white60,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            )),
            SizedBox(
              width: 8.0,
            ),
            TextButton(
              onPressed: () {
                connectPOS(int.parse(_myPortController.text.toString()));
              },
              child: Text('Connect',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  )),
            )
          ],
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widgetConnect(),
        SizedBox(
          height: 8.0,
        ),
        // My info
        Text(
          'Server is running!\n'
          'IP: $ip:$port',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        // List terminal
        Expanded(
            child: Container(
                margin: EdgeInsets.all(8.0),
                child: TerminalWidget(terminals, controller))),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
