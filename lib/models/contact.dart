class Contact {
  final int id;
  final String name;
  final int accountNumber;

  Contact(
      this.id,
      this.name,
      this.accountNumber,);

  String groupData() => 'Name: $name\nAccount: $accountNumber';

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        accountNumber = json['accountNumber'];

  Map<String, dynamic> toJson() => {
    'name' : name,
    'accountNumber' : accountNumber,
  };
}
