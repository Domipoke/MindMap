import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map/Routes/EditView/EditViewDoc.dart';
import 'package:map/Routes/EditView/EditViewMap.dart';
import 'package:map/Routes/EditView/EditViewTimeline.dart';

void toEditViewMap(BuildContext bc, File f) {
  Navigator.of(bc).push(MaterialPageRoute(builder: (c)=>EditViewMap(file: f)));
}
void toEditViewTimeline(BuildContext bc, File f) {
  Navigator.of(bc).push(MaterialPageRoute(builder: (c)=>EditViewTimeline(file: f)));
}
void toEditViewDoc(BuildContext bc, File f) {
  Navigator.of(bc).push(MaterialPageRoute(builder: (c)=>EditViewDoc(file: f)));
}