import 'package:dx_qasim_task/models/list_argument.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  static const routeName = '/listArguments';

  @override
  Widget build(BuildContext context) {
    final ListArguments items = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BEEDYO', //appbar title
          style: TextStyle(
            color: Colors.red,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
      
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              items.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              width: 8,
            ),
            Image.network(items.url),
          ],
        ),
      ),
    );
  }
}
