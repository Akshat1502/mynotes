import 'dart:developer'as devtools show log;


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
import 'package:mynotes/views/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView ({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(appBar: AppBar(title: const Text('Login')),
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
                try{final userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email , 
                password: password,);
               devtools.log(userCredential.toString());
               final user = FirebaseAuth.instance.currentUser;
               if(user?.emailVerified ?? false){
                //User is verified and can now move to notes view
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false,);
               }
               else{
                //user isnt verified yet move to verify email view!
                  Navigator.of(context).pushNamedAndRemoveUntil(verifyemailroute, (route) => false,);
               }
             
                     
                     }on FirebaseAuthException catch (e){
                      if (e.code =='user-not-found'){
                        await showErrorDialog(context, 'User not Found');
                      devtools.log('User Not Found!');

                      
                      
                      }
                      else if(e.code == 'wrong-password') {
                       await showErrorDialog(context,'Wrong Password');
                      }
                      else{
                       await showErrorDialog(context,'Error: ${e.code}');
                      }
    
    
                     }
                     catch(e){
                    await showErrorDialog(context, e.toString(),);

                     }
    
            
               }
              , child: const Text('Login'),
              ),
              TextButton(onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute,
                (route)=>false,
                );
              }, child: const Text('Not Registered yet? Register Here!')
              ),
            
            ],
          ),
    );

  }

  
}