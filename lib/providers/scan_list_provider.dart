import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:qr_scan/providers/db_provider.dart';

//Intermediario entre la base de datos y los widgets
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tiposSeleccionados = 'http';

  // Agregar un nuevo scan
  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DbProvider.db.insertScan(nouScan);
    nouScan.id = id;
    // Solo agregar a la lista si el tipo coincide
    if (nouScan.tipos == tiposSeleccionados) {
      this.scans.add(nouScan);
      notifyListeners();
    }
    return nouScan;
  }

// Cargar todos los scans
  carregaScans() async {
    final scanscarga = await DbProvider.db.getAllScans();
    scans = scanscarga;
    notifyListeners();
  }

  carregaScansTipos(String tipos) async {
    final scanst = await DbProvider.db.getScanPerTipos(tipos);
    print("Scans obtenidos de la BD: $scans");
    scans = scanst;
    this.tiposSeleccionados = tipos;
    notifyListeners();
  }

  // Eliminar todos los scans
  esborraTots() async {
    await DbProvider.db
        .deleteAllScans(); // Espera que se eliminen todos los registros
    this.scans = []; // Limpia la lista de scans
    notifyListeners(); // Notifica a los widgets que la lista ha cambiado
  }

  // Eliminar un scan por su ID
  esborraPerId(int id) async {
    await DbProvider.db.deleteId(id); // Llama a la función de eliminar por ID
    this.scans.removeWhere(
        (scan) => scan.id == id); // Elimina el scan de la lista en memoria
    notifyListeners(); // Notifica a los widgets que la lista ha cambiado
  }
}
