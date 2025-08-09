import 'package:flutter/material.dart';
import '../models/transacao.dart';
import '../widgets/formulario_transacao.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transacao> _transacoes = [];

  DateTime? dataInicio;
  DateTime? dataFim;

  List<Transacao> get _transacoesFiltradas {
    return _transacoes.where((t) {
      final correspondeData =
          (dataInicio == null || t.data.isAfter(dataInicio!.subtract(const Duration(days: 1)))) &&
          (dataFim == null || t.data.isBefore(dataFim!.add(const Duration(days: 1))));
      return correspondeData;
    }).toList();
  }

  double get _totalReceitas =>
      _transacoesFiltradas.where((t) => t.isReceita).fold(0.0, (soma, t) => soma + t.valor);

  double get _totalDespesas =>
      _transacoesFiltradas.where((t) => !t.isReceita).fold(0.0, (soma, t) => soma + t.valor);

  double get _saldoFinal => _totalReceitas - _totalDespesas;

  void _adicionarTransacao(Transacao transacao) {
    setState(() {
      _transacoes.add(transacao);
    });
  }

  void _deletarTransacao(int index) {
    setState(() {
      final transacaoRemovida = _transacoesFiltradas[index];
      _transacoes.remove(transacaoRemovida);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transação deletada')),
    );
  }

  void _editarTransacao(Transacao transacaoOriginal, Transacao novaTransacao) {
    setState(() {
      final idx = _transacoes.indexOf(transacaoOriginal);
      if (idx != -1) {
        _transacoes[idx] = novaTransacao;
      }
    });
  }

  void _abrirFormulario({bool editar = false, Transacao? transacao, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: FormularioTransacao(
          onSubmit: (novaTransacao) {
            if (editar && transacao != null) {
              _editarTransacao(transacao, novaTransacao);
            } else {
              _adicionarTransacao(novaTransacao);
            }
           // Navigator.of(context).pop();
          },
          transacaoOriginal: transacao,
        ),
      ),
    );
  }

  Future<void> _selecionarDataInicio() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicio ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataInicio = dataSelecionada;
      });
    }
  }

  Future<void> _selecionarDataFim() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataFim ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataFim = dataSelecionada;
      });
    }
  }

  Widget _buildResumoItem(String titulo, double valor, Color cor) {
    return Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          'R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Financeiro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Resumo Financeiro
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildResumoItem('Entradas', _totalReceitas, Colors.green),
                    _buildResumoItem('Saídas', _totalDespesas, Colors.red),
                    _buildResumoItem('Saldo', _saldoFinal, _saldoFinal >= 0 ? Colors.blue : Colors.red),
                  ],
                ),
              ),
            ),

            // Filtros por data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: _selecionarDataInicio,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(dataInicio == null
                      ? 'Início'
                      : '${dataInicio!.day}/${dataInicio!.month}/${dataInicio!.year}'),
                ),
                TextButton.icon(
                  onPressed: _selecionarDataFim,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(dataFim == null
                      ? 'Fim'
                      : '${dataFim!.day}/${dataFim!.month}/${dataFim!.year}'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Lista de transações com Dismissible e opção de editar
            Expanded(
              child: _transacoesFiltradas.isEmpty
                  ? const Center(child: Text('Nenhuma transação encontrada.'))
                  : ListView.builder(
                      itemCount: _transacoesFiltradas.length,
                      itemBuilder: (ctx, index) {
                        final t = _transacoesFiltradas[index];
                        return Dismissible(
                          key: ValueKey('${t.descricao}_${t.data}_${t.valor}_$index'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            _deletarTransacao(index);
                          },
                          child: ListTile(
                            leading: Icon(
                              t.isReceita ? Icons.arrow_downward : Icons.arrow_upward,
                              color: t.isReceita ? Colors.green : Colors.red,
                            ),
                            title: Text(t.descricao),
                            subtitle: Text(
                                '${t.categoria} • ${t.data.day}/${t.data.month}/${t.data.year}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _abrirFormulario(
                                    editar: true,
                                    transacao: t,
                                    index: index,
                                  ),
                                ),
                                Text(
                                  'R\$ ${t.valor.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}