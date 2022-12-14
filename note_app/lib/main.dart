import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/page/notes_page.dart';
import 'package:note_app/screens/wrapper.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Notes SQLite';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            primaryColor: Colors.white10, scaffoldBackgroundColor: Colors.grey),
        //home: NotesPage(),
        home: Wrapper(),
      );
}
