class Chapter {
  const Chapter({
    required this.chapterLabel,
    required this.title,
    required this.body,
  });

  final String chapterLabel;
  final String title;
  final List<String> body;
}

class TimelineEntry {
  const TimelineEntry({
    required this.dateLabel,
    required this.title,
    required this.body,
  });

  final String dateLabel;
  final String title;
  final String body;
}

class LetterMessage {
  const LetterMessage({
    required this.fromLabel,
    required this.message,
  });

  final String fromLabel;
  final String message;
}

class StoryContent {
  static const List<Chapter> chapters = [
    Chapter(
      chapterLabel: 'Chapter one',
      title: 'How it all began',
      body: [
        "We met unexpectedly. I got to know her because she’s the sister of my college friend. I never thought I’d end up liking her. At first, I tried to stop myself from falling, but I just couldn’t—I fell for her completely.",
        "As days went by, we kept leaving little hints for each other through Instagram notes, until it reached the point where we’d chat and talk on calls all night long. I honestly never expected someone would come into my life and make me love this deeply.",
      ],
    ),
    Chapter(
      chapterLabel: 'Chapter two',
      title: 'Pieces of our everyday',
      body: [
        "Months passed, and we kept talking every day, slowly getting to know each other more deeply. There were times when I felt really down, but she was always there to comfort me—and I did the same whenever she was the one struggling. We’ve been through so many ups and downs, laughter and tears, but we always find our way back to each other. We celebrate even our smallest victories in life, and what makes it even more special is that we get to share those moments together.",
        "The best part? We still feel like we’re just getting started.",
      ],
    ),
  ];

  static const List<TimelineEntry> timeline = [
    TimelineEntry(
      dateLabel: 'June 2023',
      title: 'Our first conversation',
      body:
          "I replied to your Instagram story — I took a risk, not knowing if you’d even notice me or not. But it was all worth it, because you did. You saw me, and that simple moment changed everything.",
    ),
    TimelineEntry(
      dateLabel: 'December 2023',
      title: 'The Letter That Made Us',
      body:
          "After months of courting you, you finally said yes — not through words, but through a heartfelt letter you handed me. Inside it were the sweetest words I’d been waiting for: that we were finally together.",
    ),
    TimelineEntry(
      dateLabel: 'April 2024',
      title: 'First Light by Your Side',
      body:
          "We stayed overnight at a private beach with your family, and it was the first time we slept side by side. We talked all night, and you were the first thing I saw when I woke up.",
    ),
  ];

  static const List<String> galleryPlaceholders = [
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80',
  ];

  static const List<LetterMessage> letters = [
    LetterMessage(
      fromLabel: 'From me',
      message:
          'You make everything softer and brighter. Thank you for listening when I ramble, for staying when things get tough, for reminding me that I am never alone. I love the way you call me out when I hide and the way you hold my hand when I hesitate.',
    ),
    LetterMessage(
      fromLabel: 'From you',
      message:
          'You are the place my heart returns to. You make even the quiet days feel important. I love how you laugh at our inside jokes, how you notice every small thing, and how you always choose us.',
    ),
  ];
}

