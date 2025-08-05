class Transacao {
  final String descricao;
  final double valor;
  final bool isReceita;
  final DateTime data;

  Transacao({
    required this.descricao,
    required this.valor,
    required this.isReceita,
    required this.data
  });

  Map<String, dynamic> toMap() => {
        'descricao': descricao,
        'valor': valor,
        'isReceita': isReceita,
        'data': data
      };

  factory Transacao.fromMap(Map<dynamic, dynamic> map) => Transacao(
        descricao: map['descricao'],
        valor: map['valor'],
        isReceita: map['isReceita'],
        data: map['data']

      );
}
