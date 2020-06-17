import '../Models/Transaction.dart';
import '../Widgets/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> latestTransaction;
  Chart(this.latestTransaction);
  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (int i = 0; i < latestTransaction.length; i++) {
        if (latestTransaction[i].timeStamp.day == weekday.day &&
            latestTransaction[i].timeStamp.month == weekday.month &&
            latestTransaction[i].timeStamp.year == weekday.year) {
          totalSum += latestTransaction[i].price;
        }
      }

      return {
        'day': (DateFormat.E().format(weekday)).substring(0, 1),
        'price': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransaction.fold(0.0, (sum, element) {
      return sum + (element['price'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransaction.map((data) {
            print(totalSpending);
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBox(
                  label: data['day'],
                  spendingAmount: (data['price']),
                  spendingPercentage: (data['price'] as double) / totalSpending,
                ));
          }).toList(),
        ),
      ),
    );
  }
}
