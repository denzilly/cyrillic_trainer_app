import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';

import '../services/leaderboard_service.dart';
import '../theme/app_theme.dart';
import '../widgets/scrollable_centered_content.dart';
import '../widgets/tactile_button.dart';

/// High Scores: the global top 10 streaks, plus the current player's own
/// entry below if they're not already in the top 10.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<LeaderboardData?> _future;

  @override
  void initState() {
    super.initState();
    _future = LeaderboardService.instance.fetchLeaderboard();
  }

  void _retry() {
    setState(() => _future = LeaderboardService.instance.fetchLeaderboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('High Scores')),
      body: SafeArea(
        child: ScrollableCenteredContent(
          child: FutureBuilder<LeaderboardData?>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data;
              if (data == null) {
                return _SignInPrompt(onRetry: _retry);
              }
              if (data.top.isEmpty) {
                return const _EmptyState();
              }
              return _LeaderboardList(data: data);
            },
          ),
        ),
      ),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  final VoidCallback onRetry;

  const _SignInPrompt({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Couldn't sign in to Google Play Games.",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.gutter),
        SizedBox(
          width: double.infinity,
          child: TactileButton(onPressed: onRetry, child: const Text('Sign In')),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Text(
      'No scores yet — be the first!',
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final LeaderboardData data;

  const _LeaderboardList({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in data.top)
          _LeaderboardRow(
            entry: entry,
            isPlayer: data.player != null && entry.rank == data.player!.rank,
          ),
        if (data.player != null && !data.playerInTop) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.base),
            child: Text('…', textAlign: TextAlign.center),
          ),
          _LeaderboardRow(entry: data.player!, isPlayer: true),
        ],
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardScoreData entry;
  final bool isPlayer;

  const _LeaderboardRow({required this.entry, required this.isPlayer});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutter,
        vertical: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.primaryContainer : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${entry.rank}',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isPlayer ? AppColors.onPrimary : AppColors.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.scoreHolder.displayName,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(
                color: isPlayer ? AppColors.onPrimary : AppColors.onSurface,
              ),
            ),
          ),
          Text(
            entry.displayScore,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isPlayer ? AppColors.onPrimary : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
