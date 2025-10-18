class Personagem {
  final int id;
  final String nome;
  final String descricao;
  final String imagemUrl;

  Personagem({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imagemUrl,
  });

  factory Personagem.fromJson(Map<String, dynamic> json) {
    return Personagem(
      id: json['id'] ?? 0,
      nome: json['name'] ?? '',
      descricao: json['description'] ?? '',
      imagemUrl: json['img'] ?? '',
    );
  }
}
