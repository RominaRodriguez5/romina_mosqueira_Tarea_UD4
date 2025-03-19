import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_scan/models/scan_models.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  Completer<GoogleMapController> _controller = Completer();
  MapType _tipoMapa = MapType.normal; // Tipo de mapa
  LatLng? _puntoSeleccionado; // Punto inicial del mapa

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    try {
      _puntoSeleccionado = scan.getLatLng();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Ubicación inválida')),
        );
        Navigator.pop(context);
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final CameraPosition _puntInicial = CameraPosition(
      target: _puntoSeleccionado!,
      zoom: 17,
      tilt: 50,
    );

    Set<Marker> markers = {
      Marker(
        markerId: MarkerId('id1'),
        position: _puntoSeleccionado!,
      )
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Solo un botón de regreso
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.center_focus_strong),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _puntoSeleccionado!, zoom: 17),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled:
                false, // Ocultamos el botón de ubicación por defecto
            myLocationEnabled: true, // Mostrar ubicación actual
            mapToolbarEnabled: true,
            mapType: _tipoMapa,
            markers: markers,
            initialCameraPosition: _puntInicial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mapa cargado correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          // Botón flotante para cambiar tipo de mapa
          Positioned(
            bottom: 20, // Ubicación del botón en la parte inferior
            left: 20, // Ubicación del botón más hacia la izquierda
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _tipoMapa = _tipoMapa == MapType.normal
                      ? MapType.hybrid
                      : MapType.normal;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_tipoMapa == MapType.normal
                        ? 'Mapa Normal activado'
                        : 'Mapa Híbrido activado'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Icon(Icons.map),
              backgroundColor: Colors.deepPurpleAccent, // Color del botón
            ),
          ),
        ],
      ),
    );
  }
}
