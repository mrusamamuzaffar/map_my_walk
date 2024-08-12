import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../challenge_details/challenge_details.dart';

class ChallengesScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Challenges'),
          backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('challenges').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No challenges found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var challenge = snapshot.data?.docs[index];
              return ListTile(
                title: Text(challenge?['title']),
                subtitle: Text(challenge?['description']),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeDetailsScreen(challengeId: challenge!.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
