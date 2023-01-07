import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        home: MyHomePage(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                titleMedium: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  titleMedium: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 79.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2', title: 'Week Groceries', amount: 16.53, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    // Lista de transações recentes, só queremos mostrar no chart as últimas transações.
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList(); // O where retorna um "interável", mas queremos uma lista.
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime dataChoosen) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: dataChoosen);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        // Cria o widget "flutuante".
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
          // poderia returnar apenas o NewTransaction. Mas para ele não fechar ao clicar no widget: precisa do Gesture Detector.
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Personal Expenses',
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add))
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Chart(_recentTransactions),
            ),
            Expanded(
                // Para a lista ocupar todo o espaço disponível.
                child: TransactionList(_userTransactions, _deleteTransaction))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context)));
  }
}
