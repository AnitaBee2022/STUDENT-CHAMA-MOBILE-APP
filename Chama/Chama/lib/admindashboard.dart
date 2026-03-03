import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admindashboard extends StatefulWidget {
  Admindashboard({super.key});

  @override
  _AdmindashboardState createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
  final nameController = TextEditingController();
  final studentidController = TextEditingController();
  final meetingLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddStudentCard(),
              const SizedBox(height: 20),
              _buildManageStudentsButton(context),
              const SizedBox(height: 20),
              _buildMeetingLinksCard(),
              const SizedBox(height: 20),
              _buildLoanApprovalCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddStudentCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Student', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studentidController,
              decoration: const InputDecoration(labelText: 'Student ID', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStudent,
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageStudentsButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageStudentsPage()),
        );
      },
      child: const Text('Manage Students'),
    );
  }

  Widget _buildMeetingLinksCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage Meeting Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: meetingLinkController,
              decoration: const InputDecoration(labelText: 'Meeting Link', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _addMeetingLink(meetingLinkController.text);
              },
              child: const Text('Add Meeting Link'),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('meetings').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final meetings = snapshot.data!.docs;
                if (meetings.isEmpty) {
                  return const Text('No meeting links found.');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: meetings.map((meeting) {
                    return ListTile(
                      title: Text(meeting['link']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteMeetingLink(meeting.id);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanApprovalCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Loan Approval Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPendingLoans()));
              },
              child: const Text('View Pending Loans'),
            ),
          ],
        ),
      ),
    );
  }

  void _addStudent() {
    CollectionReference students = FirebaseFirestore.instance.collection('students');
    students.add({
      'Name': nameController.text,
      'Student_Id': studentidController.text,
    }).then((value) {
      print('Student added.');
      nameController.clear();
      studentidController.clear();
    }).catchError((error) {
      print("Failed to add student: $error");
    });
  }

  void _addMeetingLink(String link) async {
    if (link.isNotEmpty) {
      await FirebaseFirestore.instance.collection('meetings').add({
        'link': link,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Meeting link added.");
      meetingLinkController.clear();
    } else {
      print("Please enter a valid link.");
    }
  }

  void _deleteMeetingLink(String id) async {
    await FirebaseFirestore.instance.collection('meetings').doc(id).delete().then((_) {
      print("Meeting link deleted.");
    }).catchError((error) {
      print("Failed to delete meeting link: $error");
    });
  }
}

class ManageStudentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Students')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data!.docs;
          if (students.isEmpty) {
            return const Center(child: Text('No students found.'));
          }
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student['Name']),
                subtitle: Text('ID: ${student['Student_Id']}'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetailsPage(
                        studentId: student['Student_Id'],
                        studentName: student['Name'],
                      ),
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

class StudentDetailsPage extends StatelessWidget {
  final String studentId;
  final String studentName;

  const StudentDetailsPage({required this.studentId, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$studentName\'s Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('loans')
            .where('Student_Id', isEqualTo: studentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final loans = snapshot.data!.docs;
          if (loans.isEmpty) {
            return Center(child: Text('No pending loans for $studentName.'));
          }
          return ListView.builder(
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return ListTile(
                title: Text('Loan Amount: ${loan['Amount']}'),
                subtitle: Text('Status: ${loan['Status']}'),
              );
            },
          );
        },
      ),
    );
  }
}

class ViewPendingLoans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Loans')),
      body: Center(child: Text('Pending loan details will be displayed here.')),
    );
  }
}
