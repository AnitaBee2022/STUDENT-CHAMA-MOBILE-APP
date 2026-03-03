import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveChama extends StatelessWidget {
  const LeaveChama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Chama'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showConfirmationDialog(context);
          },
          child: const Text('Leave Chama'),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Leave'),
          content: const Text('Are you sure you want to leave the Chama?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _leaveChama(context);
              },
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
  }

  void _leaveChama(BuildContext context) async {
    // Assuming you have some way to identify the current user
    String userId = 'currentUserId'; // Replace with actual user ID

    try {
      // Update Firestore to set the user as inactive or delete them
      await FirebaseFirestore.instance.collection('members').doc(userId).update({
        'isActive': false, // Or delete the document if necessary
      });

      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully left the Chama.')),
      );

      // Navigate back or perform other actions
      Navigator.of(context).pop(); // Close the LeaveChama screen
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to leave Chama: $e')),
      );
    }
  }
}