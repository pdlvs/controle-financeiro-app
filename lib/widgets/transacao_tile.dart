import 'package:flutter/material.dart';
import '../models/transacao.dart';

class TransacaoTile extends StatelessWidget {
  final Transacao transacao;

  const TransacaoTile({super.key, required this.transacao});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transacao.isReceita ? Icons.arrow_downward : Icons.arrow_upward,
        color: transacao.isReceita ? Colors.green : Colors.red,
      ),
      title: Text(transacao.descricao),
      trailing: Text(
        'R\$ ${transacao.valor.toStringAsFixed(2)}',
        style: TextStyle(
          color: transacao.isReceita ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
