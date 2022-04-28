import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {
  const TransactionAuthDialog({Key? key, required this.onConfirm})
      : super(key: key);

  final Function(String password) onConfirm;

  @override
  State<TransactionAuthDialog> createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
      title: const Text('Authenticate'),
      content: TextField(
        controller: _passwordController,
        keyboardType: TextInputType.number,
        obscureText: true,
        obscuringCharacter: '*',
        //esconde o conteudo
        enableSuggestions: false,
        //desabilita sugestões,
        autocorrect: false,
        //não corrige
        maxLength: 4,
        style: const TextStyle(fontSize: 50, letterSpacing: 24),
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: '-----'),
        textAlign: TextAlign.start,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              heightFactor: 2,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    fixedSize: const Size.fromWidth(100),
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('Cancel', style: TextStyle(fontSize: 18.0)),
              ),
            ),
            Align(
              child: TextButton(
                onPressed: () {
                  widget.onConfirm(_passwordController.text);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    fixedSize: const Size.fromWidth(100), //tamanho dos botoes
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('Confirm', style: TextStyle(fontSize: 18.0)),
              ),
            ),
          ],
        )
      ],
    );
  }
}
