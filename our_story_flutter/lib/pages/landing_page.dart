import 'dart:math';

import 'package:flutter/material.dart';

import '../models/gallery_image.dart';
import '../models/story_content.dart';
import '../services/gallery_repository.dart';
import '../theme/palette.dart';
import '../widgets/app_navbar.dart';
import '../widgets/primary_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.ivory,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Palette.radialBlushGradient(),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              AppNavbar(),
              _HeroSection(),
              SizedBox(height: 96),
              _ChapterSection(),
              SizedBox(height: 96),
              _TimelineSection(),
              SizedBox(height: 96),
              _GallerySection(),
              SizedBox(height: 80),
              _LettersSection(),
              SizedBox(height: 80),
              _SoundtrackSection(),
              SizedBox(height: 64),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        final padding = EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: isMobile ? 40 : 64,
        );

        return Padding(
          padding: padding,
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isMobile ? 0 : 5,
                child: Padding(
                  padding: EdgeInsets.only(right: isMobile ? 0 : 56),
                  child: _HeroText(),
                ),
              ),
              const SizedBox(height: 32, width: 32),
              Expanded(
                flex: isMobile ? 0 : 4,
                child: _HeroPhotos(isMobile: isMobile),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Since 2023 · Still counting',
          style: textTheme.bodyMedium?.copyWith(
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.45),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This is the story of us',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Two souls who stumbled into each other’s orbit and never wanted to leave. '
          'Our days are stitched together with little rituals, road trips, late-night talks, '
          'and every photograph we take is a promise to remember.',
          style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          runSpacing: 12,
          spacing: 16,
          children: [
            PrimaryButton(
              label: 'See our moments',
              onPressed: () {},
              variant: ButtonVariant.filled,
            ),
            PrimaryButton(
              label: 'Read our chapters',
              onPressed: () {},
              variant: ButtonVariant.outlined,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Text(
            '“We didn’t just fall in love—we started building a life we can’t stop dreaming about.”',
            style: textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.black.withOpacity(0.65),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroPhotos extends StatelessWidget {
  const _HeroPhotos({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final height = isMobile ? 360.0 : 520.0;

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF1E1E2C),
                        Color(0xFF3C3C58),
                        Color(0xFF6F667E),
                      ],
                    ),
                    image: DecorationImage(
                      image: const NetworkImage(
                        'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?auto=format&fit=crop&w=900&q=80',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.25),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: isMobile ? 16 : -20,
            top: isMobile ? 16 : 40,
            child: _HeroMemoryCard(),
          ),
          Positioned(
            left: isMobile ? 12 : -32,
            bottom: isMobile ? -24 : -48,
            child: Transform.rotate(
              angle: -8 * pi / 180,
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SizedBox(
                  width: isMobile ? 150 : 190,
                  height: isMobile ? 150 : 190,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMemoryCard extends StatelessWidget {
  const _HeroMemoryCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favourite memory',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'It was the night of her debut, and neither of us got any sleep. '
            'We spent the whole night together, talking and laughing until dawn. '
            'As the morning came, we watched the sun rise side by side by the shore — '
            'a quiet, beautiful moment that felt like it belonged only to us.',
            style: textTheme.bodySmall?.copyWith(
              height: 1.5,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterSection extends StatelessWidget {
  const _ChapterSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Palette.blushSweepGradient(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Wrap(
              spacing: 32,
              runSpacing: 32,
              children: StoryContent.chapters.map((chapter) {
                return SizedBox(
                  width: 520,
                  child: Card(
                    elevation: 0,
                    color: Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 36,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.chapterLabel.toUpperCase(),
                            style: textTheme.labelLarge?.copyWith(
                              letterSpacing: 3,
                              color: Colors.black.withOpacity(0.45),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            chapter.title,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...chapter.body.map(
                            (paragraph) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                paragraph,
                                style: textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                  color: Colors.black.withOpacity(0.72),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Milestones',
                style: textTheme.labelLarge?.copyWith(
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.45),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'A timeline of us',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: min(MediaQuery.of(context).size.width * 0.6, 620),
                child: Text(
                  'Moments that changed us, frightened us, and made us fall in love over and over again.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _TimelineCardList(entries: StoryContent.timeline),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineCardList extends StatelessWidget {
  const _TimelineCardList({required this.entries});

  final List<TimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        return Stack(
          children: [
            Positioned(
              left: isMobile ? 16 : 40,
              top: 0,
              bottom: 0,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.1),
                      colorScheme.primary.withOpacity(0.4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Column(
              children: entries.map((entry) {
                return _TimelineItem(
                  entry: entry,
                  isMobile: isMobile,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.entry,
    required this.isMobile,
  });

  final TimelineEntry entry;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 0 : 8, top: 24),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 18,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              margin: EdgeInsets.only(right: isMobile ? 0 : 80),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.dateLabel,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      entry.title,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      entry.body,
                      style: textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 700
        ? 2
        : width < 1000
            ? 3
            : 4;

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gallery',
                          style: textTheme.labelLarge?.copyWith(
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.45),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Snapshots of our favourite days',
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: min(420, width * 0.4),
                    child: Text(
                      'These are the photos that take us back—the blurry ones, the ones where we’re laughing too hard, the ones where we forgot the camera was there. Each picture is a chapter.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              StreamBuilder<List<GalleryImage>>(
                stream: GalleryRepository.instance.watchPublicGallery(),
                builder: (context, snapshot) {
                  final images = snapshot.data;

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      images == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final urls = (images == null || images.isEmpty)
                      ? StoryContent.galleryPlaceholders
                      : images.map((image) => image.url).toList();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final tileWidth =
                          (constraints.maxWidth - ((crossAxisCount - 1) * 24)) /
                              crossAxisCount;

                      return Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: urls.map((url) {
                          return SizedBox(
                            width: tileWidth,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.black12,
                                      child: const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, _) {
                                    return Container(
                                      color: Colors.black12,
                                      child: const Center(
                                        child: Icon(Icons.broken_image_outlined),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: PrimaryButton(
                  label: 'View all photos',
                  onPressed: () {},
                  variant: ButtonVariant.outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LettersSection extends StatelessWidget {
  const _LettersSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF8E8E2),
            Color(0xFFF1D6D3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Letters to each other',
                  style: textTheme.labelLarge?.copyWith(
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.45),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Words we never want to forget',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 48),
                Wrap(
                  spacing: 32,
                  runSpacing: 32,
                  children: StoryContent.letters.map((letter) {
                    return SizedBox(
                      width: 480,
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                letter.fromLabel,
                                style: textTheme.titleMedium?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '"${letter.message}"',
                                style: textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SoundtrackSection extends StatelessWidget {
  const _SoundtrackSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 48,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 640;
                  return Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Our soundtrack',
                              style: textTheme.labelLarge?.copyWith(
                                letterSpacing: 3,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.45),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Songs that feel like us',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Press play to open “Until I Found You” by Stephen Sanchez—the song that feels like evening drives, warm hugs, and us humming along under our breath.',
                              style: textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isMobile ? 32 : 0, width: isMobile ? 0 : 32),
                      PrimaryButton(
                        label: 'Play our song',
                        onPressed: () {},
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A2133),
            Color(0xFF1C1524),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                '“May we keep capturing moments that feel like home.”',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                '© Raphael James Evangelio & Attacent Cheimen Malinao',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

