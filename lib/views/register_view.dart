import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
import 'package:mynotes/views/constants/routes.dart';
import 'dart:developer'as devtools show log;
import '../firebase_options.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
 late final TextEditingController _email;
late final TextEditingController _password;

@override
  void initState() {
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
 
 @override
  Widget build(BuildContext context) {
  return  Scaffold(
    appBar: AppBar(title: const Text('Register')),
    body: Column(
            children: [
              TextField(controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),),
              TextField(controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: 'Password'),),
              TextButton(onPressed: () async {
                final email =_email.text;
                final password=_password.text;
        try{ final userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email , password: password);
               devtools.log(userCredential.toString());
  
        }on FirebaseAuthException catch(e){
          if(e.code=='weak-password'){
            await showErrorDialog(context,'Your Password is Weak');
          }
          else if (e.code=='email-already-in-use'){
           await showErrorDialog(context, 'Email is Already taken by User!');
          }
          else if(e.code=='invalid-email'){
            devtools.log('invalid email entered!');
            await showErrorDialog(context,'Please Enter Valid Email');
          }
          else{
            await showErrorDialog(context, 'Something Went Wrong!');
          }
        }
  
              
               }
              , child: const Text('Register'),),
              TextButton(onPressed: () { 
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,
              (route)=>false,);
              }, child: const Text('Already Registered? Login here!')),
            ],
          ),
  );

  }
}
