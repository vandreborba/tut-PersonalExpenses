// era para conseguir fazer automaticamente usando ferramenta de "refactory -> extract widget". Mas no flutlab não tem. :(

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionListItemWidget extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTx;
  const TransactionListItemWidget(
      {Key? key, required this.transaction, required this.deleteTx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
                // FittedBox Os itens irão reduzir para caber.
                child: Text('\$${transaction.amount}')),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
                onPressed: () => deleteTx(transaction.id),
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                label: const Text("Delete"))
            : IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                onPressed: () => deleteTx(transaction.id)),
      ),
    );
  }
}
