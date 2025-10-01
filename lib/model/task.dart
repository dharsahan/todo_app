class Task {
  String title;
  bool isDone;

  Task({
    required this.title,
    this.isDone = false,
  });
  Map<String ,dynamic> toJson() =>{
    'title':title,
    'isDone':isDone
  };
  factory Task.fromJson(Map<String ,dynamic> Json)=>Task(
    title: Json['title'],
    isDone: Json['isDone']
  );
}