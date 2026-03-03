import 'package:flutter/material.dart';
import 'package:chama/applyloanpage.dart';
import 'package:chama/chamameetingspage.dart';
import 'package:chama/contributesavingsscreen.dart';
import 'package:chama/leavechamapage.dart';
import 'package:chama/viewchamaprogresspage.dart';

class Dashboardscreen extends StatelessWidget {
  const Dashboardscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chama Dashboard"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0, // Add spacing between columns
              children: [
                _buildDashboardCard(
                  context,
                  title: 'Contribute Savings',
                  imagePath: 'assets/images/studentscollaboration.png', // Add your image path here
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContributeSavings()));
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Apply For Loan',
                  imagePath: 'assets/images/growth.png', // Add your image path here
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Applyloanpage()));
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'View Chama Progress',
                  imagePath: 'assets/images/analytics.png', // Add your image path here
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewChamaProgress()));
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Chama Meetings',
                  imagePath: 'assets/images/meeting.png', // Add your image path here
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Chamameetingspage()));
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Leave Chama',
                  imagePath: 'assets/images/logo.png', // Add your image path here
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaveChama()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required String title, required String imagePath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              Image.asset(imagePath, height: 50), // Display the image
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center align text
              ),
            ],
          ),
        ),
      ),
    );
  }
}