import 'package:flutter/material.dart';

/// Terminal Screen
class TerminalWidget extends StatelessWidget {
  final List<String> terminals;
  final ScrollController controller;

  const TerminalWidget(this.terminals, this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: ListView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          return Text(
            terminals[index],
            style: TextStyle(color: Colors.white),
          );
        },
        itemCount: terminals.length,
        shrinkWrap: true,
      ),
    );
  }
}
