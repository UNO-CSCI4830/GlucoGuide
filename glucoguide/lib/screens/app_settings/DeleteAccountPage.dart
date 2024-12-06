import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glucoguide/screens/login/login_page.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _status = ''; // Status message to display registration result

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Account Deletion')),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please enter your password to delete your account"),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    _confirmAccountDeletion(context);
                  },
                  child: const Text('Delete Account')),
              const SizedBox(height: 20),
              Text(_status),
            ],
          ),
        ));
  }

  void _confirmAccountDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Warning: Deleting your account permanently'
              'deletes your information. This action cannot'
              'be undone. Select Yes to delete your account.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteAccount();
                const Text('Button yes');
                Navigator.of(context).pop();
                _passwordController.clear();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final User? user = _auth.currentUser;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      db.collection("users").doc(user!.uid).delete().then(
            (doc) => print("Doc deleted"),
            onError: (e) => print("Error deleting document"),
          );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      print('Error deleting account');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error deleting account'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
