import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/gallery_image.dart';
import '../services/auth_service.dart';
import '../services/gallery_repository.dart';
import '../widgets/primary_button.dart';

class GalleryManagerPage extends StatefulWidget {
  const GalleryManagerPage({super.key});

  @override
  State<GalleryManagerPage> createState() => _GalleryManagerPageState();
}

class _GalleryManagerPageState extends State<GalleryManagerPage> {
  late final StreamSubscription<List<GalleryImage>> _subscription;
  List<GalleryImage> _images = const [];
  bool _isUploading = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _subscription = GalleryRepository.instance
        .watchPublicGallery()
        .listen((images) => setState(() => _images = images));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      setState(() {
        _isUploading = true;
        _statusMessage = 'Uploading ${result.files.length} image(s)...';
      });

      for (final file in result.files) {
        final bytes = file.bytes;
        if (bytes == null) {
          throw Exception('Unable to read image bytes. Please try again.');
        }
        await GalleryRepository.instance.uploadImage(
          bytes: bytes,
          originalName: file.name,
        );
      }

      setState(() {
        _statusMessage = 'Upload complete!';
      });
    } on Exception catch (error) {
      setState(() {
        _statusMessage = error.toString();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_statusMessage ?? 'Upload error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _deleteImage(GalleryImage image) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove photo'),
        content: const Text(
          'Are you sure you want to remove this photo from your gallery?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await GalleryRepository.instance.deleteImage(image);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo removed')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove photo: $error')),
      );
    }
  }

  Future<void> _signOut() async {
    await AuthService.instance.signOut();
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF7F2),
              Color(0xFFF3DFDD),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildSummaryCard(context),
                    const SizedBox(height: 32),
                    _buildGalleryGrid(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gallery Manager',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add and curate the memories that appear on your story.',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const Spacer(),
        PrimaryButton(
          label: 'Log out',
          onPressed: _signOut,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;

        final summary = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_library_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text('${_images.length} photos live'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Keep your gallery glowing.',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Drop in new snapshots, tidy up older ones, and make the updates instantly. Portrait or landscape, every moment finds its frame.',
                style: textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ChecklistItem(text: 'Uploads appear on your public gallery in real time.'),
                  SizedBox(height: 12),
                  _ChecklistItem(
                    text: 'Portrait, square, and landscape crops handled automatically.',
                  ),
                  SizedBox(height: 12),
                  _ChecklistItem(text: 'Remove any image with a single click.'),
                ],
              ),
            ],
          ),
        );

        final uploader = Expanded(
          child: _UploadDropZone(
            isUploading: _isUploading,
            statusMessage: _statusMessage,
            onPickFiles: _pickFiles,
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              summary,
              const SizedBox(height: 24),
              uploader,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            summary,
            const SizedBox(width: 32),
            uploader,
          ],
        );
      },
    );
  }

  Widget _buildGalleryGrid(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Published memories',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Everything you see here is already live on the public gallery.',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _images.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 320,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return _GalleryTile(
                        image: image,
                        onDelete: () => _deleteImage(image),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.photo_outlined, size: 48, color: Colors.black38),
          SizedBox(height: 12),
          Text('No images yet. Upload your first memory to get started!'),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF8B4A4A)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withOpacity(0.7),
                ),
          ),
        ),
      ],
    );
  }
}

class _UploadDropZone extends StatelessWidget {
  const _UploadDropZone({
    required this.isUploading,
    required this.statusMessage,
    required this.onPickFiles,
  });

  final bool isUploading;
  final String? statusMessage;
  final VoidCallback onPickFiles;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black12, width: 1.5),
                color: const Color(0xFFF9F3F3),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Drag & drop images here',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'or click to browse your device',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: isUploading ? 'Uploading...' : 'Upload selected images',
                    onPressed: isUploading ? null : onPickFiles,
                  ),
                  if (statusMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      statusMessage!,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _Pill(icon: Icons.insert_photo_outlined, label: 'JPG · PNG · GIF · WEBP'),
                _Pill(icon: Icons.upload_file_outlined, label: 'Upload multiple at once'),
                _Pill(icon: Icons.lock_outline, label: 'Secure & private'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.image, required this.onDelete});

  final GalleryImage image;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.network(
            image.url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
            errorBuilder: (context, error, _) {
              return Container(
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Material(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(24),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.delete_outline, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

