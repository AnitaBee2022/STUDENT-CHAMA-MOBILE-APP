import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewChamaProgress extends StatelessWidget {
  const ViewChamaProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chama Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Contributions Section
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('chama').doc('progress').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No data found.'));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final totalContributions = data['total_contributions'] ?? 0;
                final targetAmount = data['target_amount'] ?? 10000; // Example target amount

                return Column(
                  children: [
                    Text(
                      'Total Contributions: \$${totalContributions.toString()}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: totalContributions / targetAmount,
                      minHeight: 20,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Target Amount: \$${targetAmount.toString()}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Members Contributions Section
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('members').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  final members = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(member['name']),
                          subtitle: Text('Contribution: \$${member['contribution']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}