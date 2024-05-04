import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class IPResolveScreen extends StatefulWidget {
  const IPResolveScreen({super.key});

  @override
  State<IPResolveScreen> createState() => _IPResolveScreenState();
}

class _IPResolveScreenState extends State<IPResolveScreen> {

  final firstoreRef = FirebaseFirestore.instance.collection('DNS DBMS').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('DNS DBMS');

  final _formKey = GlobalKey<FormState>();
  
  final inputController = TextEditingController();
  String responseText = '';
  String dnsText = 'Domain Name ';

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
            // Dropdown button to switch between screens
            DropdownButton<String>(
              dropdownColor: const Color.fromARGB(255, 138, 156, 255),
              borderRadius: BorderRadius.circular(4),
              value: 'Resolve IP Address', // Set the default value to the current screen
              onChanged: (String? newValue) {
                if (newValue == 'Resolve IP Address') {
                  // Navigator.pushReplacementNamed(context, '/ip_resolve');
                } else if (newValue == 'Resolve Domain Name') {
                  Navigator.pushReplacementNamed(context, '/dns_resolve');
                }
              },
              items: <String>['Resolve IP Address', 'Resolve Domain Name'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 40
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: inputController,
                  decoration: const InputDecoration(
                    hintText: 'Enter IP Address',
                    prefixIcon: Icon(Icons.domain),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter an ip address!';
                    }
                    RegExp ipRegExp = RegExp(
                      r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$',
                      caseSensitive: false,
                    );
                    // Checks if input matches the above IP format
                    if (!ipRegExp.hasMatch(value)) {
                      return 'Invalid IP address format!';
                    }
                    // Extracting individual segments from the IP address
                    List<int> segments = ipRegExp
                        .firstMatch(value)!
                        .groups([1, 2, 3, 4])
                        .map((segment) => int.parse(segment!))
                        .toList();
                    // Check if each segment is between 0 and 255
                    if (segments.any((segment) => segment < 0 || segment > 255)) {
                      return 'Invalid IP address!';
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
                            fontSize: 17,
                            color: Colors.white
                          ),
                          text: dnsText,
                        ),
                      ),
                      SelectableText(
                        responseText,
                        style: const TextStyle(
                          fontSize: 17,
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
        .where('ip_address', isEqualTo: inputController.text.toString())
        .get();
      setState(() {
        if (querySnapshot.docs.isNotEmpty) {
          dnsText = 'Domain Name: ';
          responseText = querySnapshot.docs[0]['domain_name'];
        } else {
          dnsText = 'Domain Name: ';
          responseText = 'No data found';
        }
      });
    }
  }
}