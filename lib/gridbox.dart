import 'package:flutter/material.dart';

class GridBox {
  static Container informationBox(String primary, String secondary) {
    return widgetBox(Text(primary), secondary);
  }

  static Container widgetBox(Widget widget, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Expanded(child: FittedBox(fit: BoxFit.contain, child: widget)),
        Text(label),
      ]),
    );
  }
}
