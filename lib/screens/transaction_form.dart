import 'dart:async';

import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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
  final String transactionId = const Uuid().v4();

  bool _sending = false;

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
            Visibility(
              visible: _sending,
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Progress('Sending...'),
              ),
            ),
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
                      final transactionCreated = Transaction(
                        transactionId,
                        value!,
                        widget.contact,
                      );
                      //showDialog mostra o popup
                      showDialog(
                          context: context,
                          builder: (contextDialog) => TransactionAuthDialog(
                                onConfirm: (password) {
                                  _save(transactionCreated, password, context);
                                },
                              ));
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

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction transaction = await _send(
      transactionCreated,
      password,
      context,
    );
    _showSuccessfulTransaction(transaction, context);
  }

  Future _showSuccessfulTransaction(
      Transaction transaction, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (contextDialog) {
          return const SuccessDialog('Successful transaction');
        });
    Navigator.pop(context);
  }

  Future<Transaction> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    final Transaction transaction =
        await _webClient.save(transactionCreated, password).catchError((error) {
      //vai procurar um erro e retornar uma mensagem
      _showFailureMessage(context, message: error.message);
      //faz uma verifica????o booleana para ver se corresponde ao catherror
    }, test: (error) => error is TimeoutException).catchError((error) {
      _showFailureMessage(context);
    }, test: (error) => error is HttpException).catchError((error) {
      _showFailureMessage(context,
          message: 'Timeout submitting the transaction');
    }).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
    return transaction;
  }

  void _showFailureMessage(
    BuildContext context, {
    String message = 'Unknown error',
  }) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
          //captura um erro totalmente inesperado
          //esse tipo de erro tem que ficar no final para n??o dar interferencia nos outros
        });
  }
}
