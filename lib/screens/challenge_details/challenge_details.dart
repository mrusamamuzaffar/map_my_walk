import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_my_walk/app_routes.dart';
import '../tracking/tracking.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  final String challengeId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChallengeDetailsScreen({required this.challengeId});

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Details'),
          backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('challenges').doc(challengeId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text('Challenge details not found.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          var steps = data['steps'];
          var points = data['points'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(data['title'], style: Theme.of(context).textTheme.headline5),
                  const SizedBox(height: 10),
                  Text(data['description'], style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(height: 10),
                  Text('Points: ${data['points']}'),
                  const SizedBox(height: 10),
                  Text('Steps: ${data['steps']}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (currentUser != null) {
                        DocumentReference userDocRef = _firestore.collection('users').doc(currentUser.uid);
                        DocumentSnapshot userDoc = await userDocRef.get();
                        var userData = userDoc.data() as Map<String, dynamic>? ?? {};
                        Map<String, dynamic>? challenges = userData['participatedChallenges'] as Map<String, dynamic>? ?? {};

                        if (challenges.entries.any((e) => e.value['status'] == true && e.key != challengeId)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Already have active challenges')),
                          );
                        } else {
                          if (challenges.entries.any((element) => element.key == challengeId)) {
                            if(challenges[challengeId]['status'] == false){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Challenge Already Completed')),
                              );
                            }
                            else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackingScreen(steps: steps.toString(), points: points.toString()),
                                ),
                              );
                            }
                          } else {
                            userDocRef.set({
                              "participatedChallenges": {
                                challengeId: {
                                  "status": true,
                                  "steps": 0
                                }
                              }
                            }, SetOptions(merge: true)).then((_) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackingScreen(steps: steps.toString(), points: points.toString()),
                                ),
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error starting challenge: $error'))
                              );
                            });
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You are not logged in'))
                        );
                      }
                    },
                    child: const Text('Start Tracking'),
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
