import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition _puntInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
      tilt: 50,
    );
    Set<Marker> markers = new Set<Marker>();
    markers
        .add(new Marker(markerId: MarkerId('id1'), position: scan.getLatLng()));
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        mapToolbarEnabled: true,
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
