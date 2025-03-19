import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;
  if (scan.tipos == 'http') {
    if (!await launch(url)) throw 'Could nott launch $url';
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
