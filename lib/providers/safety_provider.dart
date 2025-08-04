import 'package:flutter/material.dart';
import '../models/safety_report.dart';
import '../models/user.dart';
import '../models/job.dart';

class SafetyProvider with ChangeNotifier {
  User? _currentUser;
  List<Job> _assignedJobs = [];
  List<SafetyReport> _reports = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<Job> get assignedJobs => _assignedJobs;
  List<SafetyReport> get reports => _reports;
  bool get isLoading => _isLoading;

  // Mock data for demonstration
  void initializeMockData() {
    _currentUser = User(
      id: '1',
      name: 'John Smith',
      email: 'john.smith@construction.com',
      role: 'Site Supervisor',
    );

    _assignedJobs = [
      Job(id: '1', name: 'Downtown Office Building', location: '123 Main St'),
      Job(id: '2', name: 'Highway Bridge Project', location: 'I-95 Exit 45'),
      Job(id: '3', name: 'Residential Complex', location: '456 Oak Ave'),
    ];

    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void addReport(SafetyReport report) {
    _reports.add(report);
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateJobs(List<Job> jobs) {
    _assignedJobs = jobs;
    notifyListeners();
  }
} 