class Transacao {
  final String descricao;
  final double valor;
  final bool isReceita;
  final DateTime data;
  final String categoria;

  Transacao({
    required this.descricao,
    required this.valor,
    required this.isReceita,
    required this.data,
    required this.categoria
  });

  Map<String, dynamic> toMap() => {
        'descricao': descricao,
        'valor': valor,
        'isReceita': isReceita,
        'data': data,
        'categoria': categoria
      };

  factory Transacao.fromMap(Map<dynamic, dynamic> map) => Transacao(
        descricao: map['descricao'],
        valor: map['valor'],
        isReceita: map['isReceita'],
        data: map['data'],
        categoria: map['categoria']
      );
}
