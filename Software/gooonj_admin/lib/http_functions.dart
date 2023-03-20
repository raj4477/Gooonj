import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> httpFunPost(String route, Map<String, dynamic> body) async {
  var url = Uri.https('gooonj.cyclic.app', '/api/v1/'+route);
  var response = await http.post(url, body: json.encode(body),headers: {'content-type':'application/json'});
  return response;
}

Future<http.Response> httpFunGet(String route) async {
  var url = Uri.https('gooonj.cyclic.app', '/api/v1/'+route);
  var response = await http.get(url,headers: {'content-type':'application/json'},);
  return response;
}
