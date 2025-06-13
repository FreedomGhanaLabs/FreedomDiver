import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<BitmapDescriptor> createCustomMarker({
  required String fallbackAssetPath,
  String? networkImageUrl,
  int width = 100,
}) async {
  Uint8List? imageBytes;

  try {
    if (networkImageUrl != null && networkImageUrl.isNotEmpty) {
      final file = await _getCachedFile(networkImageUrl);

      if (await file.exists()) {
        imageBytes = await file.readAsBytes();
      } else {
        final dio = Dio();
        final response = await dio.get<List<int>>(
          networkImageUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.statusCode == 200 && response.data != null) {
          imageBytes = Uint8List.fromList(response.data!);
          await file.writeAsBytes(imageBytes);
        }
      }

      if (imageBytes != null) {
        return await _bytesToBitmapDescriptor(imageBytes, width);
      }
    }
  } catch (e) {
    debugPrint('Error loading or caching network image: $e');
  }

  // Fallback to asset
  final byteData = await rootBundle.load(fallbackAssetPath);
  return await _bytesToBitmapDescriptor(byteData.buffer.asUint8List(), width);
}

Future<File> _getCachedFile(String url) async {
  final dir = await getTemporaryDirectory();
  final filename = md5.convert(utf8.encode(url)).toString();
  return File('${dir.path}/$filename.png');
}

Future<BitmapDescriptor> _bytesToBitmapDescriptor(
  Uint8List bytes,
  int width,
) async {
  final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
  final frame = await codec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}
