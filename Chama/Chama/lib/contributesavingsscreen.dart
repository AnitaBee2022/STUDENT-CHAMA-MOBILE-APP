import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set M-Pesa API credentials
  MpesaFlutterPlugin.setConsumerKey('HiQ7yj8sDctNUBZgnc5GMkOdUCZAokHOmAgfPldtnEfETvAS');
  MpesaFlutterPlugin.setConsumerSecret('jYiCIiSI9UMFrHH8zWSb7IIDCYm37u7htfuhADe1dlw11DdyocWHG2tK3ap56AGk');

  runApp(const ContributeSavings());
}

class ContributeSavings extends StatelessWidget {
  const ContributeSavings({super.key});

  // Function to initiate M-Pesa STK Push
  Future<dynamic> initiateTransaction({
    required double amount,
    required String phone,
  }) async {
    try {
      dynamic transactionInitialization = await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: '174379', // Replace with your store number
        transactionType: TransactionType.CustomerPayBillOnline,
        amount: amount,
        partyA: phone,
        partyB: '174379', // Replace with your PayBill number
        callBackURL: Uri(
          scheme: "https",
          host: "us-central1-nigel-da5dl.cloudfunctions.net", // Replace with your backend callback URL
          path: "paymentCallback",
        ),
        accountReference: 'ContributeSavings',
        phoneNumber: phone,
        baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
        transactionDesc: 'Savings Contribution',
        passKey: 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919', // Replace with your M-Pesa passkey
      );

      // Handle success
      print('Transaction Success: $transactionInitialization');
      return transactionInitialization;
    } catch (e) {
      // Handle error
      print('Transaction Error: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController phoneController = TextEditingController(); // For user to input phone number

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contribute Savings'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter the amount to contribute:',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount to contribute',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your phone number:',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Validate user input
                    if (amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an amount.')),
                      );
                      return;
                    }

                    if (phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your phone number.')),
                      );
                      return;
                    }

                    double amount = double.tryParse(amountController.text) ?? 0.0;
                    String phone = phoneController.text;

                    if (amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter a valid amount greater than 0.')),
                      );
                      return;
                    }

                    // Initiate the M-Pesa transaction
                    try {
                      dynamic result = await initiateTransaction(amount: amount, phone: phone);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transaction Successful: $result')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transaction Failed: $e')),
                      );
                    }
                  },
                  child: const Text('Contribute'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
