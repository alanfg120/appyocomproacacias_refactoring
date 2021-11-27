
class CategoriaProducto {
  final int id;
  final String nombre;
  final bool selecionada;

  CategoriaProducto(
    {required this.id,
     required this.nombre,
     required this.selecionada});

  factory CategoriaProducto.toJson(Map<String,dynamic> json) => CategoriaProducto(
      id          : json['id'] ?? 0,
      nombre      : json['nombre'] ?? '',
      selecionada : false
  );

  CategoriaProducto copyWith({
    int? id,
    String? nombre,
    bool? selecionada
  }) => CategoriaProducto(
        id          : id          ?? this.id,
        nombre      : nombre      ?? this.nombre,
        selecionada : selecionada ?? this.selecionada
        );
  

}