class Author {
  final int? id;
  final String authorName;
  final String nationality;
  final int birthYear;
  final String? createdAt;
  final String? updatedAt;

  Author({
    this.id,
    required this.authorName,
    required this.nationality,
    required this.birthYear,
    this.createdAt,
    this.updatedAt,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      authorName: json['author_name'],
      nationality: json['nationality'],
      birthYear: json['birth_year'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author_name': authorName,
      'nationality': nationality,
      'birth_year': birthYear,
    };
  }
}