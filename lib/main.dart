import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// --------------------------------------------------
// APP COLOURS AND API
// --------------------------------------------------

const Color primaryPurple = Color(0xFF7C3AED);
const Color homeBackground = Color(0xFFEDE9FE);
const Color activityBackground = Color(0xFFDCFCE7);
const Color profileBackground = Color(0xFFFFEDD5);
const Color settingsBackground = Color(0xFFDBEAFE);

const String apiUrl = 'http://192.168.100.169:8000';

// --------------------------------------------------
// PAGE WATERMARK
// --------------------------------------------------

class PageWatermark extends StatelessWidget {
  final Widget child;

  const PageWatermark({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final watermarkColor = Theme.of(context).colorScheme.primary
        .withValues(alpha: 0.07);

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: Center(
            child: Transform.rotate(
              angle: -0.5,
              child: Text(
                'FRIDAY WEEKEND VIBE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: watermarkColor,
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// --------------------------------------------------
// ACTIVITY MODEL
// --------------------------------------------------

class ActivityItem {
  final String name;
  final int duration;
  final String description;
  final String imageUrl;

  const ActivityItem({
    required this.name,
    required this.duration,
    required this.description,
    required this.imageUrl,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      name: json['name']?.toString() ?? 'Activity',
      duration: int.tryParse('${json['duration']}') ?? 60,
      description: 'A great activity to add to your routine.',
      imageUrl: activityImages[0],
    );
  }
}

class PlannedActivity {
  final ActivityItem activity;
  final String period;

  const PlannedActivity({required this.activity, required this.period});
}

// --------------------------------------------------
// ACTIVITY PICTURES
// --------------------------------------------------

const List<String> activityImages = [
  'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=700',
  'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=700',
  'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=700',
  'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=700',
  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=700',
  'https://images.unsplash.com/photo-1546483875-ad9014c88eba?w=700',
  'https://images.unsplash.com/photo-1517963879433-6ad2b056d712?w=700',
  'https://images.unsplash.com/photo-1599058917212-d750089bc07a?w=700',
];

ActivityItem makeActivity(
  String name,
  int seconds,
  String description,
  int imageIndex,
) {
  return ActivityItem(
    name: name,
    duration: seconds,
    description: description,
    imageUrl: activityImages[imageIndex % activityImages.length],
  );
}

// --------------------------------------------------
// STARTER ROUTINES
// --------------------------------------------------

final List<ActivityItem> morningStarter = [
  makeActivity(
    'Morning Stretching',
    300,
    'Wake up your muscles with gentle stretches.',
    1,
  ),
  makeActivity('Jogging', 600, 'Start the day with a comfortable jog.', 0),
  makeActivity(
    'Push-ups',
    60,
    'Build upper-body strength at your own pace.',
    2,
  ),
  makeActivity('Yoga', 600, 'Improve flexibility and focus on breathing.', 1),
  makeActivity('Jumping Jacks', 60, 'Warm up your body with light cardio.', 3),
  makeActivity(
    'Plank',
    45,
    'Practise a steady core-strengthening position.',
    6,
  ),
];

final List<ActivityItem> afternoonStarter = [
  makeActivity(
    'Brisk Walking',
    900,
    'Take a refreshing walk and stay active.',
    0,
  ),
  makeActivity('Cycling', 1200, 'Enjoy a ride at a comfortable pace.', 4),
  makeActivity(
    'Squats',
    90,
    'Strengthen your legs with controlled movements.',
    2,
  ),
  makeActivity(
    'Dancing',
    300,
    'Move to your favourite music for fun cardio.',
    5,
  ),
  makeActivity(
    'Skipping Rope',
    120,
    'Try a short skipping session if you have a rope.',
    3,
  ),
  makeActivity('Lunges', 90, 'Practise controlled lunges on each leg.', 7),
];

final List<ActivityItem> eveningStarter = [
  makeActivity('Gentle Yoga', 600, 'Relax with comfortable yoga movements.', 1),
  makeActivity(
    'Evening Stretching',
    300,
    'Release tension with gentle stretches.',
    3,
  ),
  makeActivity('Leisurely Walk', 900, 'Wind down with a peaceful walk.', 0),
  makeActivity('Deep Breathing', 180, 'Sit comfortably and breathe slowly.', 1),
  makeActivity(
    'Light Bodyweight Exercises',
    300,
    'Try a gentle, comfortable movement session.',
    2,
  ),
  makeActivity(
    'Relaxation Time',
    600,
    'Make time to unwind after a busy day.',
    5,
  ),
];

// --------------------------------------------------
// MAIN APP
// --------------------------------------------------

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friday Weekend Vibe',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: MainPage(
        isDarkMode: isDarkMode,
        notificationsEnabled: notificationsEnabled,
        onDarkModeChanged: (value) {
          setState(() => isDarkMode = value);
        },
        onNotificationsChanged: (value) {
          setState(() => notificationsEnabled = value);
        },
      ),
    );
  }
}

// --------------------------------------------------
// MAIN PAGE AND NAVIGATION
// --------------------------------------------------

class MainPage extends StatefulWidget {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onNotificationsChanged;

  const MainPage({
    super.key,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.onDarkModeChanged,
    required this.onNotificationsChanged,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  String profileName = 'Friday User';
  String profileEmail = 'user@example.com';

  bool isLoadingActivities = false;
  String backendMessage = '';

  final List<ActivityItem> backendActivities = [];
  final List<ActivityItem> morningActivities = List.of(morningStarter);
  final List<ActivityItem> afternoonActivities = List.of(afternoonStarter);
  final List<ActivityItem> eveningActivities = List.of(eveningStarter);

  @override
  void initState() {
    super.initState();
    loadBackendActivities();
  }

  int get totalActivities =>
      morningActivities.length +
      afternoonActivities.length +
      eveningActivities.length +
      backendActivities.length;

  // --------------------------------------------------
  // LOAD ACTIVITIES FROM PYTHON FASTAPI
  // --------------------------------------------------

  Future<void> loadBackendActivities() async {
    if (mounted) {
      setState(() {
        isLoadingActivities = true;
        backendMessage = '';
      });
    }

    try {
      final response = await http
          .get(Uri.parse('$apiUrl/activities'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Server returned ${response.statusCode}');
      }

      final dynamic decoded = jsonDecode(response.body);
      List<dynamic> activityList;

      if (decoded is List) {
        activityList = decoded;
      } else if (decoded is Map<String, dynamic> &&
          decoded['activities'] is List) {
        activityList = decoded['activities'] as List<dynamic>;
      } else {
        throw Exception('Unexpected activities response');
      }

      final loaded = activityList
          .whereType<Map<String, dynamic>>()
          .map(ActivityItem.fromJson)
          .toList();

      if (!mounted) return;

      setState(() {
        backendActivities
          ..clear()
          ..addAll(loaded);

        backendMessage = 'Python activities loaded successfully.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        backendMessage = 'Python is offline. Your daily routines still work.';
      });
    } finally {
      if (mounted) {
        setState(() => isLoadingActivities = false);
      }
    }
  }

  // --------------------------------------------------
  // ADD ACTIVITY TO A SELECTED ROUTINE
  // --------------------------------------------------

  Future<void> addActivity() async {
    final PlannedActivity? result = await showDialog<PlannedActivity>(
      context: context,
      builder: (_) => const AddActivityDialog(),
    );

    if (result == null || !mounted) return;

    setState(() {
      switch (result.period) {
        case 'Morning':
          morningActivities.add(result.activity);
          break;

        case 'Afternoon':
          afternoonActivities.add(result.activity);
          break;

        case 'Evening':
          eveningActivities.add(result.activity);
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${result.activity.name} added to ${result.period} Routine!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --------------------------------------------------
  // EDIT PROFILE
  // --------------------------------------------------

  Future<void> editProfile() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => EditProfileDialog(
        initialName: profileName,
        initialEmail: profileEmail,
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      profileName = result['name'] ?? profileName;
      profileEmail = result['email'] ?? profileEmail;
    });
  }

  Color get currentBackground {
    if (widget.isDarkMode) {
      return Theme.of(context).colorScheme.surface;
    }

    return switch (selectedIndex) {
      0 => homeBackground,
      1 => activityBackground,
      2 => profileBackground,
      3 => settingsBackground,
      _ => homeBackground,
    };
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PageWatermark(
        child: HomePage(
          profileName: profileName,
          totalActivities: totalActivities,
          morningCount: morningActivities.length,
          afternoonCount: afternoonActivities.length,
          eveningCount: eveningActivities.length,
          onActivityTap: () => setState(() => selectedIndex = 1),
          onProfileTap: () => setState(() => selectedIndex = 2),
        ),
      ),
      PageWatermark(
        child: ActivityPage(
          morningActivities: morningActivities,
          afternoonActivities: afternoonActivities,
          eveningActivities: eveningActivities,
          backendActivities: backendActivities,
          isLoading: isLoadingActivities,
          backendMessage: backendMessage,
          onRefresh: loadBackendActivities,
          onAddActivity: addActivity,
        ),
      ),
      PageWatermark(
        child: ProfilePage(
          profileName: profileName,
          profileEmail: profileEmail,
          totalActivities: totalActivities,
          morningCount: morningActivities.length,
          afternoonCount: afternoonActivities.length,
          eveningCount: eveningActivities.length,
          onEditProfile: editProfile,
        ),
      ),
      PageWatermark(
        child: SettingsPage(
          isDarkMode: widget.isDarkMode,
          notificationsEnabled: widget.notificationsEnabled,
          onDarkModeChanged: widget.onDarkModeChanged,
          onNotificationsChanged: widget.onNotificationsChanged,
          onRefreshActivities: loadBackendActivities,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FRIDAY WEEKEND VIBE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Python activities',
            onPressed: isLoadingActivities ? null : loadBackendActivities,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: currentBackground,
        child: IndexedStack(index: selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// HOME PAGE
// --------------------------------------------------

class HomePage extends StatelessWidget {
  final String profileName;
  final int totalActivities;
  final int morningCount;
  final int afternoonCount;
  final int eveningCount;
  final VoidCallback onActivityTap;
  final VoidCallback onProfileTap;

  const HomePage({
    super.key,
    required this.profileName,
    required this.totalActivities,
    required this.morningCount,
    required this.afternoonCount,
    required this.eveningCount,
    required this.onActivityTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = profileName.trim().isEmpty ? 'there' : profileName.trim();

    return ListView(
      key: const PageStorageKey('home-page'),
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.weekend, color: Colors.white, size: 42),
              const SizedBox(height: 16),
              Text(
                'Hello, $name!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Build a better day, one activity at a time.',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onActivityTap,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryPurple,
                ),
                child: const Text('View My Routines'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Your Activity Plan',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RoutineSummary(
                title: 'Morning',
                count: morningCount,
                icon: Icons.wb_twilight,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _RoutineSummary(
                title: 'Afternoon',
                count: afternoonCount,
                icon: Icons.wb_sunny,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _RoutineSummary(
                title: 'Evening',
                count: eveningCount,
                icon: Icons.nights_stay,
                color: primaryPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: homeBackground,
              child: Icon(Icons.fitness_center, color: primaryPurple),
            ),
            title: const Text('Total activities'),
            subtitle: const Text('Across your three routines'),
            trailing: Text(
              '$totalActivities',
              style: const TextStyle(
                color: primaryPurple,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: profileBackground,
              child: Icon(Icons.person, color: primaryPurple),
            ),
            title: const Text('Your profile'),
            subtitle: const Text('View or update your details'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onProfileTap,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// ROUTINE SUMMARY CARD
// --------------------------------------------------

class _RoutineSummary extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _RoutineSummary({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 27),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// ACTIVITY PAGE
// --------------------------------------------------

class ActivityPage extends StatelessWidget {
  final List<ActivityItem> morningActivities;
  final List<ActivityItem> afternoonActivities;
  final List<ActivityItem> eveningActivities;
  final List<ActivityItem> backendActivities;
  final bool isLoading;
  final String backendMessage;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onAddActivity;

  const ActivityPage({
    super.key,
    required this.morningActivities,
    required this.afternoonActivities,
    required this.eveningActivities,
    required this.backendActivities,
    required this.isLoading,
    required this.backendMessage,
    required this.onRefresh,
    required this.onAddActivity,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('activity-page'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        Text(
          'My Daily Routines',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text('Choose an activity or add your own to any routine.'),
        const SizedBox(height: 16),
        _RoutineSection(
          title: 'Morning Routine',
          subtitle: 'Start your day with energy',
          icon: Icons.wb_twilight,
          accent: Colors.orange,
          activities: morningActivities,
        ),
        _RoutineSection(
          title: 'Afternoon Routine',
          subtitle: 'Keep moving through the day',
          icon: Icons.wb_sunny,
          accent: Colors.deepOrange,
          activities: afternoonActivities,
        ),
        _RoutineSection(
          title: 'Evening Routine',
          subtitle: 'Slow down and relax',
          icon: Icons.nights_stay,
          accent: primaryPurple,
          activities: eveningActivities,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: onAddActivity,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Add Activity to a Routine'),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Python Activities',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: isLoading ? null : onRefresh,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        Text(
          backendMessage.isEmpty
              ? 'Activities loaded from your FastAPI backend.'
              : backendMessage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (backendActivities.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No Python activities are available right now. '
                'Your daily routines are still available above.',
              ),
            ),
          )
        else
          ...backendActivities.indexed.map(
            (entry) => ActivityPictureCard(
              activity: entry.$2,
              index: entry.$1,
              showDuration: true,
            ),
          ),
      ],
    );
  }
}

// --------------------------------------------------
// MORNING / AFTERNOON / EVENING SECTIONS
// --------------------------------------------------

class _RoutineSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<ActivityItem> activities;

  const _RoutineSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: accent.withValues(alpha: 0.12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: accent.withValues(alpha: 0.16),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(subtitle),
                    ],
                  ),
                ),
                Text(
                  '${activities.length}',
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          if (activities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No activities yet. Add one to this routine.'),
            )
          else
            ...activities.indexed.map(
              (entry) => ActivityPictureCard(
                activity: entry.$2,
                index: entry.$1,
                showDuration: true,
                compact: true,
              ),
            ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// ACTIVITY CARD WITH PICTURE
// --------------------------------------------------

class ActivityPictureCard extends StatelessWidget {
  final ActivityItem activity;
  final int index;
  final bool showDuration;
  final bool compact;

  const ActivityPictureCard({
    super.key,
    required this.activity,
    required this.index,
    this.showDuration = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: compact
          ? const EdgeInsets.fromLTRB(12, 6, 12, 8)
          : const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: compact ? 145 : 175,
            width: double.infinity,
            child: Image.network(
              activity.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;

                return Container(
                  color: homeBackground,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: homeBackground,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.fitness_center,
                    color: primaryPurple,
                    size: 48,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  activity.description,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                if (showDuration) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: primaryPurple,
                      ),
                      const SizedBox(width: 6),
                      Text('${activity.duration} seconds'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// PROFILE PAGE
// --------------------------------------------------

class ProfilePage extends StatelessWidget {
  final String profileName;
  final String profileEmail;
  final int totalActivities;
  final int morningCount;
  final int afternoonCount;
  final int eveningCount;
  final VoidCallback onEditProfile;

  const ProfilePage({
    super.key,
    required this.profileName,
    required this.profileEmail,
    required this.totalActivities,
    required this.morningCount,
    required this.afternoonCount,
    required this.eveningCount,
    required this.onEditProfile,
  });

  String get initials {
    final parts = profileName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: primaryPurple,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profileName,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(profileEmail),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onEditProfile,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _RoutineSummary(
          title: 'Morning activities',
          count: morningCount,
          icon: Icons.wb_twilight,
          color: Colors.orange,
        ),
        _RoutineSummary(
          title: 'Afternoon activities',
          count: afternoonCount,
          icon: Icons.wb_sunny,
          color: Colors.deepOrange,
        ),
        _RoutineSummary(
          title: 'Evening activities',
          count: eveningCount,
          icon: Icons.nights_stay,
          color: primaryPurple,
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.fitness_center, color: primaryPurple),
            title: const Text('Total activities'),
            trailing: Text(
              '$totalActivities',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// SETTINGS PAGE
// --------------------------------------------------

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final Future<void> Function() onRefreshActivities;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.onDarkModeChanged,
    required this.onNotificationsChanged,
    required this.onRefreshActivities,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Customise your app experience.'),
        const SizedBox(height: 24),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            subtitle: const Text('Change the appearance of the app'),
            value: isDarkMode,
            onChanged: onDarkModeChanged,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Change your notification preference'),
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.cloud_sync_outlined,
              color: primaryPurple,
            ),
            title: const Text('Refresh Python Activities'),
            subtitle: const Text('Reload activities from FastAPI'),
            trailing: const Icon(Icons.refresh),
            onTap: () async {
              await onRefreshActivities();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Python activity refresh completed.'),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'FRIDAY WEEKEND VIBE',
            style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// ADD ACTIVITY DIALOG
// --------------------------------------------------

class AddActivityDialog extends StatefulWidget {
  const AddActivityDialog({super.key});

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final nameController = TextEditingController();
  final durationController = TextEditingController(text: '60');
  final descriptionController = TextEditingController();

  String selectedPeriod = 'Morning';
  int selectedImage = 0;
  String? errorMessage;

  @override
  void dispose() {
    nameController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveActivity() {
    final name = nameController.text.trim();
    final duration = int.tryParse(durationController.text.trim());
    final description = descriptionController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorMessage = 'Please enter an activity name.';
      });
      return;
    }

    if (duration == null || duration <= 0) {
      setState(() {
        errorMessage = 'Enter a duration greater than zero.';
      });
      return;
    }

    final activity = ActivityItem(
      name: name,
      duration: duration,
      description: description.isEmpty
          ? 'Your own activity. Keep moving at your own pace.'
          : description,
      imageUrl: activityImages[selectedImage],
    );

    Navigator.of(context)
        .pop(PlannedActivity(activity: activity, period: selectedPeriod));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Your Routine'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Activity name',
                hintText: 'e.g. Cycling',
                prefixIcon: Icon(Icons.fitness_center),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration in seconds',
                prefixIcon: Icon(Icons.timer_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: selectedPeriod,
              decoration: const InputDecoration(
                labelText: 'Add to routine',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Morning', child: Text('🌅 Morning')),
                DropdownMenuItem(
                  value: 'Afternoon',
                  child: Text('☀️ Afternoon'),
                ),
                DropdownMenuItem(value: 'Evening', child: Text('🌙 Evening')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedPeriod = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose a picture',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 74,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: activityImages.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedImage = index);
                    },
                    child: Container(
                      width: 76,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedImage == index
                              ? primaryPurple
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        activityImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: homeBackground,
                          child: Icon(Icons.fitness_center),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: saveActivity,
          icon: const Icon(Icons.add),
          label: const Text('Add Activity'),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// EDIT PROFILE DIALOG
// --------------------------------------------------

class EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const EditProfileDialog({
    super.key,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty) {
      setState(() => errorMessage = 'Please enter your name.');
      return;
    }

    if (!email.contains('@')) {
      setState(() => errorMessage = 'Please enter a valid email address.');
      return;
    }

    Navigator.of(context).pop({'name': name, 'email': email});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: saveProfile, child: const Text('Save Changes')),
      ],
    );
  }
}
