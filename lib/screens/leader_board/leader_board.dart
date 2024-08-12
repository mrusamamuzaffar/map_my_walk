import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String fullName;
  final int points;

  User(this.fullName, this.points);

  factory User.fromSnapshot(DocumentSnapshot doc) {
    return User(
      doc['fullName'],
      doc['points'],
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('points', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              List<User> users = snapshot.data!.docs
                  .map((doc) => User.fromSnapshot(doc))
                  .toList();
              return Column(
                children: [
                  _topThreeUsers(users),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Icon(Icons.person, size: 30),
                        title: Text(users[index].fullName),
                        trailing: Text('${users[index].points} points'),
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  Widget _topThreeUsers(List<User> users) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length < 3 ? users.length : 3,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 50, color: index == 0 ? Colors.yellow : Colors.grey),
                Text(users[index].fullName),
                Text('${users[index].points} points'),
              ],
            ),
          );
        },
      ),
    );
  }
}
