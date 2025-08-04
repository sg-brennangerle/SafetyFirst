# SafetyFirst - Construction Safety Reporting App

A comprehensive Flutter application designed specifically for the construction industry to report safety concerns quickly and easily. The app provides three intuitive ways to report safety issues: text input, photo capture, and voice recording with AI-powered transcription and translation.

## Features

### 🏗️ **Construction Industry Focused**
- Auto-populated user information
- Job site dropdown with assigned locations
- Safety-specific reporting categories
- Professional construction terminology

### 📝 **Three Reporting Methods**

#### 1. **Text Report**
- Simple form with auto-populated user name
- Job site selection dropdown
- Detailed description field
- Automatic timestamping (observed and reported times)

#### 2. **Photo Report**
- Camera integration for immediate photo capture
- Same form structure as text reports
- Photo preview and retake functionality
- High-quality image capture optimized for safety documentation

#### 3. **Voice Report**
- Real-time voice recording
- **AI-powered transcription** using Google's Gemini
- **Automatic translation** (Spanish ↔ English)
- Speech-to-text conversion
- Multi-language support

### 🤖 **AI Integration**
- **Gemini AI** for voice transcription
- **Google Translate** for language support
- Automatic language detection
- High-accuracy transcription

### 🎨 **Modern UI/UX**
- Material Design 3 implementation
- Dark/Light theme support
- Responsive design for mobile and web
- Intuitive navigation
- Professional safety-focused color scheme

### 🔒 **Data Management**
- Local state management with Provider
- Structured data models
- Timestamp tracking
- Report history

## Technical Stack

- **Framework**: Flutter 3.8+
- **Language**: Dart
- **State Management**: Provider
- **AI Services**: Firebase AI (Gemini)
- **Translation**: Google Translate API
- **Camera**: image_picker
- **Voice Recording**: record, speech_to_text
- **UI**: Material Design 3, Google Fonts
- **Permissions**: permission_handler

## Setup Instructions

### Prerequisites
1. **Flutter SDK** (3.8.0 or higher)
2. **Dart SDK** (3.0.0 or higher)
3. **Firebase Project** with AI services enabled
4. **Android Studio** or **VS Code** with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd SafetyFirst
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable the Gemini API in the Firebase Console
   - Add your Firebase configuration files:
     - `android/app/google-services.json` (Android)
     - `ios/Runner/GoogleService-Info.plist` (iOS)
     - `web/firebase_options.dart` (Web)

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Configuration

1. **Enable Gemini API**:
   - Go to Firebase Console → Build with Gemini
   - Enable the Gemini API for your project

2. **Configure Firebase AI**:
   - The app uses Firebase AI SDK for secure API access
   - No API keys needed in code (handled by Firebase)

## App Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── user.dart            # User model
│   ├── job.dart             # Job site model
│   └── safety_report.dart   # Safety report model
├── providers/
│   ├── theme_provider.dart  # Theme management
│   └── safety_provider.dart # Safety data management
├── screens/
│   ├── home_screen.dart     # Main dashboard
│   ├── text_report_screen.dart    # Text reporting
│   ├── photo_report_screen.dart   # Photo reporting
│   └── voice_report_screen.dart   # Voice reporting
├── services/                # Business logic services
└── widgets/                 # Reusable UI components
```

## Usage

### For Construction Workers

1. **Open the app** - Clean, simple interface with three clear options
2. **Choose reporting method**:
   - **Type**: Quick text entry for immediate concerns
   - **Photo**: Capture visual evidence of safety issues
   - **Voice**: Speak naturally in any language
3. **Fill required information**:
   - Job site (pre-populated dropdown)
   - Description (auto-filled for voice reports)
   - Timestamp (automatic)
4. **Submit** - Report is saved and ready for management review

### For Management

- All reports include:
  - Reporter identification
  - Job site location
  - Detailed description
  - Timestamps (observed and reported)
  - Media attachments (photos/audio)
  - Translation (if applicable)

## Key Features Explained

### Voice Recording with AI
- **Recording**: High-quality audio capture
- **Transcription**: Gemini AI converts speech to text
- **Translation**: Automatic Spanish/English translation
- **Language Detection**: Identifies spoken language automatically

### Photo Documentation
- **Camera Integration**: Direct photo capture
- **Quality Optimization**: High-resolution images
- **Preview**: Review before submission
- **Retake**: Easy photo replacement

### Data Integrity
- **Timestamps**: Both observed and reported times
- **User Tracking**: Automatic reporter identification
- **Job Site Association**: Proper location tracking
- **Media Storage**: Photos and audio files preserved

## Development Notes

### State Management
- Uses Provider pattern for clean state management
- Separate providers for theme and safety data
- Reactive UI updates

### Error Handling
- Comprehensive error handling for all operations
- User-friendly error messages
- Graceful degradation for missing permissions

### Performance
- Optimized image capture and processing
- Efficient audio recording and transcription
- Minimal memory footprint

## Future Enhancements

- **Cloud Storage**: Firebase Firestore integration
- **Push Notifications**: Real-time safety alerts
- **Analytics**: Safety trend analysis
- **Offline Support**: Work without internet connection
- **Multi-language UI**: Complete app translation
- **QR Code Integration**: Quick job site identification

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support or questions, please contact the development team or create an issue in the repository.

---

**SafetyFirst** - Keeping construction sites safe, one report at a time. 🏗️🛡️
