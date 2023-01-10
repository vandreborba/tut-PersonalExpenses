import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding
  //     .ensureInitialized(); // Antes do set Orientations, nas novas versões, tem que colocar esta linha.
  // SystemChrome.setPreferredOrientations([
  //   // Seta as orientações possíveis.
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);

  // Para adaptar para iOS tem que fazer várias alterações nos widget, como o flutlab deu uma série de problemas, não irei me preocupar em implementar.
  // Até pq não tenho interesse no momento em fazer isto.

  runApp(MyApp());
}

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

  bool _showChart = false;

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
    // O professor colocou o AppBar em uma variável separada, para poder utilizar a altura como referência.
    // Mas de qq forma, para mim por ser uma maneira mais fácil de organizar as coisas, ficando menos sujo o "return"
    //
    final mediaQuery =
        MediaQuery.of(context); // Daria para usar diretamente nos itens,
    // mas para não chamar a função várias vezes, é recomendado salvar o mediaQuery em uma variável.

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = (
        //Platform.isIOS // o flutlab não aceita este comando, por algum motivo.
        false
            ? //Aqui novamente não precisaria colocar o preferred Size, mas precisou para saber que terá a função no preferredSize

            // Isto aqui não funcionou não... dá erro lá no
            CupertinoNavigationBar() // Colocaria o título e tal, mas sinceramente, como está dando problema no flutlab, não irei me preocupar.
            : AppBar(
                title: Text(
                  'Personal Expenses',
                ),
                actions: <Widget>[
                  IconButton(
                      onPressed: () => _startAddNewTransaction(context),
                      icon: Icon(Icons.add))
                ],
              )) as PreferredSizeWidget;

    final txListWiget = Expanded(
        // Para a lista ocupar todo o espaço disponível.
        // Daria para fazer a mesma coisa do anterior, setar uma height fixa. Mas não sei, acho que o Expanded faz mais sentido, sinceramente.
        // height: MediaQuery.of(context).size.height * 0.6 - appBar.preferredSize.height,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
        child: Column(
      children: <Widget>[
        if (isLandscape)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Cuidar que este if é um if específico da linguagem, é um if dentro de uma lista!
            Text('Show Chart'),
            Switch.adaptive(
              // Este .adaptive permite que seja desenhado no no formato iOS / Android dependendo do sistema que o usuário está usando.
              // Pode usar sem o ".adaptive", assim ele desenha, no caso, no formato do android.
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              },
            )
          ]),
        if (!isLandscape)
          Container(
              width: double.infinity,
              child: Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  // Não vejo sentido em setar a altura assim, mas vou deixar assim para referências posteriores.
                  // MediaQuery.of(context).padding.top é topo do celuar, aquela informação onde fica a bateria, e afins.
                  child: Chart(_recentTransactions))),
        if (!isLandscape) txListWiget,
        if (isLandscape)
          _showChart
              ? Container(
                  width: double.infinity,
                  child: Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      // Não vejo sentido em setar a altura assim, mas vou deixar assim para referências posteriores.
                      // MediaQuery.of(context).padding.top é topo do celuar, aquela informação onde fica a bateria, e afins.
                      child: Chart(_recentTransactions)))
              : txListWiget
      ],
    ));

    return //Platform.isIOS // Acho que o Flutlab não aceita
        false
            ? // Não precisa fazer isto, pode usar só o Scaffold. Mas pode fazer assim para ter visual mais coerente no iOS e Android.
            CupertinoPageScaffold(
                child: pageBody,
                navigationBar: appBar as ObstructingPreferredSizeWidget,
              )
            : Scaffold(
                appBar: appBar,
                body: pageBody,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton:
                    //Platform.isIOS
                    false
                        ? Container()
                        : FloatingActionButton(
                            // No caso o professor preferiu não exibir este botão flutuante quando estiver no iOS, pq os app do iOS normalmente não tem.
                            child: Icon(Icons.add),
                            onPressed: () => _startAddNewTransaction(context)));
  }
}
