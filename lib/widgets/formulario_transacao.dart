import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../models/transacao.dart';

class FormularioTransacao extends StatefulWidget {
  final void Function(Transacao) onSubmit;

  const FormularioTransacao({super.key, required this.onSubmit});

  @override
  State<FormularioTransacao> createState() => _FormularioTransacaoState();
}

final List<String> _categorias = [
  'Assinaturas',
  'Contas da casa',
  'Aplicativos',
  'Alimentação',
  'Transporte',
  'Outros',
];
String _categoriaSelecionada = 'Assinaturas';

class _FormularioTransacaoState extends State<FormularioTransacao> {
  final _descricaoController = TextEditingController();
  final _valorController = MoneyMaskedTextController(
  decimalSeparator: ',',
  thousandSeparator: '.',
  leftSymbol: 'R\$ ',
);
  bool _isReceita = true;
  DateTime? _dataSelecionada;

  // Função para abrir o seletor de data
  void _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Data inicial do calendário
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  // Função para submeter o formulário
  void _submit() {
  final descricao = _descricaoController.text;
  final valor = _valorController.numberValue;

  if (descricao.isEmpty || valor <= 0) return;

  final novaTransacao = Transacao(
    descricao: descricao,
    valor: valor,
    isReceita: _isReceita,
    data: _dataSelecionada ?? DateTime.now(),
    categoria: _categoriaSelecionada,
  );

  widget.onSubmit(novaTransacao);
  Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _valorController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Valor'),
              
            ),

            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: _categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSelecionada = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Tipo:'),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Receita'),
                  selected: _isReceita,
                  onSelected: (_) => setState(() => _isReceita = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Despesa'),
                  selected: !_isReceita,
                  onSelected: (_) => setState(() => _isReceita = false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dataSelecionada == null
                        ? 'Nenhuma data selecionada'
                        : 'Data: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}',
                  ),
                ),
                TextButton(
                  onPressed: _selecionarData,
                  child: const Text('Selecionar data'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}