class Note{
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime? latestEditDateTime;

  Note({
    required this.noteID,
    required this.noteTitle,
    required this.noteContent,
    required this.createDateTime,
    this.latestEditDateTime = null});

  factory Note.fromJson(Map<String, dynamic> item){
    return Note(
        noteID: item['noteID'],
        noteTitle: item['noteTitle'],
        noteContent: item['noteContent'],
        createDateTime: DateTime.parse(item['createDateTime']),
        latestEditDateTime: DateTime.parse(item['createDateTime']));
  }
}