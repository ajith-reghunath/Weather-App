import 'package:flutter/material.dart';
import 'package:weather_app/design.dart';

class ItemTile extends StatelessWidget {
  IconData icon;
  String text;
  ItemTile({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: iconSize,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}