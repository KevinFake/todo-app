class Todo {
  int id;
  DateTime time;
  String title;
  String content;
  String images;

  Todo(
      {this.id = 0,
      required this.time,
      this.title = "",
      this.content = "",
      this.images = ""});
}
