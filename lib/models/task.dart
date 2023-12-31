class Task {
  Task(this.title, this.dateTime);
  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']);
  String title;
  DateTime dateTime;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),
    };
  }
}
