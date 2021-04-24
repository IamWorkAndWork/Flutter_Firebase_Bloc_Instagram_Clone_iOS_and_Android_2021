import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const String routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    Scaffold(
                      appBar: AppBar(
                        title: Text("Hello"),
                      ),
                    ),
              ),
            );
          },
          child: Text("Feed"),
        ),
      ),
    );
  }
}
