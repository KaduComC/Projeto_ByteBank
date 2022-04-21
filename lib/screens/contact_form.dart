import 'package:flutter/material.dart';
import '../database/dao/contact_DAO.dart';
import '../models/contact.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final ContactDAO _dao = ContactDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full name'),
              style: const TextStyle(fontSize: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _accountController,
                decoration: const InputDecoration(labelText: 'Account number'),
                style: const TextStyle(fontSize: 20.0),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: SizedBox(
                  width: 150.0,
                  height: 60.0,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final String name = _nameController.text;
                      final int? account =
                          int.tryParse(_accountController.text);
                      final Contact newContact = Contact(0, name, account!);
                      _dao.save(newContact).then((id) => Navigator.pop(context));
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 32.0,
                    ),
                    label:
                        const Text('Create', style: TextStyle(fontSize: 16.0)),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        primary: Theme.of(context).primaryColor),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
