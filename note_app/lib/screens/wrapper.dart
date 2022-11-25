import 'package:note_app/page/notes_page.dart';
import 'package:note_app/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:note_app/model/user.dart';

class Wrapper extends StatelessWidget {
  //const ({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //returns either home or authenticate widget

    final user =
        Provider.of<Users?>(context); //accessing users data whenever added
    if (user == null) {
      return Authenticate();
    } else {
      return NotesPage();
    }

    //if (user == null) {
    //return Authenticate();
    //} else {
    //  return Home();
    //}
  }
}
