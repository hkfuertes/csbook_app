import 'dart:async';
import 'package:http/http.dart' as http;

class Api{
  static const String BaseUrl = 'https://parroquias.csbook.es/';

  static Future<http.Response> get(String url){
    return http.get(BaseUrl + url);
  }
}