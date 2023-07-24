import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CatFact {
  Future getCatFact() async {
    Future<dynamic> getData() async {
      Response response = await get(
        Uri.parse(' https://catfact.ninja/fact?max_length=140'),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      }
    }
  }
}
