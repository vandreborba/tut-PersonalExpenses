import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        // É uma forma de definir os constraints. No caso ele usou para calcular o tamanho da barra de forma dinâmica.
        // Particularmente eu acho que poderia deixar um tamanho fixo mesmo, mas tudo bem.

        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  // Para quando o fitbox diminuir o texto, ele continuar ocupando o mesmo espaço, e náo desalinhar outros elementos.
                  //Ele diminui as coisas se não couber no espaço disponível.
                  child: Text('\$${spendingAmount.toStringAsFixed(2)}')),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        color: Color.fromRGBO(220, 220, 220, 1),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(child: Text(label)))
          ],
        );
      }),
    );
  }
}
