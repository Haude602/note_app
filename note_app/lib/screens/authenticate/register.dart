import 'package:note_app/shared/loading.dart';
import 'package:flutter/material.dart';
import "package:note_app/services/auth.dart";
import "package:note_app/shared/constants.dart";
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<
      FormState>(); // for validatin input fields and make user input id and pasword
  final AuthService _auth = AuthService();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color.fromARGB(62, 255, 189, 57),
            appBar: AppBar(
              elevation: 5.0, //shadow of appbar
              title: Text(
                'Note App',
                style: GoogleFonts.montserratAlternates(
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Color.fromARGB(255, 255, 189, 57),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  }, //this will help to go to another page when clicked
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                )
              ],
              titleSpacing: 00.0,
              centerTitle: true,
              toolbarHeight: 50.2,
              toolbarOpacity: 0.8,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
                child: Form(
                    key: _formKey, // validating form with formkey
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              // .copywith() is used to include hintText of inside decoration as it cant be constant in constants.dart
                              hintText:
                                  'Email'), // textInputDecoration is set of lines of code defined as constant in constants.dart for ease

                          validator: (val) => val!.isEmpty
                              ? 'Enter an email'
                              : null, // return null if true and string if empty

                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          obscureText:
                              true, //obscure means hidden text as asterics
                          validator: (val) => val!.length < 6
                              ? 'Enter a 6+ char long Passwrod'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            color: Color.fromARGB(255, 255, 189, 57),
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'Please supply a valid mail';
                                    loading = false;
                                  });
                                }
                              }
                            }),
                        SizedBox(
                            height:
                                12.0), // for showing error in register screen when something wents wrong
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ))),
          );
  }
}
