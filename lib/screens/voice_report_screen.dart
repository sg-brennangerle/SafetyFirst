import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:translator/translator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

import '../providers/safety_provider.dart';
import '../models/safety_report.dart';
import '../models/job.dart';
import '../config/ai_config.dart';
import 'package:intl/intl.dart';

class VoiceReportScreen extends StatefulWidget {
  const VoiceReportScreen({super.key});

  @override
  State<VoiceReportScreen> createState() => _VoiceReportScreenState();
}

class _VoiceReportScreenState extends State<VoiceReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  
  File? _audioFile;
  Job? _selectedJob;
  DateTime _observedAt = DateTime.now();
  bool _isSubmitting = false;
  bool _isRecording = false;
  bool _isTranscribing = false;
  bool _isTranslating = false;
  String _transcribedText = '';
  String _originalLanguage = 'en';
  String _translatedText = '';

  @override
  void initState() {
    super.initState();
    _observedAt = DateTime.now();
    _initializeSpeech();
    _requestPermissions();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice recording'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _initializeSpeech() async {
    // Speech recognition initialization pending configuration
  }

  Future<void> _startRecording() async {
    try {
      // For now, simulate recording since Record package needs proper configuration
      setState(() {
        _isRecording = true;
      });
      
      // Simulate recording for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording simulated - audio recording pending configuration'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting recording: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isRecording = false;
      });
      
      // Simulate audio file creation
      _audioFile = File('/tmp/simulated_audio.wav');
      await _transcribeAudio();
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping recording: $e'),
            backgroundColor: Colors.red,
        ),
        );
      }
    }
  }

  Future<void> _transcribeAudio() async {
    if (_audioFile == null) return;

    setState(() {
      _isTranscribing = true;
    });

    try {
      // Read audio file as bytes
      final audioBytes = await _audioFile!.readAsBytes();
      
      // Initialize Google Generative AI
      if (!AIConfig.isConfigured) {
        throw Exception('AI services not configured. Please set up your API key in lib/config/ai_config.dart');
      }
      
      final model = GenerativeModel(
        model: AIConfig.geminiModel,
        apiKey: AIConfig.googleAIKey,
      );
      
      try {
        // Create content with audio data
        final content = Content.multi([
          TextPart('Please transcribe this audio recording of a safety concern. Return only the transcribed text without any additional commentary.'),
          DataPart('audio/wav', audioBytes),
        ]);

        final response = await model.generateContent([content]);
        
        if (response.text != null && response.text!.isNotEmpty) {
          setState(() {
            _transcribedText = response.text!;
            _descriptionController.text = _transcribedText;
            _isTranscribing = false;
          });
          
          // Auto-detect language and translate if needed
          await _detectAndTranslate();
        } else {
          throw Exception('No transcription received from AI service');
        }
      } catch (aiError) {
        // Fallback to mock transcription if AI service fails
        setState(() {
          _transcribedText = "Safety concern recorded - AI transcription service unavailable. Please manually describe the concern.";
          _descriptionController.text = _transcribedText;
          _isTranscribing = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('AI transcription unavailable. Please manually describe the safety concern.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        
        // Auto-detect language and translate if needed
        await _detectAndTranslate();
      }
      
    } catch (e) {
      setState(() {
        _isTranscribing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error transcribing audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _detectAndTranslate() async {
    if (_transcribedText.isEmpty) return;

    setState(() {
      _isTranslating = true;
    });

    try {
      final translator = GoogleTranslator();
      
      // Language detection based on configured patterns
      String detectedLanguage = 'en';
      
      final lowerText = _transcribedText.toLowerCase();
      
      // Check each supported language's patterns
      for (final language in AIConfig.languagePatterns.keys) {
        final patterns = AIConfig.languagePatterns[language]!;
        final wordCount = patterns.where((word) => lowerText.contains(word)).length;
        
        if (wordCount >= 2) {
          detectedLanguage = language;
          break;
        }
      }
      
      setState(() {
        _originalLanguage = detectedLanguage;
      });

      // If not English, translate to English
      if (detectedLanguage != 'en') {
        try {
          final translation = await translator.translate(
            _transcribedText,
            from: detectedLanguage,
            to: 'en',
          );
          
          setState(() {
            _translatedText = translation.text;
            _isTranslating = false;
          });
        } catch (translationError) {
          // If translation fails, keep original text
          setState(() {
            _translatedText = '';
            _isTranslating = false;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Translation unavailable. Original text preserved.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        setState(() {
          _translatedText = '';
          _isTranslating = false;
        });
      }
    } catch (e) {
      setState(() {
        _isTranslating = false;
      });
      // Translation error logged
    }
  }

  Future<void> _selectObservedTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _observedAt,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_observedAt),
      );
      if (time != null && mounted) {
        setState(() {
          _observedAt = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate() || _selectedJob == null || _audioFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields and record audio'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final safetyProvider = context.read<SafetyProvider>();
      final user = safetyProvider.currentUser;

      if (user == null) {
        throw Exception('User not found');
      }

      final report = SafetyReport(
        reporterName: user.name,
        jobId: _selectedJob!.id,
        jobName: _selectedJob!.name,
        description: _descriptionController.text.trim(),
        observedAt: _observedAt,
        reportedAt: DateTime.now(),
        type: ReportType.voice,
        voicePath: _audioFile!.path,
        transcribedText: _transcribedText,
        originalLanguage: _originalLanguage,
        translatedText: _translatedText.isNotEmpty ? _translatedText : null,
      );

      safetyProvider.addReport(report);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice safety report submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final safetyProvider = Provider.of<SafetyProvider>(context);
    final user = safetyProvider.currentUser;
    final jobs = safetyProvider.assignedJobs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Safety Concern'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.mic,
                        size: 48,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Voice Safety Report',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Record your safety concern and it will be transcribed',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Voice Recording Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voice Recording *',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (_audioFile != null) ...[
                        // Display recorded audio
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.audiotrack,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Audio recorded successfully',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _startRecording,
                                icon: const Icon(Icons.mic),
                                label: const Text('Record Again'),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Recording button
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _isRecording
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.stop,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Recording... Tap to stop',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: _startRecording,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mic,
                                        size: 48,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to start recording',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                      
                      if (_isRecording) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _stopRecording,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Stop Recording'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (_isTranscribing) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text('Transcribing audio...'),
                      ],
                    ),
                  ),
                ),
              ],

              if (_isTranslating) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text('Translating...'),
                      ],
                    ),
                  ),
                ),
              ],

              if (_translatedText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Translation',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            _translatedText,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Reporter Name (Auto-populated)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reporter',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user?.name ?? 'Not available',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Job Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job Site *',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Job>(
                        value: _selectedJob,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        hint: const Text('Select a job site'),
                        items: jobs.map((Job job) {
                          return DropdownMenuItem<Job>(
                            value: job,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  job.name,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  job.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (Job? newValue) {
                          setState(() {
                            _selectedJob = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a job site';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Observed Time
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'When did you observe this?',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectObservedTime,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  DateFormat('MMM dd, yyyy - h:mm a').format(_observedAt),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description (Auto-populated from transcription)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description *',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Transcribed text will appear here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please record and transcribe your safety concern';
                          }
                          if (value.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: (_isSubmitting || _audioFile == null) ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Submitting...'),
                        ],
                      )
                    : const Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 