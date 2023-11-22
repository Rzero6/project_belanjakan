import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ConvertImageString {
  static Future<File> strToImg(String encodedStr) async {
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.jpg");
    return await file.writeAsBytes(bytes);
  }

  static Future<String> imgToStr(File img) async {
    Uint8List bytes = await img.readAsBytes();
    return base64Encode(bytes);
  }
}
