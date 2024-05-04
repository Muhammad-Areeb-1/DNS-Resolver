import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DNSResolveScreen extends StatefulWidget {
  const DNSResolveScreen({super.key});

  @override
  State<DNSResolveScreen> createState() => _DNSResolveScreenState();
}

class _DNSResolveScreenState extends State<DNSResolveScreen> {

  final firstoreRef = FirebaseFirestore.instance.collection('DNS DBMS').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('DNS DBMS');

  final _formKey = GlobalKey<FormState>();
  
  final inputController = TextEditingController();
  String responseText = '';
  String ipText = 'IP Address ';

  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Resolve Screen'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              dropdownColor: const Color.fromARGB(255, 138, 156, 255),
              borderRadius: BorderRadius.circular(4),
              value: 'Resolve Domain Name', // Set the default value to the current screen
              onChanged: (String? newValue) {
                if (newValue == 'Resolve IP Address') {
                  Navigator.pushReplacementNamed(context, '/ip_resolve');
                } else if (newValue == 'Resolve Domain Name') {
                  // Navigator.pushReplacementNamed(context, '/dns_resolve');
                }
              },
              items: <String>['Resolve Domain Name', 'Resolve IP Address'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: inputController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Domain Name',
                      prefixIcon: Icon(Icons.domain),
                      border: OutlineInputBorder()
                    ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a domain name!';
                    }
                    RegExp domainRegex = RegExp(
                      r'^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$',
                      caseSensitive: false,
                    );
              
                    // Checks if input matches the above DN format
                    if (!domainRegex.hasMatch(value)) {
                      return 'Invalid domain name format';
                    }
                    
                    return null;
                  }
                ),
              ),
            ),
            const SizedBox(height: 25,),
            Card(
              color: Colors.indigoAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              elevation: 4,

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white
                          ),
                          text: ipText,
                        ),
                      ),
                      SelectableText(
                        responseText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: (){
                setState(() async {
                  _searchAndUpdateState();
                });
              },
              child: const Text('Resolve')
            ),
          ],
        ),
      ),
    );
  }

  void _searchAndUpdateState() async {
    if (_formKey.currentState!.validate()) {
      QuerySnapshot querySnapshot = await ref
        .where('domain_name', isEqualTo: inputController.text.toString())
        .get();
      setState(() {
        if (querySnapshot.docs.isNotEmpty) {
          ipText = 'IP Address: ';
          responseText = querySnapshot.docs[0]['ip_address'];
        } else {
          ipText = 'IP Address: ';
          responseText = 'No data found';
        }
      });
    }
  }
}