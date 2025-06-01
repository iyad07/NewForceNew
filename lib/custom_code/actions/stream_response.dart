// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future streamResponse(
    Future Function() onStreamCallback,
    Future Function(String? error)? onErrorCallback,
    Future Function(String? threadId)? onCompleteCallback,
    String url,
    String prompt,
    String? threadId) async {
  try {
    // Setup our request. Pass in a pompt within the body of the request
    var request = http.Request('POST', Uri.parse(url))
      ..headers.addAll({'Content-Type': 'application/json'})
      ..body = jsonEncode({'prompt': prompt, 'threadId': threadId});

    // Send the request
    var streamedResponse = await request.send();

    // Retrieve the Thread ID from the header in the response
    String? responseThreadId = streamedResponse.headers['x-thread-id'];

    // Listen to the response stream
    streamedResponse.stream.transform(utf8.decoder).listen((value) {
      // Continually add the response value to the App State variable called streamResponse
      FFAppState().streamResponse += value;
      // Perform callback to perform state update!
      onStreamCallback();
    }, onError: (e) {
      if (onErrorCallback != null) {
        onErrorCallback(e);
      }
    }, onDone: () {
      if (onCompleteCallback != null) {
        onCompleteCallback(responseThreadId);
      }
    });
  } catch (e) {
    // Handle any other errors
    print('Error: $e');
  }
}
