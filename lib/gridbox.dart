import 'package:flutter/material.dart';

class GridBox {
  static Container informationBox(String primary, String secondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Expanded(child: FittedBox(fit: BoxFit.contain, child: Text(primary))),
        Text(secondary),
      ]),
    );
  }
}
