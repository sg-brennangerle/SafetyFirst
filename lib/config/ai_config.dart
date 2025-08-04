/// Configuration file for AI services
/// 
/// To use the voice transcription feature:
/// 1. Get an API key from Google AI Studio (https://makersuite.google.com/app/apikey)
/// 2. Replace 'YOUR_API_KEY_HERE' with your actual API key
/// 3. For production, use environment variables or secure storage
class AIConfig {
  // Google AI Studio API Key
  // Get your API key from: https://makersuite.google.com/app/apikey
  static const String googleAIKey = 'YOUR_API_KEY_HERE';
  
  // Gemini model to use for transcription
  static const String geminiModel = 'gemini-2.0-flash-exp';
  
  // Supported languages for translation
  static const List<String> supportedLanguages = ['en', 'es'];
  
  // Language detection patterns
  static const Map<String, List<String>> languagePatterns = {
    'es': [
      'hola', 'gracias', 'por favor', 'seguridad', 'peligro', 'accidente',
      'trabajo', 'construcción', 'herramienta', 'equipo', 'protección',
      'cuidado', 'atención', 'emergencia', 'ayuda', 'problema'
    ],
  };
  
  /// Check if AI services are properly configured
  static bool get isConfigured => googleAIKey != 'YOUR_API_KEY_HERE';
  
  /// Get configuration status message
  static String get configurationStatus {
    if (isConfigured) {
      return 'AI services configured';
    } else {
      return 'AI services not configured. Please set up your API key.';
    }
  }
} 