// lib/src/features/community/presentation/community_screen.dart

import 'package:flutter/material.dart';
import 'package:habitflow/main.dart';

// --- Mock Data Model ---
class CommunityPost {
  final String id;
  final String username;
  final String avatarLetter;
  final String content;
  final int likes;
  final int comments;

  CommunityPost({
    required this.id,
    required this.username,
    required this.avatarLetter,
    required this.content,
    required this.likes,
    required this.comments,
  });
}

// --- Mock Data ---
final List<CommunityPost> mockPosts = [
  CommunityPost(
      id: '1',
      username: 'Alex_G',
      avatarLetter: 'A',
      content:
          'Just hit my 30-day streak on "Morning Run"! Feeling unstoppable. 🔥',
      likes: 120,
      comments: 15),
  CommunityPost(
      id: '2',
      username: 'MariaK',
      avatarLetter: 'M',
      content:
          'Struggling to get started with "Meditate Daily". Any tips for a beginner?',
      likes: 45,
      comments: 22),
  CommunityPost(
      id: '3',
      username: 'CodeNinja',
      avatarLetter: 'C',
      content:
          'Just used the Focus Timer for 4 pomodoro sessions. So productive! 💻',
      likes: 88,
      comments: 9),
];

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      body: ListView.builder(
        itemCount: mockPosts.length,
        itemBuilder: (context, index) {
          final post = mockPosts[index];
          return Card(
            color: HabitFlowTheme.darkSurface,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Post Header ---
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: HabitFlowTheme.primaryColor,
                        child: Text(post.avatarLetter,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Text(post.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // --- Post Content ---
                  Text(post.content,
                      style: const TextStyle(
                          fontSize: 15, color: HabitFlowTheme.kWhite70)),
                  const SizedBox(height: 12),
                  // --- Post Actions ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // FIX: Added const
                      const Icon(Icons.favorite_border,
                          size: 20, color: HabitFlowTheme.kWhite70),
                      const SizedBox(width: 4),
                      Text(post.likes.toString(),
                          style:
                              const TextStyle(color: HabitFlowTheme.kWhite70)),
                      const SizedBox(width: 20),
                      // FIX: Added const
                      const Icon(Icons.comment_outlined,
                          size: 20, color: HabitFlowTheme.kWhite70),
                      const SizedBox(width: 4),
                      Text(post.comments.toString(),
                          style:
                              const TextStyle(color: HabitFlowTheme.kWhite70)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}