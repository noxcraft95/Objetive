class Objetivo  {

  final String nombre;
  final String comentario; //50 caracteres
  final String planAccion;
  final DateTime fechaCreacion;
  final DateTime fechaRealizar;
  final bool terminado; //rojo-verde


  Objetivo({this.nombre, this.comentario, this.planAccion, this.fechaCreacion, this.fechaRealizar,this.terminado});
}