import 'dart:async';
import 'package:demon_slayer_app/provedores/tema_provedor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provedores/personagens_provedor.dart';
import '../widgets/item_lista_personagem.dart';
import '../widgets/erro_view.dart';

class ListaPersonagensTela extends StatefulWidget {
  const ListaPersonagensTela({super.key});

  @override
  State<ListaPersonagensTela> createState() => _ListaPersonagensTelaState();
}

class _ListaPersonagensTelaState extends State<ListaPersonagensTela> {
  final _scrollController = ScrollController();
  final _buscaController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_aoRolar);
  }

  void _aoRolar() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<PersonagensProvedor>(context, listen: false).carregarMais();
    }
  }

  void _onBuscaChanged(String texto) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        Provider.of<PersonagensProvedor>(context, listen: false).buscar(texto);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _buscaController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Demon Slayer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _abrirDialogoBusca,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          // Botão de alternar tema
          Consumer<TemaProvedor>(
            builder: (context, tema, _) {
              return IconButton(
                onPressed: () {
                  tema.alternarTema();
                },
                icon: Icon(
                  tema.modo == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<PersonagensProvedor>(
        builder: (context, provedor, child) {
          if (provedor.carregando && provedor.itens.isEmpty) {
            return _buildLoadingState();
          }

          if (provedor.erro != null && provedor.itens.isEmpty) {
            return ErroView(
              mensagem: provedor.erro!, 
              aoTentarNovamente: provedor.tentarNovamente,
            );
          }

          return RefreshIndicator(
            onRefresh: provedor.tentarNovamente,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header com busca
                SliverToBoxAdapter(
                  child: _buildHeader(provedor),
                ),

                // Lista de personagens
                if (provedor.itens.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ItemListaPersonagem(
                            personagem: provedor.itens[index],
                          ),
                        );
                      },
                      childCount: provedor.itens.length,
                    ),
                  )
                else if (!provedor.carregando)
                  SliverToBoxAdapter(
                    child: _buildEmptyState(),
                  ),

                // Loading mais itens
                if (provedor.carregandoMais)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),

                // Espaço final
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(PersonagensProvedor provedor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e contador
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personagens',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface, 
                ),
              ),
              if (provedor.itens.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${provedor.itens.length}+',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Campo de busca
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withAlpha(30),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _buscaController,
              onChanged: _onBuscaChanged,
              decoration: InputDecoration(
                hintText: 'Buscar personagens...',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                suffixIcon: _buscaController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () {
                          _buscaController.clear();
                          Provider.of<PersonagensProvedor>(context, listen: false).buscar('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Status da busca
          if (provedor.carregando)
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Buscando...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Carregando personagens...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Nenhum personagem encontrado',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar com outros termos',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _abrirDialogoBusca() {
    final buscaController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Buscar Personagens',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: buscaController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Digite o nome do personagem',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onSubmitted: (v) {
                  Provider.of<PersonagensProvedor>(context, listen: false).buscar(v);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Provider.of<PersonagensProvedor>(context, listen: false).buscar(buscaController.text);
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Buscar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
