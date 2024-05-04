import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/round_button.dart';
import '../utils/utils.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final firestoreRef = FirebaseFirestore.instance.collection('DNS DBMS');

  final _formKey = GlobalKey<FormState>();

  String dnsInput = '';
  String ipInput = '';
  
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              TextFormField(
                decoration: const InputDecoration(
                  hintText: "www.abc.xyz",
                  labelText: 'Enter domain name',
                  border: OutlineInputBorder()
                ),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a domain name';
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
                },

                onSaved: (value) {
                  dnsInput = value!;
                },
              ),

              const SizedBox(
                height: 30,
              ),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "123.123.123.123",
                  labelText: 'Enter IP address',
                  border: OutlineInputBorder()
                ),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an IP address';
                  }

                  RegExp ipRegExp = RegExp(
                    r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$',
                    caseSensitive: false,
                  );

                  // Check if input matches the above IP format
                  if (!ipRegExp.hasMatch(value)) {
                    return 'Invalid IP address format!';
                  }

                  // Making individual segments from the IP address
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
                },
                
                onSaved: (value) {
                  ipInput = value!;
                },
              ),

              const SizedBox(
                height: 30,
              ),

              RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      loading = true;
                    });

                    // Checks if the DNS & IP combination already exists in DB
                    QuerySnapshot querySnapshot = await firestoreRef
                          .where('domain_name', isEqualTo: dnsInput)
                          .where('ip_address', isEqualTo: ipInput)
                          .get();
                    if (querySnapshot.docs.isNotEmpty) {
                      Utils().toastMessage('Data already exists in database!');
                      setState(() {
                        loading = false;
                      });
                    }
                    else {  // Combination doesn't exists so adding data
                      String id = DateTime.now().millisecondsSinceEpoch.toString();
            
                      firestoreRef.doc(id).set({
                        'id' : id,
                        'domain_name' : dnsInput,
                        'ip_address' : ipInput,
                      }).then((value) {
                        Utils().toastMessage('Data added!');
                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading =false;
                        });
                      });
                    }
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}