import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";
import 'package:shared_preferences/shared_preferences.dart';


void dialogNewFile(BuildContext ctx,String type, String? err) {
  TextEditingController tec = TextEditingController();
  showDialog(context: ctx, builder: (context)=>AlertDialog(
    actions: [
      TextButton(onPressed: ()=>{

      }, child: const Text("Close")),
      TextButton(onPressed: ()=>{
        newFile(ctx, type,tec.text)
      }, child: const Text("New"))
    ],
    content: TextField(
      controller: tec,
    ),
  ));
}

void newFile(BuildContext ctx,String type,String name)async {
  // GET Folder path
  
  //Scan file in folder
  // check if in this folder is there a file called name.type.[ext]
  // if true return to dialogNewFile(ctx,type, "Il file già esiste")
  // if false create new file called name.type.[ext]
  
}

Future<Widget> getFileinFolder() async {
  SharedPreferences sh = await SharedPreferences.getInstance();
  String? st = sh.getString("path");
  //Get dir from st (path)
  Directory dir;
  if (st!=null) {
    dir = Directory(st);
  } else {
    dir = await getApplicationDocumentsDirectory();
  }
  if (!await dir.exists()) {
    await sh.remove("path");
    return const Text("error"); // Error Text with button to change folder
  } 
  // Get files
  List<DataRow> files = [];
  List<FileSystemEntity> li = dir.listSync();
  DateFormat df = DateFormat("dd/MM/yyyy");
  TextStyle nameStyle = TextStyle();
  TextStyle infoStyle = TextStyle();
  for (FileSystemEntity fse in li) {
    if (await fse.exists()) {
      String fp = fse.path.split("/").last;
      String fname = fp.split(".").first;
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
    DataColumn(label: Text("Type")),
    DataColumn(label: Text("Data")),
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