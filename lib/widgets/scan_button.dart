import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

class ScanButton extends StatelessWidget {
  // No hace falta el parámetro onMapTypeChange aquí, solo para escanear.
  final MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    return FloatingActionButton(
      elevation: 0,
      child: Icon(Icons.filter_center_focus), // Icono de escanear
      onPressed: () async {
        // Abre un diálogo para escanear el código QR
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (BarcodeCapture capture) {
                        final barcode = capture.barcodes.first;
                        if (barcode.rawValue != null) {
                          final String code = barcode.rawValue!;
                          print("Código QR: $code");
                          ScanModel nouScan = ScanModel(valor: code);

                          // Agrega el escaneo al provider
                          scanListProvider.nouScan(code);

                          Navigator.pop(context); // Cierra el diálogo
                          launchURL(context, nouScan); // Lanza la URL
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No se pudo leer el QR.')),
                          );
                        }
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () =>
                            Navigator.pop(context), // Cierra el diálogo
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
