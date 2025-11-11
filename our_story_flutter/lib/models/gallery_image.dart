import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryImage {
  const GalleryImage({
    required this.id,
    required this.url,
    required this.storagePath,
    required this.createdAt,
  });

  final String id;
  final String url;
  final String storagePath;
  final DateTime createdAt;

  factory GalleryImage.fromMap(String id, Map<String, dynamic> data) {
    return GalleryImage(
      id: id,
      url: data['url'] as String? ?? '',
      storagePath: data['storagePath'] as String? ?? '',
      createdAt: _parseCreatedAt(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'storagePath': storagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}

