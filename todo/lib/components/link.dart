import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final bool active;
  final String text;
  final VoidCallback onPressed;

  Link({@required this.active, @required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
        color: this.active ? Theme.of(context).primaryColor : null,
        onPressed: this.onPressed,
        child: new Text(this.text));
  }
}
