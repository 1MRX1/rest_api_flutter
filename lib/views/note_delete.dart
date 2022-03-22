import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  const NoteDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Осторожно"),
      content: Text("Вы действительно хотите удалить?"),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
        },
            child:Text("Да")),
        TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child:Text("Нет")),
      ],
    );
  }
}
