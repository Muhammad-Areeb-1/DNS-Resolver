import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_screen.dart';
import '../utils/utils.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  final firestoreRef = FirebaseFirestore.instance.collection('DNS DBMS').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('DNS DBMS');

  final searchFilterController = TextEditingController();

  final dnsEditController = TextEditingController();
  final ipEditController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Database'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              controller: searchFilterController,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder()
              ),
              onChanged: (value) {
                setState(() {
                  
                });
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firestoreRef,
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
          
              if (snapshot.hasError) {
                return const Text('Error Occured');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
          
                    final dns = snapshot.data!.docs[index]['domain_name'].toString();
                    final ip = snapshot.data!.docs[index]['ip_address'].toString();
                    final id = snapshot.data!.docs[index]['id'].toString();
                    
                    if (searchFilterController.text.isEmpty) {
                      return ListTile(
                      title: Text(dns),
                      subtitle: Text(ip),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return <PopupMenuEntry<int>> [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showUpdateDialog(dns, ip, id);
                                },
                              )
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDeleteDialog(id);
                                },
                              )
                            )
                          ];
                        },
                      ),
                    );
                    } else if (dns.toString().toLowerCase().contains(searchFilterController.text.toLowerCase()) || ip.toString().contains(searchFilterController.text.toLowerCase())) {
                      return ListTile(
                      title: Text(dns),
                      subtitle: Text(ip),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return <PopupMenuEntry<int>> [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showUpdateDialog(dns, ip, id);
                                },
                              )
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDeleteDialog(id);
                                },
                              )
                            )
                          ];
                        },
                      ),
                    );
                    } else {
                      return Container();
                    }
                  }
                )
              );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showUpdateDialog(String dns, String ip, String id)async {
    dnsEditController.text = dns;
    ipEditController.text = ip;
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: dnsEditController,
                  decoration: const InputDecoration(
                    labelText: 'Domain Name',
                    border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a domain name';
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
                ),
                
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  controller: ipEditController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'IP Address',
                    border: OutlineInputBorder()
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter an IP address';
                    }

                    RegExp ipRegExp = RegExp(
                      r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$',
                      caseSensitive: false,
                    );

                    // Checks if input matches the above IP format
                    if (!ipRegExp.hasMatch(value)) {
                      return 'Invalid IP address format';
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
                  },
                ),
              ],
            )
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {

                  // Checks if the DNS & IP combination already exists in DB
                  QuerySnapshot querySnapshot = await ref
                        .where('domain_name', isEqualTo: dnsEditController.text.toString())
                        .where('ip_address', isEqualTo: ipEditController.text.toString())
                        .get();

                  if (querySnapshot.docs.isNotEmpty)
                  {
                    Utils().toastMessage('Entry not edited! Data already exists in database!');
                  }
                  else
                  {  // Combination doesn't exists so editing data
                    Navigator.pop(context);
                    ref.doc(id).update({
                      'domain_name' : dnsEditController.text.toString(),
                      'ip_address' : ipEditController.text.toString(),
                    }).then((value) {
                      Utils().toastMessage('Entry edited!');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  }
                }
              },
              child: const Text('Edit')
            ),
          ],
        );
      }
    );
  }

  Future<void> showDeleteDialog(String id)async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('You are about to delete an entry!'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                ref.doc(id).delete()
                .then((value) {
                  Utils().toastMessage('Entry deleted!');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              child: const Text('Confirm')
            ),
          ],
        );
      }
    );
  }
  
}