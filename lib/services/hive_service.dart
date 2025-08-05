import 'package:hive/hive.dart';
import '../models/transacao.dart';

class HiveService {
  static final _box = Hive.box('transacoes');

  static List<Transacao> getTransacoes() {
    return _box.values
        .map((e) => Transacao.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> addTransacao(Transacao t) async {
    await _box.add(t.toMap());
  }

  static Future<void> deleteTransacao(int index) async {
    await _box.deleteAt(index);
  }

  static int get count => _box.length;

  static Transacao getAt(int index) {
    final map = Map<String, dynamic>.from(_box.getAt(index));
    return Transacao.fromMap(map);
  }
}
