// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Future streamResponse(
    Future Function() onStreamCallback,
    Future Function(String? error)? onErrorCallback,
    Future Function(String? threadId)? onCompleteCallback,
    String url,
    String prompt,
    String? threadId) async {
  try {
    // Setup our request for Groq Llama API
    var request = http.Request('POST', Uri.parse(url))
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GroqConfig.apiKey}',
      })
      ..body = jsonEncode({
        'model': GroqConfig.llamaModel,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'stream': true,
        'max_completion_tokens': 1024,
        'temperature': 0.7,
      });

    // Send the request
    var streamedResponse = await request.send();

    // Retrieve the Thread ID from the header in the response
    String? responseThreadId = streamedResponse.headers['x-thread-id'];

    // Listen to the response stream for Groq's Server-Sent Events format
    streamedResponse.stream.transform(utf8.decoder).listen((value) {
      // Parse Server-Sent Events format from Groq
      final lines = value.split('\n');
      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6); // Remove 'data: ' prefix
          if (data.trim() == '[DONE]') {
            // Stream is complete
            continue;
          }
          try {
            final jsonData = jsonDecode(data);
            final content = jsonData['choices']?[0]?['delta']?['content'];
            if (content != null) {
              // Add the content to the App State variable
              FFAppState().streamResponse += content;
              // Perform callback to perform state update!
              onStreamCallback();
            }
          } catch (e) {
            // Skip malformed JSON chunks
            print('Error parsing chunk: $e');
          }
        }
      }
    }, onError: (e) {
      if (onErrorCallback != null) {
        onErrorCallback(e.toString());
      }
    }, onDone: () {
      if (onCompleteCallback != null) {
        // For Groq, we don't use thread IDs in the same way, pass null or generate one
        onCompleteCallback(null);
      }
    });
  } catch (e) {
    // Handle any other errors
    print('Error: $e');
  }
}
