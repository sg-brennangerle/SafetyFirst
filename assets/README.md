# SafetyFirst App Assets

This directory contains static assets used by the SafetyFirst app.

## Directory Structure

```
assets/
├── images/          # Safety-related images and photos
├── icons/           # App icons and safety icons
└── README.md        # This file
```

## Usage

### Images Directory (`assets/images/`)
- Store safety-related images
- Photo examples for safety concerns
- Training materials and safety guides
- Construction site safety images

### Icons Directory (`assets/icons/`)
- App icons and logos
- Safety warning icons
- Construction equipment icons
- Navigation and UI icons

## Adding Assets

1. Place your image/icon files in the appropriate directory
2. Update `pubspec.yaml` if you add new asset types
3. Reference assets in your code using the correct path

## Asset References

In your Dart code, reference assets like this:

```dart
// For images
Image.asset('assets/images/safety_guide.png')

// For icons
Image.asset('assets/icons/warning_icon.png')
```

## File Formats

- **Images**: PNG, JPG, WebP (recommended for web)
- **Icons**: SVG, PNG (for better cross-platform support)

## Optimization

- Compress images for faster loading
- Use appropriate file formats for your target platforms
- Consider using vector graphics (SVG) for icons when possible 