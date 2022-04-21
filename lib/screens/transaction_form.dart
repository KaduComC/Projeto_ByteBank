import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm(this.contact, {Key? key}) : super(key: key);

  @override
  TransactionFormState createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('New transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.contact.name,
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                widget.contact.accountNumber.toString(),
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _valueController,
                style: const TextStyle(fontSize: 24.0),
                decoration: const InputDecoration(labelText: 'Value'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton.icon(

                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(value!, widget.contact);
                      _webClient.save(transactionCreated).then((transaction) {
                        Navigator.pop(context);
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 32.0,
                    ),
                    label: const Text('Transfer',
                        style: TextStyle(fontSize: 16.0)),
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
