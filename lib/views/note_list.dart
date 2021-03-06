import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api_app/models/api_response.dart';
import 'package:rest_api_app/models/note_for_listing.dart';
import 'package:rest_api_app/services/notes_service.dart';
import 'package:rest_api_app/views/note_delete.dart';
import 'package:rest_api_app/views/note_modify.dart';

class NoteList extends StatefulWidget {

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.I<NoteService>();
  late APIResponse<List<NoteForListing>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }


  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }
  _fetchNotes() async{
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Список")),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteModify(noteID: ''))).then((_) {
            _fetchNotes();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error == true){
            return Center(child: Text(_apiResponse.errorMessage),);
          }

          return ListView.separated(
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.green,thickness: 1),
            itemBuilder: (_, index){
              return Dismissible(
                  key: ValueKey(_apiResponse.data![index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction){

                  },
                  confirmDismiss: (direction) async{
                    final result = await showDialog(context: context, builder: (_) => NoteDelete());
                    var message;
                    if(result){
                      final deleteResult = await service.deleteNote(_apiResponse.data![index].noteID);
                      if(deleteResult.data == true){
                        message = 'Примечание удалено успешно';
                      }
                      else message = 'Произошла ошибка';

                      showDialog(context: context, builder: (_) => AlertDialog(
                        title: Text('Готово'),
                        content: Text(message),
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
                      return deleteResult.data;
                    }

                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(child: Icon(Icons.delete, color: Colors.white,), alignment: Alignment.centerLeft,),
                  ),
                  child: ListTile(
                    title: Text(
                        _apiResponse.data![index].noteTitle,
                        style: TextStyle(color: Theme.of(context).primaryColor)),
                    subtitle: Text("Дата создания ${formatDateTime(_apiResponse.data![index].latestEditDateTime ??
                        _apiResponse.data![index].createDateTime)}"),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteModify(
                          noteID: _apiResponse.data![index].noteID))).then((data) {
                            _fetchNotes();
                      });
                    },
                  )
              );
            },
            itemCount: _apiResponse.data!.length,
          );
        },
      )
    );
  }
}
