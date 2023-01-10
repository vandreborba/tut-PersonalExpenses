import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //No tutorial ele mudou para de StatelessWidget para StatefullWidget, pq se não o "title" e "amount" era apagado quando clicava no outro campo.
  //Troquei tb para ficar igual ao tutorial... mas não vi este problema não.
  // Ele diz que os "input" do usuário somem no StatelessWidget quando o fluter "reavalia" o widget.
  //
  final Function addTransactionFunction;

  NewTransaction(this.addTransactionFunction, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      // Se tiver vazio, pode acontecer do "parse", logo abaixo, dar erro.
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTransactionFunction(enteredTitle, enteredAmount, _selectedDate);
    // repare que esta função está na classe! Mas pelo "widget."" conseguimos recuperá-la.
    //
    Navigator.of(context).pop(); // Para fechar quando aperta o botão.
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Para quando o teclado surgir o usuário poder fazer um scroll se necessário.

      // Usar este show modal padrão, tem um problema: O teclado fica por cima das coisas, mas pode ser resolvido com o "padding" + mediaQuery,
      // e o "SingleChildScroll View", como está aqui. O que me parece bom o suficiente, sinceramente...
      //
      // Mas pode usar uma solução alternativa: (não testei!)
      // https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t/57515977#57515977
      //
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  10), // para evitar do teclado ficar em cima das coisas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData),
              TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) =>
                      _submitData // submited: Quando aperta ok no teclado.
                  // O onSubmitted envia um argumento de String. Então ele requer que a função capture este argumento.
                  // Pode colocar uma função anônima ou aceitar este argumento lá na função em si. (Mas aqui usaremos a função em outro lugar, então não faria sentido esta opção)
                  // Este "(_)" é uma convenção. Poderia ser um nome para a variável (val). Mas como não será usada, convencionalmente chama de "_"
                  ),
              Container(
                height: 70,
                child: Row(children: [
                  Text(_selectedDate == null
                      ? "No Date Chosen"
                      : "Picked Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}"),
                  Expanded(
                    child: TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(primary: Colors.purple),
                    ),
                  )
                ]),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text("Add Transaction"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
