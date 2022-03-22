import 'dart:convert';
import 'package:rest_api_app/models/api_response.dart';
import 'package:rest_api_app/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import '../models/note.dart';
import '../models/note_manipulation.dart';

class NoteService {
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  static const headers = {
    'apiKey': '88112d30-72e2-4966-8750-1b68262b39ae',
    'Content-Type': 'application/json'
  };

  Future<APIResponse<List<NoteForListing>>> getNotesList(){
    final notes = <NoteForListing>[];
    return http.get(Uri.parse(API+'/notes'), headers:headers).then((data) {

      if(data.statusCode == 200){
        final jsonData = json.decode(data.body);
        for(var item in jsonData){
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(
          data: notes,
          errorMessage: ""
        );
      }

      return APIResponse<List<NoteForListing>>(
          data: null,
          error: true,
          errorMessage: "Ошибка"
      );
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        data: null,
        error: true,
        errorMessage: "Ошибка"
    ));
  }

  Future<APIResponse<Note>> getNote(String noteID){
    return http.get(Uri.parse(API+'/notes/' + noteID), headers:headers).then((data) {
      if(data.statusCode == 200){
        final jsonData = json.decode(data.body);
        final note = Note.fromJson(jsonData);

        return APIResponse<Note>(
            data: note,
            errorMessage: ""
        );
      }

      return APIResponse<Note>(
          data: null,
          error: true,
          errorMessage: "Ошибка"
      );
    }).catchError((_) => APIResponse<Note>(
        data: null,
        error: true,
        errorMessage: "Ошибка"
    ));
  }

  Future<APIResponse<bool>> createNote(NoteManipulation item){
    return http.post(Uri.parse(API+'/notes'), headers:headers, body: json.encode(item.toJson())).then((data) {
      if(data.statusCode == 201){

        return APIResponse<bool>(
            data: true,
            errorMessage: ""
        );
      }

      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage: "Ошибка"
      );
    }).catchError((_) => APIResponse<bool>(
        data: false,
        error: true,
        errorMessage: "Ошибка"
    ));
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteManipulation item){

    return http.put(Uri.parse(API+'/notes/' + noteID), headers:headers, body: json.encode(item.toJson())).then((data) {
      if(data.statusCode == 204){
        return APIResponse<bool>(
            data: true,
            errorMessage: ""
        );
      }

      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage: "Ошибка"
      );
    }).catchError((_) => APIResponse<bool>(
        data: false,
        error: true,
        errorMessage: "Ошибка"
    ));
  }

  Future<APIResponse<bool>> deleteNote(String noteID){

    return http.delete(Uri.parse(API+'/notes/'+ noteID), headers:headers).then((data) {
      if(data.statusCode == 204){
        return APIResponse<bool>(
            data: true,
            errorMessage: ""
        );
      }

      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage: "Ошибка"
      );
    }).catchError((_) => APIResponse<bool>(
        data: false,
        error: true,
        errorMessage: "Ошибка"
    ));
  }
}