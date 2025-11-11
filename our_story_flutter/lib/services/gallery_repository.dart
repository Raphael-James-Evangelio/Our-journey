import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/gallery_image.dart';

class GalleryRepository {
  GalleryRepository._();

  static final GalleryRepository instance = GalleryRepository._();

  final _collection =
      FirebaseFirestore.instance.collection('gallery').withConverter(
            fromFirestore: (snapshot, _) =>
                GalleryImage.fromMap(snapshot.id, snapshot.data() ?? {}),
            toFirestore: (image, _) => image.toMap(),
          );

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<GalleryImage>> watchPublicGallery() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> uploadImage({
    required Uint8List bytes,
    required String originalName,
  }) async {
    final sanitizedName =
        originalName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final docRef = _collection.doc();
    final storagePath = 'gallery/${docRef.id}-$sanitizedName';

    final metadata = SettableMetadata(contentType: _detectMimeType(sanitizedName));
    final ref = _storage.ref(storagePath);
    await ref.putData(bytes, metadata);
    final downloadUrl = await ref.getDownloadURL();

    final image = GalleryImage(
      id: docRef.id,
      url: downloadUrl,
      storagePath: storagePath,
      createdAt: DateTime.now(),
    );

    await docRef.set(image);
  }

  Future<void> deleteImage(GalleryImage image) async {
    await _collection.doc(image.id).delete();
    if (image.storagePath.isNotEmpty) {
      await _storage.ref(image.storagePath).delete();
    }
  }

  String _detectMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}

