import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  var _email = TextEditingController();
  var _password = TextEditingController();
  var _display = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: _display),
                    TextFormField(controller: _email),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      validator: (String? value) {
                        if (value != _password.text) {
                          return "Password not match";
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _register(context);
                          }
                        },
                        child: const Text("Register")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: const Text("Login")),
                    TextButton(
                        onPressed: () {}, child: const Text("Forgot Password")),
                  ],
                ))));
  }

  void _register(BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);

      ScaffoldMessenger.of(context).clearSnackBars();
    } on FirebaseException catch (e) {
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Email used")));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("password too weak")));
      }
      return;
    }
    try {
      await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({"display_name": _display.text, "email": _email.text});
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Unknown Error")));
    }
  }

  void _login(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);

      ScaffoldMessenger.of(context).clearSnackBars();
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("no user found ")));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("email/password wrong")));
      }
      return;
    }
    try {
      await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({"display_name": _display.text, "email": _email.text});
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Unknown Error")));
    }
  }
}
