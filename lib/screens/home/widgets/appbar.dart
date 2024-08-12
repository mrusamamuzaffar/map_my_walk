import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:map_my_walk/configs/app_typography_ext.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_theme.dart';
import '../../../configs/app_typography.dart';
import '../../../configs/space.dart';
import '../../../painters/notification_bell.dart';
import '../../../painters/stats.dart';
import '../../../painters/trophy.dart';
import '../../../providers/app_provider.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key}) : super(key: key);

  Future<int> getTotalChallenges() async {
    final collection = FirebaseFirestore.instance.collection('challenges');
    final snapshot = await collection.get();
    return snapshot.size; // Returns the count of documents in the collection
  }


  Future<int> getUserRank(String userId) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final currentUserDoc = await usersCollection.doc(userId).get();
    final currentUserPoints = currentUserDoc.data()?['points'] ?? 0;
    final querySnapshot = await usersCollection.where('points', isGreaterThan: currentUserPoints).get();
    return querySnapshot.size + 1; // Rank is one more than the number of users with more points
  }

  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid; // This returns the user ID of the currently signed-in user
  }



  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Padding(
      padding: Space.v,
      child: Row(
        children: [
          Space.x,
          IconButton(
            onPressed: () => app.toggleDrawer(),
            icon: const Icon(Icons.menu),
          ),
          // Other widgets...
          Space.x,
          DelayedDisplay(
            delay: const Duration(milliseconds: 250),
            slidingBeginOffset: const Offset(-10, 0),
            child: CustomPaint(
              painter: StatsPainter(),
              size: const Size(
                16,
                16,
              ),
            ),
          ),
          Space.x,
          FutureBuilder(
            future: getTotalChallenges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return Text(
                  "${snapshot.data}",
                  style: AppText.h3bm.cl(AppTheme.c.primaryDark!),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Space.x,
          DelayedDisplay(
            delay: const Duration(milliseconds: 150),
            slidingBeginOffset: const Offset(-10, 0),
            child: CustomPaint(
              painter: TrophyPainter(),
              size: const Size(
                16,
                16,
              ),
            ),
          ),
          Space.x,
          // Assuming userId is available from some state management or passed as an argument
          FutureBuilder(
            future: getUserRank(getCurrentUserId().toString()), // Replace "userId" with actual user id
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return Text(
                  "${snapshot.data} position", // Customize based on the rank
                  style: AppText.h3bm.cl(AppTheme.c.primaryDark!),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          const Expanded(child: SizedBox(width: 6)),
          // Other widgets...
        ],
      ),
    );
  }

}
