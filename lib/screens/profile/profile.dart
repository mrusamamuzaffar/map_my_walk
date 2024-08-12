import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile Page'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: const Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching user details: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('User details not found'));
                }
                var userDoc = snapshot.data!;
                var fullName = userDoc['fullName'] as String;
                var imageUrl = userDoc['imageUrl'] as String? ?? 'default_image_url';
                var email = userDoc['email'] as String;
                var age = userDoc['age'] as int;
                var gender = userDoc['gender'] as String;
                var height = userDoc['height'].toString();
                var weight = userDoc['weight'].toString();
                var points = userDoc['points'].toString();
                Map<String, dynamic> participatedChallenges = userDoc['participatedChallenges'] as Map<String, dynamic>? ?? {};

                return Column(

                  children: [
                    SizedBox(height: 30),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/4721/4721040.png"),
                    ),
                    Text(fullName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(email, style: TextStyle(fontSize: 16, color: Colors.grey)),
                    UserInfoRow(title: 'Age', value: '$age'),
                    UserInfoRow(title: 'Gender', value: gender),
                    UserInfoRow(title: 'Height', value: '$height ft'),
                    UserInfoRow(title: 'Weight', value: '$weight kg'),
                    UserInfoRow(title: 'Points', value: '$points pts'),
                    SizedBox(height: 20),
                    Text('Participated Challenges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: participatedChallenges.keys.length,
                      itemBuilder: (context, index) {
                        String challengeId = participatedChallenges.keys.elementAt(index);
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('challenges').doc(challengeId).get(),
                          builder: (context, challengeSnapshot) {
                            if (challengeSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (challengeSnapshot.hasError) {
                              return Text('Error loading challenge');
                            }
                            if (!challengeSnapshot.hasData) {
                              return Text('Challenge not found');
                            }
                            var challengeData = challengeSnapshot.data!.data() as Map<String, dynamic>;
                            return ChallengeCard(data: challengeData);
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const UserInfoRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ChallengeCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        title: Text(data['title'] ?? 'No Title'),
        subtitle: Text(data['description'] ?? 'No Description'),
        trailing: Text('${data['points'] ?? 0} pts'),
      ),
    );
  }
}
