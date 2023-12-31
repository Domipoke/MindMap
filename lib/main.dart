
import 'package:flutter/material.dart';
import 'package:map/Expandable.dart';
import 'package:map/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:map/foldermanager.dart' as FolderManager;
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Map',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        appBarTheme: const AppBarTheme(
          foregroundColor: Palette.orange,
          backgroundColor: Palette.whitesmoke//Color.fromARGB(255,  250, 249, 246),
        )
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Palette.black22,
        appBarTheme: const AppBarTheme(
          foregroundColor: Palette.orange,
          backgroundColor: Palette.black12
        ),
        dataTableTheme: const DataTableThemeData(
          headingTextStyle: TextStyle(
            color: Palette.orange,
          ),
          decoration: BoxDecoration(
            color: Color(0x1EFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(100/8))
          )
        )
      ),
      home: const MyHomePage(title: 'MAP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  
  Future<void> checkPerm() async {
    await [
      Permission.location,
      Permission.storage,
    ].request();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () {
            setState(() {});
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(future: checkPerm(), builder: (c, AsyncSnapshot s) {
        if (s.connectionState==ConnectionState.done) {
          return FutureBuilder(future: FolderManager.getFileinFolder(),builder: (ctx,sn) {
            if (sn.hasData) {
              return Padding(padding: const EdgeInsets.all(16), child: sn.data);
            }
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          });
        }
        return const Text("");
      },),
      floatingActionButton: ExpandableFab(distance: 75, children: [
        IconButton(
          onPressed: () {
            FolderManager.dialogNewFile(context, FolderManager.FileType.map);
          },
          icon: const Icon(Icons.rectangle_outlined),
        ),
        IconButton(
          onPressed: () {
            FolderManager.dialogNewFile(context, FolderManager.FileType.timeline);
          },
          icon: const Icon(Icons.arrow_forward),
        ),
        IconButton(
          onPressed: () {
            FolderManager.dialogNewFile(context, FolderManager.FileType.doc);
          },
          icon: const Icon(Icons.edit_document),
        ),
      ])
    );
  }
}
/**
 FutureBuilder(
        future: checkPath(context),
        builder: (ctx, snap){
          debugPrint(snap.data);
          if (!first_check_path) {
            if (snap.hasData) {
              if (snap.data==null) {
                if (!dialog_showed) {
                  showDialog(context: context, builder: (context)=>AlertDialog(
                    actions: [
                      TextButton(onPressed: ()=>{

                      }, child: const Text("Close")),
                      TextButton(onPressed: ()=>{
                        
                      }, child: const Text("New"))
                    ],
                    content: Row(children: [TextButton(onPressed: () async {
                      String result = await FilePicker.platform.getDirectoryPath()??(await getTemporaryDirectory()).path;
                      SharedPreferences sh =await SharedPreferences.getInstance();
                      if (await sh.setString("path",result)) {
                        first_check_path=true;
                      }
                    }, child: const Text("Seleziona una cartella"))])
                  ));
                  
                }
              }
            }
            return const Center(child: CircularProgressIndicator());
          }
          return FutureBuilder(future:FolderManager.getFileinFolder(),builder: (ctx,sn) {
            if (sn.hasData) {
              return Center(child:  sn.data);
            }
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          });
        },
      )
  
 */