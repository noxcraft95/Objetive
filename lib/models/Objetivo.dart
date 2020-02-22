import 'package:flutter/material.dart';

class Objetivo {
  String id;
  String titulo;
  String descripcion;
  String planAccion;
  String fechaCreado;
  String fechaRealizar;
  String realizado;

  Objetivo({this.titulo, this.descripcion, this.planAccion, this.fechaCreado,
    this.fechaRealizar, this.realizado});
}
