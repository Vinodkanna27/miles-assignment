class Course {
  final String id;
  final String title;
  final String description;

  Course({required this.id, required this.title, required this.description});

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
  };

  factory Course.fromMap(String id, Map<String, dynamic> data) => Course(
    id: id,
    title: data['title'] ?? '',
    description: data['description'] ?? '',
  );
}

