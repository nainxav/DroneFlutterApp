import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.1.222:5000';

  /// Generic method to handle POST requests
  Future<void> sendCommand(String command) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/command'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'command': command}),
      );

      if (response.statusCode == 200) {
        print('Command "$command" sent successfully.');
      } else {
        print(
          'Failed to send command "$command", Status code: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Error occurred while sending command "$command": $e');
    }
  }

  // /// Simplified POST requests using the generic method
  // Future<void> postArm() => sendCommand('arm');
  // Future<void> postDisarm() => sendCommand('disarm');
  // Future<void> postTestMotor1() => sendCommand('testmotor,1,10');
  // Future<void> postTestMotor2() => sendCommand('testmotor,2,10');

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

  /// GET request to fetch recent data and parse it into a Map
  Future<Map<String, dynamic>> getRequest() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/recent'));
      if (response.statusCode == 200) {
        // Decode and return the JSON as a Map<String, dynamic>
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to fetch data, Status code: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      // Return an error map to the caller for error handling
      return {'error': 'Error occurred: $e'};
    }
  }
}
