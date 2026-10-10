class Incident {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String status;
  final String category;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.category,
  });
}
