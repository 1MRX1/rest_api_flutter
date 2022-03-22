class NoteForListing{
  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime? latestEditDateTime;

  NoteForListing({
    required this.noteID,
    required this.noteTitle,
    required this.createDateTime,
    this.latestEditDateTime = null});

  factory NoteForListing.fromJson(Map<String, dynamic> item){
    return NoteForListing(
        noteID: item['noteID'],
        noteTitle: item['noteTitle'],
        createDateTime: DateTime.parse(item['createDateTime']),
        latestEditDateTime: DateTime.parse(item['createDateTime']));
  }
}