import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      // o List view precisa de um Container e um tamanho.
      //height: 300, // No meu, só colocando o Expanded (no main), sem setar esta altura, funcionou.
      //
      // Por algum motivo que não entendi, setar esta altura não muda nada no aplicativo.
      // De qualquer forma pode ser útil para setar o tamanho das coisas.
      height: MediaQuery.of(context).size.height * 0.4,

      child: transactions.isEmpty
          ? LayoutBuilder(builder: ((context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    "No transactions added yet!",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 20),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ))
                ],
              );
            }))
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                            // FittedBox Os itens irão reduzir para caber.
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),
                    trailing: MediaQuery.of(context).size.width > 360
                        ? FlatButton.icon(
                            onPressed: () => deleteTx(transactions[index].id),
                            icon: Icon(Icons.delete,
                                color: Theme.of(context).errorColor),
                            label: Text("Delete"))
                        : IconButton(
                            icon: Icon(Icons.delete,
                                color: Theme.of(context).errorColor),
                            onPressed: () => deleteTx(transactions[index].id)),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
