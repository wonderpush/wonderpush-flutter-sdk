import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final String event;
  final String text;
  final Color color;
  final Function(String) onTap;
  EventItem({this.event, this.text, this.color, this.onTap}) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: this.color,
      child: ListTile(
        onTap: () {
          this.onTap(this.event);
        },
        title: Text(
          "$text",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.00,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Tap to subscribe/Unsubscribe",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
