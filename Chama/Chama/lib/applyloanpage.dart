import 'package:flutter/material.dart';
class Applyloanpage extends StatelessWidget {
  const Applyloanpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar: AppBar(
        title: const Text('Apply for a Loan'),
        backgroundColor: Colors.blue,
    ),
    body:Padding(
         padding:const EdgeInsets.all(16.0),
         child: Center(
              child: Column(
                children: [
                 const Text('Enter the loan amount:',
                  style: TextStyle(fontSize: 18),),
                 const TextField(
                       decoration: InputDecoration(
                labelText: 'Amount'
           ),
               keyboardType: TextInputType.number,
    ),
                const SizedBox(height: 20,),
                 ElevatedButton(
                    onPressed: (){},
                    child: const Text('Apply'),
                ),
                 ],
          ),
        ),
    ),
    );

  }
}
