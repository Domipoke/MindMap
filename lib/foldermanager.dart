import 'dart:io';
import 'package:map/navigation.dart';
import 'package:path/path.dart' show join;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

const String ext = "mindmap";

enum FileType {
  none,
  map,
  timeline,
  doc,
}
String getStringType(FileType t) {
  switch(t) {
    case FileType.map: return "map";
    case FileType.timeline: return "timeline";
    case FileType.doc: return "doc";
    default:
      return "none";
  }
}
RegExp invalidFName = RegExp(r"[^a-zA-Z0-9- ]");
void dialogNewFile(BuildContext ctx,FileType type, {String? err,bool tobeopen = true}) {
  TextEditingController tec = TextEditingController();
  GlobalKey<FormState> fnformKey =  GlobalKey<FormState>();
  showDialog(context: ctx, builder: (context)=>AlertDialog(
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: const Text("Close")),
      TextButton(onPressed: (){
        if (fnformKey.currentState!.validate()) {
          newFile(ctx, type,tec.text.trim().replaceAll(" ", "_"),tobeopen: tobeopen);
          Navigator.of(context).pop();
        }
      }, child: const Text("New"))
    ],
    content: Form(
      key: fnformKey,
      child: TextFormField(
        controller: tec,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Il campo non può essere vuoto';
          }
          if (invalidFName.hasMatch(value)) {
            return 'Caratteri non validi. Puoi usare solo lettere, numeri, spazi vuoti e trattini';
          }
          return null;
        },
        
      ),
    ),
  ));
}

void newFile(BuildContext ctx,FileType type,String name, {bool tobeopen = true})async {
  // GET Folder path
  Directory dir = await getDir();
  //Scan file in folder
  File f = File("${dir.path}/$name.${getStringType(type)}.$ext");
  // check if in this folder is there a file called name.type.[ext]
  if (f.existsSync()) {
    // error // No File was created
    // if true return to dialogNewFile(ctx,type, "Il file già esiste")
  } else {
    // if false create new file called name.type.[ext]
    await f.create(exclusive: true);
  }
  String s = await f.readAsString();
  if (s.isEmpty) {
    f.writeAsString("<MapFile></MapFile>");
  }
  if (tobeopen) {
    if (f.existsSync()) {
      switch (type) {
        case FileType.none:
          // TODO: Handle this case.
          break;
        case FileType.map:
          toEditViewMap(ctx, f);
          break;
        case FileType.timeline:
          toEditViewTimeline(ctx, f);

          break;
        case FileType.doc:
          toEditViewDoc(ctx, f);
          break;
      }
    }
  }  
  
}

Future<Widget> getFileinFolder() async {
  Directory dir = await getDir();
  // Get files
  List<DataRow> files = [];
  List<FileSystemEntity> li = dir.listSync();
  debugPrint(li.toString());
  //DateFormat df = DateFormat("dd/MM/yyyy");
  TextStyle nameStyle = TextStyle();
  TextStyle infoStyle = TextStyle();
  for (FileSystemEntity fse in li) {
    if (await fse.exists()) {
      String fp = fse.path.split("/").last;
      String fname = fp.split(".").first.replaceAll("_", " ");
      String ftype = fp.split(".")[1];
      DateTime dtmod = fse.statSync().modified;
      files.add(DataRow(cells: [
        DataCell(Text(fname, style: nameStyle)),
        DataCell(Text(lastOpened(dtmod), style: infoStyle)),
        DataCell(Text(ftype, style: infoStyle))
      ]));
    }
  }
  // Split by "." [name,type,ext]
  // for each file create a row that contains a Text: Name, 
  return DataTable(columns: const [
    DataColumn(label: Text("Name")),
    DataColumn(label: Text("Data")),
    DataColumn(label: Text("Type")),
  ], rows: files);
}

String lastOpened(DateTime from) {
  DateTime now = DateTime.now();
  Duration com = now.difference(from);
  
  if (com.inSeconds<60) {
    return "now";
  }
  if (com.inMinutes<10) {
    if (com.inMinutes==1) {
      return "1 minuto fa";
    } else {
      return "${com.inMinutes} minuti fa";
    }
  }
  if (com.inHours<24) {
    return "${com.inHours} minuti fa";
  }
  return DateFormat("dd/MM/yyyy").format(from);
}


Future<Directory> getDir() async{
  SharedPreferences sh = await SharedPreferences.getInstance();
  String? st = sh.getString("path");
  //Get dir from st (path)
  Directory dir;
  if (st!=null) {
    dir = Directory(st);
    if (dir.existsSync()) {
      return dir;
    } else {dir=await getApplicationDocumentsDirectory();}
  } else {dir=await getApplicationDocumentsDirectory();}
  Directory mdir=Directory("${dir.path}/maps"); 
  if (mdir.existsSync()) {
    return mdir;
  } else {
    mdir.createSync();
    return mdir;
  }
}

