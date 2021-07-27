import 'package:flutter/material.dart';

class KyText extends Text {
  KyText(String data, { color: Colors.indigo, textAlign = TextAlign.center, fontSize = 15.0, fontStyle = FontStyle.normal }):
        super(
        data = data,
        textAlign: textAlign,
        style: new TextStyle(
            color: color,
            fontStyle: fontStyle,
            fontSize: fontSize
        ),
      );
}