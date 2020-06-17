import 'package:Expense_Manager/Widgets/chart.dart';
import './Widgets/new_transaction.dart';
import './Widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import './Models/Transaction.dart';

void main() {
  //If you want to run your app in your defined orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.limeAccent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> transactions = [];
  bool _switchMode = true;
  void _addNewTransaction(String txTitle, double txPrice, DateTime date) {
    final newTx = Transaction(
      title: txTitle,
      price: txPrice,
      id: DateTime.now().toString(),
      timeStamp: date,
    );
    setState(() {
      transactions.add(newTx);
    });
  }

  void _removeTransation(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }

  List<Transaction> get recentTransaction {
    return transactions.where((data) {
      return data.timeStamp.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void startTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    var appBar = AppBar(
      title: Text("Expense Manager"),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            startTransaction(context);
          },
        )
      ],
    );

    var transactionItems = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(transactions, _removeTransation));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Show Chart"),
                  Switch.adaptive(
                    value: _switchMode,
                    onChanged: (bool newVal) {
                      setState(() {
                        _switchMode = newVal;
                      });
                    },
                  )
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(recentTransaction)),
            if (!isLandscape) transactionItems,
            if (isLandscape)
              _switchMode
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(recentTransaction))
                  : transactionItems,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startTransaction(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
