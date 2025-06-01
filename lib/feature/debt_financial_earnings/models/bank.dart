class Bank {
  final String name;
  final String code;
  final int id;

  Bank({required this.name, required this.code,  required this.id});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(name: json['name'], code: json['code'], id: json['id']);
  }
}
