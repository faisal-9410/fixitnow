// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/team_dashboard_screen.dart';
import 'screens/team_notifications_screen.dart';
import 'screens/team_complaint_details_screen.dart';
import 'screens/team_announcement_screen.dart';
import 'screens/announcement_home_screen.dart';
import 'screens/create_announcement_screen.dart';
import 'screens/announcement_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixItNow',
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: false),
      home: const LoginScreen(),
      routes: {
        '/teamDashboard': (context) {
          final teamName = ModalRoute.of(context)!.settings.arguments as String;
          return TeamDashboardScreen(teamName: teamName);
        },
        '/teamNotifications': (context) => const TeamNotificationsScreen(),
        '/teamComplaintDetails': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return TeamComplaintDetailsScreen(
            data: args['data'],
            docId: args['docId'],
          );
        },
        '/teamAnnouncements': (context) {
          final teamName = ModalRoute.of(context)!.settings.arguments as String;
          return TeamAnnouncementScreen(teamName: teamName);
        },
        '/announcementHome': (context) => const AnnouncementHomeScreen(),
        '/createAnnouncement': (context) => const CreateAnnouncementScreen(),
        '/postedAnnouncements': (context) => const AnnouncementScreen(),
      },
    );
  }
}
