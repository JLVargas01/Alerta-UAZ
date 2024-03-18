
class ContactoConfianza {
  final int? id;
  final String telephone;
  final String name;

  const ContactoConfianza({
    this.id,
    required this.telephone,
    required this.name
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'telephone': telephone,
      'name': name,
    };
  }

  @override
  String toString() {
    return '{id: $id, name: $name, telephone: $telephone}';
  }

}
