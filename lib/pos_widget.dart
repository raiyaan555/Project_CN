import 'dart:convert';
import 'dart:io';

import 'package:cn_test_app/udp/udp_test.dart';
import 'package:flutter/material.dart';
import 'package:cn_test_app/terminal_widget.dart';
import 'package:cn_test_app/udp/udp_test.dart';

/// POS Screen
class POSWidget extends StatefulWidget {
  @override
  _POSWidgetState createState() => _POSWidgetState();
}

class _POSWidgetState extends State<POSWidget> {
  String ip = '224.0.2.200';
  int port = 7777; // default server port is 7777

  List<Datagram> cds = [];
  List<String> terminals = [];

  String strCdsConnected = "No CDS Connected";
  var _scrollController = ScrollController();

  UDPTest _udpTest = UDPTest();

  @override
  void initState() {
    super.initState();
    initServer();
  }

  initServer() async {
    _udpTest.addReceiveEventListener(RESPONSE, (Datagram datagram) {
      // Checking is the new CDS well add to List
      if (cds.any((element) => element.port != datagram.port)) {
        cds.add(datagram);
      }

      // Convert list cds to String
      cds.forEach((element) {
        strCdsConnected += '${element.port},';
      });

      // Add new message of the CDS to terminals
      terminals.add(
          'Res-[${datagram.address.address}:${datagram.port}]:\n${ascii.decode(datagram.data)}');
      setState(() {});
    });

    // Add my message sending to terminals
    _udpTest.addSenderEventListener(SENDER, (String str) {
      terminals.add('Send-[$ip:$port]:\n$str');
      setState(() {});
    });

    await _udpTest.bindMulticastServer(ip, port);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                child: TerminalWidget(terminals, _scrollController))),

        // List CDS connected
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Server connected CDS: $strCdsConnected',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}