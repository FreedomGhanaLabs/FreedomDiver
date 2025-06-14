import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<BitmapDescriptor> createCustomMarker({
  required String fallbackAssetPath,
  String? networkImageUrl,
  int size = 40, // smaller size
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
        return await _roundedBytesToBitmapDescriptor(imageBytes, size);
      }
    }
  } catch (e) {
    debugPrint('Error loading or caching network image: $e');
  }

  // Fallback to asset
  final byteData = await rootBundle.load(fallbackAssetPath);
  return await _roundedBytesToBitmapDescriptor(
    byteData.buffer.asUint8List(),
    size,
  );
}

Future<File> _getCachedFile(String url) async {
  final dir = await getTemporaryDirectory();
  final filename = md5.convert(utf8.encode(url)).toString();
  return File('${dir.path}/$filename.png');
}

Future<BitmapDescriptor> _roundedBytesToBitmapDescriptor(
  Uint8List bytes,
  int size,
) async {
  final codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: size,
    targetHeight: size,
  );
  final frame = await codec.getNextFrame();
  final image = frame.image;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final paint = Paint();
  final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
  final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size / 2));

  canvas.clipRRect(rrect);
  paint.isAntiAlias = true;
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    rect,
    paint,
  );

  final roundedImage = await recorder.endRecording().toImage(size, size);
  final data = await roundedImage.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}
