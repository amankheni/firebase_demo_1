import 'package:firebase_demo_1/firbase_api_servies.dart';
import 'package:flutter/material.dart';

class SimpleCrud extends StatefulWidget {
  const SimpleCrud({super.key});

  @override
  State<SimpleCrud> createState() => _SimpleCrudState();
}

class _SimpleCrudState extends State<SimpleCrud> {
  TextEditingController txtNameController = TextEditingController();
  late Future<List<Map>> futureUserData;
  String selectedKey = '';
  bool isUpgrade = false;
  @override
  void initState() {
    futureUserData = FirebaseApi.selectData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: txtNameController,
            ),
            MaterialButton(
              onPressed: isUpgrade == true
                  ? () async {
                      await FirebaseApi.updateData(
                        key: selectedKey,
                        userName: txtNameController.text,
                      );
                      futureUserData = FirebaseApi.selectData();
                      setState(() {});

                      // txtNameController.clear();
                    }
                  : () async {
                      await FirebaseApi.adduser(
                          userName: txtNameController.text);
                      futureUserData = FirebaseApi.selectData();
                      setState(() {
                        isUpgrade = false;
                      });
                    },
              child: Text(isUpgrade == true ? 'upgrade' : 'Submit'),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: futureUserData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Dismissible(
                        onDismissed: (direction) async {
                          await FirebaseApi.removeData(
                              key: snapshot.data![index]['key']);
                          isUpgrade = false;
                          futureUserData = FirebaseApi.selectData();
                        },
                        key: UniqueKey(),
                        child: ListTile(
                          onTap: () {
                            selectedKey = snapshot.data![index]['key'];
                            txtNameController.text = selectedKey;
                            setState(() {
                              isUpgrade = true;
                            });
                          },
                          title: Text(snapshot.data![index]['userName']),
                          subtitle: Text(snapshot.data![index]['key']),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
