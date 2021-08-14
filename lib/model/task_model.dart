class Task {
  final int? id;
  final String task;
  final String date;

  Task({this.id, required this.task, required this.date});

  // create a function that turns our data to map for easy insertion into db
  Map<String, dynamic> toMap() {
    return ({"id": id, "task": task, "date": date});
  }
}
