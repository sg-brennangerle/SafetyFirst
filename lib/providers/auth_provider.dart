import 'package:flutter/material.dart';
import '../models/auth_user.dart';
import '../models/company.dart';

class AuthProvider with ChangeNotifier {
  AuthUser? _currentUser;
  Company? _currentCompany;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  // Getters
  AuthUser? get currentUser => _currentUser;
  Company? get currentCompany => _currentCompany;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isSupervisor => _currentUser?.isSupervisor ?? false;
  bool get canReport => _currentUser?.canReport ?? false;

  // Mock data for demonstration
  final List<AuthUser> _mockUsers = [
    AuthUser(
      id: '1',
      email: 'admin@constructionco.com',
      firstName: 'John',
      lastName: 'Smith',
      companyId: '1',
      role: UserRole.admin,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    AuthUser(
      id: '2',
      email: 'supervisor@constructionco.com',
      firstName: 'Sarah',
      lastName: 'Johnson',
      companyId: '1',
      role: UserRole.supervisor,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    AuthUser(
      id: '3',
      email: 'worker@constructionco.com',
      firstName: 'Mike',
      lastName: 'Davis',
      companyId: '1',
      role: UserRole.worker,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  final List<Company> _mockCompanies = [
    Company(
      id: '1',
      name: 'Construction Co.',
      industry: 'Construction',
      address: '123 Main St, City, State 12345',
      contactEmail: 'info@constructionco.com',
      contactPhone: '(555) 123-4567',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  // Authentication methods
  Future<bool> login(String email, String password) async {
    setLoading(true);
    clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Find user in mock data
      final user = _mockUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('Invalid credentials'),
      );

      // In a real app, you would validate the password here
      if (password != 'password') {
        throw Exception('Invalid credentials');
      }

      // Find company
      final company = _mockCompanies.firstWhere(
        (company) => company.id == user.companyId,
      );

      // Update user's last login
      final updatedUser = user.copyWith(
        lastLoginAt: DateTime.now(),
      );

      _currentUser = updatedUser;
      _currentCompany = company;
      _isAuthenticated = true;

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String companyName,
    required String industry,
  }) async {
    setLoading(true);
    clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if user already exists
      final existingUser = _mockUsers.any(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );

      if (existingUser) {
        throw Exception('User with this email already exists');
      }

      // Create new company
      final newCompany = Company(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: companyName,
        industry: industry,
        address: 'Address to be updated',
        contactEmail: email,
        contactPhone: 'Phone to be updated',
        createdAt: DateTime.now(),
      );

      // Create new user (admin role for company creator)
      final newUser = AuthUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: firstName,
        lastName: lastName,
        companyId: newCompany.id,
        role: UserRole.admin,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // In a real app, you would save to backend here
      _mockUsers.add(newUser);
      _mockCompanies.add(newCompany);

      _currentUser = newUser;
      _currentCompany = newCompany;
      _isAuthenticated = true;

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = null;
      _currentCompany = null;
      _isAuthenticated = false;

      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    if (_currentUser == null) return;

    setLoading(true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = _currentUser!.copyWith(
        firstName: firstName ?? _currentUser!.firstName,
        lastName: lastName ?? _currentUser!.lastName,
        email: email ?? _currentUser!.email,
      );

      // Update in mock data
      final index = _mockUsers.indexWhere((user) => user.id == _currentUser!.id);
      if (index != -1) {
        _mockUsers[index] = updatedUser;
      }

      _currentUser = updatedUser;
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  // Helper methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Mock data access for demonstration
  List<AuthUser> getCompanyUsers() {
    if (_currentCompany == null) return [];
    return _mockUsers.where((user) => user.companyId == _currentCompany!.id).toList();
  }

  // Initialize with demo data
  void initializeDemoData() {
    // This would typically load from local storage or backend
    notifyListeners();
  }
} 