import 'dart:io';
import 'package:xml/xml.dart';

class MapFile {
  File file;
  XmlDocument builder = XmlDocument();
  MapFile({required this.file}) {
    builder = XmlDocument.parse(file.readAsStringSync());
  }

  
} 