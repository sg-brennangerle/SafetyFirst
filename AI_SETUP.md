# SafetyFirst AI Features Setup Guide

## Overview

The SafetyFirst app includes AI-powered voice transcription and translation features to help construction workers report safety concerns in their preferred language.

## Features

- **Voice Transcription**: Convert spoken safety concerns to text using Google's Gemini AI
- **Language Detection**: Automatically detect Spanish and other languages
- **Translation**: Translate non-English reports to English for management review

## Setup Instructions

### 1. Get Google AI Studio API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated API key

### 2. Configure the App

1. Open `lib/config/ai_config.dart`
2. Replace `'YOUR_API_KEY_HERE'` with your actual API key:

```dart
static const String googleAIKey = 'your-actual-api-key-here';
```

### 3. Test the Features

1. Run the app: `flutter run`
2. Navigate to "Voice Report"
3. Record a safety concern
4. The app will transcribe and translate if needed

## Supported Languages

Currently supported for language detection and translation:
- **English** (en) - Default
- **Spanish** (es) - Auto-detected

## Configuration Options

### Adding New Languages

To add support for additional languages:

1. Edit `lib/config/ai_config.dart`
2. Add language patterns to `languagePatterns`:

```dart
static const Map<String, List<String>> languagePatterns = {
  'es': ['hola', 'gracias', 'seguridad', ...],
  'fr': ['bonjour', 'merci', 'sécurité', ...], // Add French
  'de': ['hallo', 'danke', 'sicherheit', ...], // Add German
};
```

3. Add the language code to `supportedLanguages`:

```dart
static const List<String> supportedLanguages = ['en', 'es', 'fr', 'de'];
```

### Customizing AI Model

To use a different Gemini model:

1. Edit `lib/config/ai_config.dart`
2. Change the model name:

```dart
static const String geminiModel = 'gemini-1.5-flash'; // Alternative model
```

## Security Best Practices

### For Development
- Store API key directly in `ai_config.dart` (as shown above)

### For Production
- Use environment variables
- Store API keys securely
- Implement API key rotation
- Monitor API usage

Example with environment variables:

```dart
static const String googleAIKey = String.fromEnvironment('GOOGLE_AI_KEY');
```

Run with: `flutter run --dart-define=GOOGLE_AI_KEY=your-key`

## Troubleshooting

### Common Issues

1. **"AI services not configured"**
   - Check that you've set the API key in `ai_config.dart`
   - Verify the API key is valid

2. **"No transcription received"**
   - Check your internet connection
   - Verify the audio file was recorded properly
   - Check API key permissions

3. **Translation fails**
   - The app will fall back to the original text
   - Check internet connection
   - Verify the text contains recognizable language patterns

### API Limits

- Google AI Studio has usage limits
- Monitor your usage in the Google AI Studio dashboard
- Consider implementing rate limiting for production use

## Cost Considerations

- Google AI Studio offers free tier with limits
- Check current pricing at [Google AI Studio Pricing](https://ai.google.dev/pricing)
- Monitor usage to avoid unexpected charges

## Support

For technical support:
1. Check the [Flutter documentation](https://flutter.dev/docs)
2. Review [Google AI Studio documentation](https://ai.google.dev/docs)
3. Check the app's error messages for specific issues

## Privacy

- Audio recordings are processed by Google AI services
- No audio data is stored permanently in the app
- Review Google's privacy policy for AI services
- Consider implementing local transcription for sensitive environments 