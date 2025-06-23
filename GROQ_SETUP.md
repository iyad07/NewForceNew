# Groq Llama Integration Setup

This app now uses Groq's API to power the AI chat with Llama models instead of the previous BuildShip integration.

## Setup Instructions

### 1. Get a Groq API Key

1. Visit [Groq Console](https://console.groq.com/keys)
2. Sign up or log in to your account
3. Create a new API key
4. Copy the API key

### 2. Configure the API Key

1. Open `lib/flutter_flow/flutter_flow_util.dart`
2. Find the `GroqConfig` class
3. Replace `'YOUR_GROQ_API_KEY_HERE'` with your actual API key:

```dart
class GroqConfig {
  static const String apiKey = 'gsk_your_actual_api_key_here';
  // ... rest of the configuration
}
```

### 3. Available Models

The app is configured to use `llama-3.1-8b-instant` by default for fast responses. You can change the model in the `GroqConfig` class:

- `llama-3.1-8b-instant` - Fast and efficient (default)
- `llama-3.1-70b-versatile` - More capable but slower
- `llama-3.2-11b-text-preview` - Good balance of speed and capability

### 4. Security Note

⚠️ **Important**: Never commit your actual API key to version control. Consider using environment variables or Flutter's build configurations for production apps.

### 5. Testing

1. Run the app
2. Navigate to the AI chat page
3. Send a message to test the Llama integration
4. You should see streaming responses from the Llama model

## Changes Made

- Updated `stream_response.dart` to use Groq's API format
- Modified request structure to match OpenAI-compatible format
- Added proper Server-Sent Events parsing for streaming responses
- Updated API endpoint in `ai_chat_page_widget.dart`
- Added `GroqConfig` class for centralized configuration

## Troubleshooting

- **401 Unauthorized**: Check that your API key is correct
- **No response**: Verify the API key is properly set in `GroqConfig`
- **Parsing errors**: Check the console for JSON parsing issues

For more information, visit [Groq Documentation](https://console.groq.com/docs/quickstart).