import 'dart:convert';
import 'package:bytebank/http/webclient.dart';
import 'package:http/http.dart';
import '../../models/transaction.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(Uri.parse(myUrl)).timeout(const Duration(seconds: 15));
    final List<dynamic> decodeJson = jsonDecode(response.body);
    return decodeJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(Uri.parse(myUrl),
        headers: {
          'Content-type': 'application/json',
          'password': '1000',
        },
        body: transactionJson);

    return Transaction.fromJson(jsonDecode(response.body));
  }
  // List<Transaction> _toTransactions(Response response) {
  //   final List<dynamic> decodeJson = jsonDecode(
  //       response.body); //decodificou o json para criar uma lista de transação
  //   //mesma coisa do de cima
  //   // final List<Transaction> transactions = []; //cria lista vazia
  //   // for (Map<String, dynamic> transactionJson in decodeJson) {
  //   //   //percorre a lista e tras os elementos
  //   //   transactions.add(Transaction.fromJson(transactionJson));
  //   // }
  //   //mesma coisa do de baixo
  //   return decodeJson
  //       .map((dynamic json) => Transaction.fromJson(json))
  //       .toList();
  // }
}
