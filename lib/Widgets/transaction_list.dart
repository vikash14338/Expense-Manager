import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  final Function removeTx;

  TransactionList(this._userTransaction, this.removeTx);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _userTransaction.length,
      itemBuilder: (ctx, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          elevation: 4,
          shadowColor: Colors.red,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    '\$${_userTransaction[index].price.toStringAsFixed(2)}',
                  ),
                ),
              ),
            ),
            title: Text('${_userTransaction[index].title}'),
            subtitle: Text(
                '${DateFormat.yMMMMd().format(_userTransaction[index].timeStamp)}'),
            trailing: MediaQuery.of(context).size.width > 430
                ? FlatButton.icon(
                    onPressed: () => removeTx(index),
                    textColor: Colors.red,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: Text("Delete Transaction"))
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => removeTx(index),
                  ),
          ),
        );
      },
    );
  }
}
