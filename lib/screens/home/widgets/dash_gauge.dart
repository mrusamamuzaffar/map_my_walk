import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:map_my_walk/configs/app_typography_ext.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../configs/app_theme.dart';
import '../../../configs/app_typography.dart';
import '../../../configs/space.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashGauge extends StatefulWidget {
  final int? maxSteps;

  const DashGauge({Key? key, this.maxSteps}) : super(key: key);

  @override
  State<DashGauge> createState() => _DashGaugeState();
}

class _DashGaugeState extends State<DashGauge> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<int> _targetSteps;
  late int _currentSteps = 0;  //
  late int challengeSteps; // total steps required to complete challenge
  late int steps;
  @override
  void initState() {
    super.initState();
    _targetSteps = _fetchRecentChallengeSteps();
    _initializeCurrentSteps();
  }

  Future<void> _initializeCurrentSteps() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      Map<String, dynamic> participatedChallenges = userDoc['participatedChallenges'] as Map<String, dynamic>? ?? {};
      var activeChallengeEntry = participatedChallenges.entries.firstWhere(
            (entry) => entry.value['status'] == true,
        orElse: () => MapEntry('', {'steps': '0'}),
      );
      String challengeId = activeChallengeEntry.key;
      var _steps = participatedChallenges[challengeId];
      _currentSteps = _steps["steps"];
      print(":$_currentSteps");
    }
  }

  Future<int> _fetchRecentChallengeSteps() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return 0;

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    Map<String, dynamic> participatedChallenges = userDoc['participatedChallenges'] as Map<String, dynamic>? ?? {};

    var activeChallengeEntry = participatedChallenges.entries.firstWhere(
          (entry) => entry.value['status'] == true,
      orElse: () => MapEntry('', {'steps': '0'}),
    );

    if (activeChallengeEntry.key.isEmpty) {
      return 0;
    }

    String challengeId = activeChallengeEntry.key;
    DocumentSnapshot challengeDoc = await _firestore.collection('challenges').doc(challengeId).get();
    if (challengeDoc.exists) {
      challengeSteps = int.parse(challengeDoc['steps'].toString());
      return challengeSteps;
    }

    return 0;
  }

  final CircularSliderAppearance gaugeAppearance = CircularSliderAppearance(
    customWidths: CustomSliderWidths(
      progressBarWidth: 8,
      handlerSize: 10,
    ),
    size: 200,
    customColors: CustomSliderColors(
      progressBarColors: [
        AppTheme.c.primaryDark!,
        AppTheme.c.primary,
        AppTheme.c.accent,
        AppTheme.c.accent,
      ],
      dotColor: AppTheme.c.primary,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _targetSteps,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // if (!snapshot.hasData || snapshot.data == 0) {
        //   return Center(child: Text("No active challenges"));
        // }

        int maxSteps = snapshot.data!;

        return maxSteps == null || maxSteps == 0 ?const Center(
          child: Text(
            'No Active Challenge',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : IgnorePointer(
          child: SleekCircularSlider(
            innerWidget: (double percentage) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/footsteps.png",
                      height: 30,
                    ),
                    Countup(
                        begin: 0,
                        end: _currentSteps.toDouble(),
                        duration: const Duration(seconds: 1),
                        separator: ',',
                        style: AppText.h1b.cl(AppTheme.c.primary).copyWith(fontSize: 24)),
                    Space.y,
                    Image.asset(
                      "assets/trophy.png",
                      color: AppTheme.c.primaryDark!,
                      height: 20,
                    ),
                    Text(
                      maxSteps.toString(),
                      style: AppText.b2bm.cl(AppTheme.c.primaryDark!),
                    )
                  ],
                )),
            appearance: gaugeAppearance,
            min: 0,
            max: maxSteps.toDouble(),
            initialValue: _currentSteps.toDouble(),  // Use the local state for the initial value
          ),
        );
      },
    );
  }
}