import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class ScanModel {
  ScanModel({
    this.id,
    this.tipos,
    required this.valor,
  }) {
    if (this.valor.contains('http')) {
      this.valor = 'http';
    } else {
      this.tipos = 'geo';
    }
  }
  int? id;
  String? tipos;
  String valor;

  LatLng getLatLng() {
    final latLng = this.valor.substring(4).split(',');
    final latitude = double.parse(latLng[0]);
    final longitude = double.parse(latLng[1]);
    return LatLng(latitude, longitude);
  }

  factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipos: json["tipos"],
        valor:
            json["tipos"] ?? 'geo', // Asigna un valor predeterminado si es null
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tipos": tipos,
        "valor": valor,
      };
}
