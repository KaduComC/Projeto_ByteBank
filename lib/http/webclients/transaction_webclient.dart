import 'dart:async';
import 'dart:convert';
import 'package:bytebank/http/webclient.dart';
import 'package:http/http.dart';
import '../../models/transaction.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(Uri.parse(myUrl));
    final List<dynamic> decodeJson = jsonDecode(response.body);
    return decodeJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    await Future.delayed(const Duration(seconds: 5));

    final Response response = await client.post(Uri.parse(myUrl),
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
    // _throwHttpError(response.statusCode);
    // return Transaction.fromJson(jsonDecode(response.body));
  }

  String? _getMessage(int statusCode) {
    if(_statusCodeResponse.containsKey(statusCode)) {
      return _statusCodeResponse[statusCode];
    }
    return 'Unknown error';
  }

  // void _throwHttpError(int statusCode) =>
  //     throw Exception();

  //mapa que pega o valor do erro e direciona o sentido do erro
  static final Map<int, String?> _statusCodeResponse = {
    400: 'There was an error submitting transaction',
    401: 'Authentication failed',
    404: 'Page not founded',
    409: 'Transaction always exists'
  };
}

class HttpException implements Exception {
  final String? message;

  HttpException(this.message);
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
