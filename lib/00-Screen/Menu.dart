import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "All Tasks : ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 5,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text(
              "Delete Tasks from previous day",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.left,
            ),
              Transform.scale(scale: 0.7,child: FlutterSwitch(onToggle: (_){},value: true,))],
          )
        ],
      )),
    );
  }
}
