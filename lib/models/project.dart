class Project {
  String id;
  String category;
  String title;
  String description;
  DateTime time;
  int completed;

  Project(
      {this.id,
      this.category,
      this.title,
      this.description,
      this.time,
      this.completed});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}
