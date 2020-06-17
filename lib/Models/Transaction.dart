import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final double price;
  final DateTime timeStamp;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.timeStamp,
  });
}
