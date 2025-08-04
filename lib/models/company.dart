class Company {
  final String id;
  final String name;
  final String industry;
  final String address;
  final String contactEmail;
  final String contactPhone;
  final DateTime createdAt;
  final bool isActive;
  final Map<String, dynamic> settings;

  Company({
    required this.id,
    required this.name,
    required this.industry,
    required this.address,
    required this.contactEmail,
    required this.contactPhone,
    required this.createdAt,
    this.isActive = true,
    this.settings = const {},
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      name: json['name'] as String,
      industry: json['industry'] as String,
      address: json['address'] as String,
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      settings: json['settings'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'industry': industry,
      'address': address,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'settings': settings,
    };
  }

  Company copyWith({
    String? id,
    String? name,
    String? industry,
    String? address,
    String? contactEmail,
    String? contactPhone,
    DateTime? createdAt,
    bool? isActive,
    Map<String, dynamic>? settings,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      industry: industry ?? this.industry,
      address: address ?? this.address,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
    );
  }
} 