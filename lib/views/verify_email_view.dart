import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Verify Email')),
      body: Column(children: [
        const Text("We've Sent you an email Verification.Please open it to verify your account "),
               const Text("If you haven't recieved a verification email yet , press the button below "),
               TextButton(onPressed: () async{
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
               }, child: const Text('Send email Verification'),
               )
               ,
               TextButton(onPressed: ()async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);
               }, child: const Text('Restart'),)
              
              ],
              ),
    );
       }
}