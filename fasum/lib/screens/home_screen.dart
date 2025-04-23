import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasum/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} secs ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 60) {
      return '${diff.inHours} hrs ago';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection("post")
                //.orderBy("createdAt", descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount:
                posts.length, //menampilkan sebanyak data yang ada di posts
            itemBuilder: (context, index) {
              final data = posts[index].data();
              //final imageBase64 = data['image'] ?? '';
              final description = data['description'] ?? '';
              //final createAtStrs = data['createAt']; //kapan posting dibuat
              final fullname = data['fullname'] ?? 'Anonim';

              //Parse ke DateTime
              //final createAt = DateTime.parse(createAtStrs);
              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
