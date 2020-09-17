import 'package:flutter/material.dart';

class ListElement extends StatelessWidget {
  final Widget mainWidget;
  final Function onTap;
  final bool centered;

  const ListElement({
    @required this.mainWidget,
    @required this.onTap,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                mainWidget,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
