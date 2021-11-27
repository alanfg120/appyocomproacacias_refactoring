class Categoria {
  
  final int id;
  final String nombre;

  Categoria({required this.id,required this.nombre});

  factory Categoria.toJson(Map<String, dynamic> json) => Categoria(
        id: json['id'],
        nombre: json['nombre'],
  );
      
}
