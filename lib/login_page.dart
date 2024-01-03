 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/Details_page.dart';
import 'package:firebase1/Notification/Notification_Services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

 class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

 class _LoginPageState extends State<LoginPage> {

  NotificationServices notificationServices = NotificationServices();
  // final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notificationServices.firebaseInit(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);

      }
    });
  }
  // Future<void> _initFirebase() async {
  //   await _firebaseMessagingService.initialize();
  //   String token = await _firebaseMessagingService.getDeviceToken();
  //   print("Device Token: $token");
  // }
  Future getData() async {

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Country").get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Database"),
        centerTitle: true,
      ),

      /// get data to firebase  StremBuilder

      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection("Country").snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: Text("Loading"),
      //       );
      //     } else {
      //       return GridView.builder(
      //         itemCount: snapshot.data!.docs.length,
      //         scrollDirection: Axis.vertical,
      //         gridDelegate:
      //             SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //         itemBuilder: (context, index) {
      //           DocumentSnapshot data =
      //               snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
      //           return GridTile(child: Text(data["name"]));
      //         },
      //       );
      //     }
      //   },
      // ),

      /// FutureBuilder
      // body: FutureBuilder(
      //   future: getData(),
      //   builder: (context, snapshot) {
      //     return ListView.builder(
      //       itemCount: snapshot.data.length,
      //       itemBuilder: (context, index) {
      //         DocumentSnapshot data = snapshot.data[index];
      //         return Card(
      //           child: ListTile(
      //             title: Text(data["name"]),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),

      body: Column(
        children: [
          /// FutureBuilder in Firebase
          SizedBox(
            height: 10,
          ),
          Text(
            "get data FutureBuilder in Firebase",
            style: TextStyle(color: Colors.orange),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 310,
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data[index];
                    return Card(
                      elevation: 1,
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                  name: data['name'], img: data['img']),
                            )),
                        child: ListTile(
                          title: Text(data["name"]),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "get data to firebase  StremBuilder",
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(
            height: 10,
          ),

          /// get data to firebase  StremBuilder
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Country").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Loading"),
                  );
                } else {
                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data?.docs[index]
                          as DocumentSnapshot<Object?>;
                      return Card(
                        elevation: 1,
                          child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                  name: data['name'], img: data['img']),
                            )),
                        child: GridTile(
                            child: Column(
                          children: [
                            Text(data["name"]),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.network(
                                data['img'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        )),
                      ));
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
