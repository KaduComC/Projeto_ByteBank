// ignore_for_file: avoid_print
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

final Client client =
    InterceptedClient.build(interceptors: [LoggingInterceptor()]);
//forma de pegar dados da webapi

const String myUrl = "http://192.168.0.42:8080/transactions";


