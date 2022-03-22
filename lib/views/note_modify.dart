import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api_app/models/note_manipulation.dart';
import 'package:rest_api_app/services/notes_service.dart';

import '../models/note.dart';

class NoteModify extends StatefulWidget {

  final String noteID;
  NoteModify({required this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get IsEditing => widget.noteID != '';

  NoteService get notesService => GetIt.I<NoteService>();

  String? errorMessage;
  late Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if(IsEditing) {
      setState(() {
        isLoading = true;
      });
      notesService.getNote(widget.noteID).then((response) {
        setState(() {
          isLoading = false;
        });
        if(response.error){
          errorMessage = response.errorMessage ?? 'Произошла ошибка';
        }
        note = response.data!;

        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(IsEditing ? 'Изменение элемента' : 'Создание элемента'),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:isLoading ? Center(child:CircularProgressIndicator()) : Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Название элемента",
              ),
            ),
            Container(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                  hintText: "Примечание"
              ),
            ),
            ElevatedButton(
              child: const Text("Принять"),
              onPressed: () async{
                  if(IsEditing){
                    setState(() {
                      isLoading = true;
                    });
                    final note = NoteManipulation(noteTitle: _titleController.text, noteContent: _contentController.text);
                    final result = await notesService.updateNote(widget.noteID, note);

                    setState(() {
                      isLoading = false;
                    });

                    const title = 'Готово';
                    final text = result.error ? (result.errorMessage) : "Примечание изменено";

                    showDialog(context: context, builder: (_) => AlertDialog(
                      title: Text(title),
                      content: Text(text),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ок'),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    )
                    );
                  }
                  else{
                    setState(() {
                      isLoading = true;
                    });
                    final note = NoteManipulation(noteTitle: _titleController.text, noteContent: _contentController.text);
                    final result = await notesService.createNote(note);

                    setState(() {
                      isLoading = false;
                    });

                    const title = 'Готово';
                    final text = result.error ? (result.errorMessage) : "Примечание создано";
                    
                    showDialog(context: context, builder: (_) => AlertDialog(
                      title: Text(title),
                      content: Text(text),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ок'),
                          onPressed: (){
                            Navigator.of(context).pop();
                            },
                        )
                      ],
                    )
                    );
                  }
              },
            ),
          ],
        ),
      )
    );
  }
}
