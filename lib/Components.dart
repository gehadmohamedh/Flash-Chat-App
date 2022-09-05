import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {@required this.text, @required this.onpress, @required this.color});
  final String text;
  final Color color;
  final Function onpress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
