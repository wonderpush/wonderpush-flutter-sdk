import 'package:flutter/material.dart';
import 'package:wonderpush_flutter_plugin_example/event_item.dart';
import 'package:wonderpush_flutter_plugin_example/model/event.dart';

List<Event> lookupEvents = [
  Event(
    event: 'firstVisit',
    text: 'First Visit',
    color: Colors.green,
  ),
  Event(
    event: 'newsRead',
    text: 'News Read',
    color: Colors.purple,
  ),
  Event(
    event: 'gameOver',
    text: 'Game Over',
    color: Colors.red,
  ),
  Event(
    event: 'like',
    text: 'Like',
    color: Colors.teal,
  ),
  Event(
    event: 'addToCart',
    text: 'Add To Cart',
    color: Colors.blue,
  ),
  Event(
    event: 'purchase',
    text: 'Purchase',
    color: Colors.orange,
  ),
  Event(
    event: 'nearEiffelTower',
    text: 'Near Eiffel Tower',
    color: Colors.cyan,
  ),
  Event(
    event: 'nearLouvre',
    text: 'Near Louvre',
    color: Colors.pink,
  ),
  Event(
    event: 'inactiveUser',
    text: 'Inactive User',
    color: Colors.amber,
  )
];

class EventList extends StatefulWidget {
  final Function(String) onTap;

  EventList({this.onTap}):super();

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  void onTap(String eventText) {
   widget.onTap(eventText);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: lookupEvents.length,
        itemBuilder: (BuildContext buildContext, int index) {
          Event eventModel = lookupEvents[index];
          return EventItem(
            event: eventModel.event,
            text: eventModel.text,
            color: eventModel.color,
            onTap: this.onTap,
          );
        });
  }
}
