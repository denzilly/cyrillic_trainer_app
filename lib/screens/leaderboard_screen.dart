import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';

import '../services/leaderboard_service.dart';
import '../theme/app_theme.dart';
import '../widgets/round_back_button.dart';
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
    // Block body, not `=>`: an arrow function's implicit return value here
    // would be the assignment's value (the Future itself), which trips
    // Flutter's "setState() callback argument returned a Future" assertion.
    setState(() {
      _future = LeaderboardService.instance.fetchLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No title text: the body's own "Global High Scores" header already
      // covers it, so the AppBar just carries the back button.
      appBar: AppBar(leading: const RoundBackButton()),
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
              // top can be empty while the player still has a score: Play
              // Games Services' global rankings cache lags behind a just
              // -submitted score, sometimes by a while, so an empty global
              // list doesn't mean nothing was ever submitted.
              if (data.top.isEmpty && data.player == null) {
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

/// A rank of -1 means Play Games Services hasn't computed a global rank for
/// this score yet (e.g. the leaderboard is still a draft, or the rank cache
/// just hasn't caught up) — never literally "rank negative one" to a player.
String _rankLabel(int rank) => rank > 0 ? '$rank' : '–';

class _LeaderboardList extends StatelessWidget {
  final LeaderboardData data;

  const _LeaderboardList({required this.data});

  @override
  Widget build(BuildContext context) {
    final podium = data.top.take(3).toList();
    final rest = data.top.skip(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TitleHeader(),
        const SizedBox(height: AppSpacing.gutter),
        if (podium.isNotEmpty) ...[
          _Podium(entries: podium, playerRank: data.player?.rank),
          const SizedBox(height: AppSpacing.gutter),
        ],
        for (final entry in rest)
          _LeaderboardRow(
            entry: entry,
            isPlayer: data.player != null && entry.rank == data.player!.rank,
          ),
        if (data.player != null && !data.playerInTop) ...[
          // The "gap" marker only makes sense when there's a visible top
          // list above it to gap from — otherwise (global rankings not
          // caught up yet) it'd float above the player's row for no reason.
          if (data.top.isNotEmpty)
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

class _TitleHeader extends StatelessWidget {
  const _TitleHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Global High Scores',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base),
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ],
    );
  }
}

/// The top-3 podium: rank 1 elevated and centered with a trophy and the
/// brand purple, ranks 2 and 3 flanking it in the neutral surface color.
class _Podium extends StatelessWidget {
  final List<LeaderboardScoreData> entries; // 1-3 entries, rank-ascending.
  final int? playerRank;

  const _Podium({required this.entries, this.playerRank});

  @override
  Widget build(BuildContext context) {
    final first = entries.isNotEmpty ? entries[0] : null;
    final second = entries.length > 1 ? entries[1] : null;
    final third = entries.length > 2 ? entries[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: second == null
              ? const SizedBox.shrink()
              : _PodiumPlace(entry: second, isPlayer: playerRank == second.rank),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: first == null
              ? const SizedBox.shrink()
              : _PodiumPlace(entry: first, isPlayer: playerRank == first.rank, isFirst: true),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: third == null
              ? const SizedBox.shrink()
              : _PodiumPlace(entry: third, isPlayer: playerRank == third.rank),
        ),
      ],
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final LeaderboardScoreData entry;
  final bool isPlayer;
  final bool isFirst;

  const _PodiumPlace({required this.entry, required this.isPlayer, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    final avatarSize = isFirst ? 72.0 : 56.0;
    final ringColor = isFirst ? AppColors.accent : AppColors.outlineVariant;
    final boxColor = isFirst ? AppColors.primaryContainer : AppColors.surfaceContainer;
    final onBoxColor = isFirst ? AppColors.onPrimary : AppColors.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          child: isFirst
              ? const Icon(Icons.emoji_events, color: AppColors.accent, size: 28)
              : null,
        ),
        Container(
          width: avatarSize,
          height: avatarSize,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: ringColor),
          child: _Avatar(entry: entry, size: avatarSize - 6),
        ),
        const SizedBox(height: AppSpacing.base / 2),
        Text(
          entry.scoreHolder.displayName,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.base),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: isFirst ? 20 : 14),
          decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(AppRadius.md)),
          alignment: Alignment.center,
          child: Text(
            entry.displayScore,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: onBoxColor, fontSize: isFirst ? 28 : 22),
          ),
        ),
      ],
    );
  }
}

/// A player's profile photo from Play Games, falling back to a generic
/// person icon when there isn't one (or it hasn't loaded).
class _Avatar extends StatelessWidget {
  final LeaderboardScoreData entry;
  final double size;

  const _Avatar({required this.entry, required this.size});

  @override
  Widget build(BuildContext context) {
    final iconImage = entry.scoreHolder.iconImage;
    final hasImage = iconImage != null && iconImage.isNotEmpty;
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.surfaceContainerLow,
      backgroundImage: hasImage ? NetworkImage(iconImage) : null,
      child: hasImage
          ? null
          : Icon(Icons.person, size: size * 0.6, color: AppColors.onSurfaceVariant),
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
    final onColor = isPlayer ? AppColors.onPrimary : AppColors.onSurface;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.primaryContainer : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              _rankLabel(entry.rank),
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: onColor),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          _Avatar(entry: entry, size: 36),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Text(
              entry.scoreHolder.displayName,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(color: onColor),
            ),
          ),
          Text(
            entry.displayScore,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: onColor),
          ),
          const SizedBox(width: 4),
          Icon(Icons.local_fire_department, size: 16, color: isPlayer ? AppColors.onPrimary : AppColors.accent),
        ],
      ),
    );
  }
}
