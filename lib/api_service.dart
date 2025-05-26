import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // final String baseUrl = 'http://10.0.2.2:5000';
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<void> postRequest() async {
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'arm',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  Future<void> postRequest2() async {
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'disarm',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  Future<void> postRequest3() async {
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'testmotor,1,10',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  Future<void> postRequest4() async {
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'testmotor,2,10',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  Future<Map<String, dynamic>> getRequest() async {
    final url = Uri.parse('$baseUrl/follow');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return {'data': json.decode(response.body)};
      } else {
        return {'error': 'Server responded with status ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Failed to connect: $e'};
    }
  }
}
