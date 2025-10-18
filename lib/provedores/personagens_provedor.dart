import 'dart:async';
import 'package:flutter/foundation.dart';
import '../modelos/personagem.dart';
import '../servicos/personagens_repositorio.dart';

class PersonagensProvedor with ChangeNotifier {
  final PersonagensRepositorio repositorio;

  PersonagensProvedor({required this.repositorio});

  List<Personagem> _itens = [];
  List<Personagem> get itens => _itens;

  bool _carregando = false;
  bool get carregando => _carregando;

  bool _carregandoMais = false;
  bool get carregandoMais => _carregandoMais;

  String? _erro;
  String? get erro => _erro;

  int _pagina = 1;
  final int _limite = 8;
  bool _temMais = true;
  String _busca = '';

  Timer? _debounce;

  Future<void> carregarInicial({String busca = ''}) async {
    _pagina = 1;
    _temMais = true;
    _busca = busca;
    _itens = [];
    _erro = null;
    _carregando = true;
    notifyListeners();

    try {
      final lista = await repositorio.buscarPersonagens(
          pagina: _pagina, limite: _limite, nome: _busca.isEmpty ? null : _busca);
      _itens = lista;
      _temMais = lista.length >= _limite;
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> carregarMais() async {
    if (_carregandoMais || !_temMais || _carregando) return;
    _carregandoMais = true;
    _erro = null;
    _pagina++;
    notifyListeners();

    try {
      final lista = await repositorio.buscarPersonagens(
          pagina: _pagina, limite: _limite, nome: _busca.isEmpty ? null : _busca);
      _itens.addAll(lista);
      _temMais = lista.length >= _limite;
    } catch (e) {
      _erro = e.toString();
      _pagina--;
    } finally {
      _carregandoMais = false;
      notifyListeners();
    }
  }

  void buscar(String texto) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      carregarInicial(busca: texto);
    });
  }

  Future<void> tentarNovamente() async {
    await carregarInicial(busca: _busca);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
