import 'package:edmonscan/app/data/local/my_shared_pref.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Terms of Use'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Add your terms and conditions here.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('I Agree'),
          onPressed: () {
            Navigator.of(context).pop(true);
            MySharedPref.setTerms(true);
          },
        ),
      ],
    );
  }
}
