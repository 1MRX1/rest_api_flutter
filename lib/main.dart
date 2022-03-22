import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api_app/services/notes_service.dart';
import 'package:rest_api_app/views/note_list.dart';

void setupLocator(){
  GetIt.I.registerLazySingleton(() => NoteService());
}

void main() {
  setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
