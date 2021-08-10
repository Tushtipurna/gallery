import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery/auth/login.dart';
import 'package:gallery/dashboard/item_detail.dart';
import 'package:gallery/dashboard/new_item.dart';

/*
* Author Neha Yadav
* Create: 9/07/2021
* */
class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLogin = false;
  var offers;
  var docu;
  var phone;

  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  checkLoginState() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLogin = false;
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        isLogin = true;
        checkNumber();
        print(user);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        centerTitle: false,
        actions: [
          isLogin
              ? TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewItem()),
                    );
                  },
                  child: const Text('Selling'),
                )
              : TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                    checkLoginState();
                  },
                  child: const Text('Login'),
                ),
          if (isLogin)
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                checkLoginState();
              },
              child: const Text('Logout'),
            )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("items")
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Container(
              child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    crossAxisCount: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? 1
                        : 2),
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data!.docs[index];
                  return Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (isLogin)
                            item["sale"]
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItemDetail(item, docu,phone)),
                                  )
                                : Fluttertoast.showToast(
                                    msg: "Item already sold",
                                    toastLength: Toast.LENGTH_SHORT,
                                    fontSize: 18);
                          else {
                            Fluttertoast.showToast(
                                msg: "Please login to view detail page");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset:
                                    Offset(2, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      Positioned.fill(
                                        child: Image.network(
                                          item["photo"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      item["sale"]
                                          ? Positioned(
                                              left: 0,
                                              bottom: 0,
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.only(
                                                      bottom: 30),
                                                  width: 90.0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: Radius.zero,
                                                      topRight:
                                                          Radius.circular(30),
                                                      bottomLeft: Radius.zero,
                                                      bottomRight:
                                                          Radius.circular(30),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 2,
                                                        offset: Offset(2,
                                                            2), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    "For Sale",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )),
                                            )
                                          : Container(),
                                      item["under_offer"]
                                          ? Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                  alignment: Alignment.topRight,
                                                  margin: EdgeInsets.only(
                                                      bottom: 30),
                                                  width: 120.0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight: Radius.zero,
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                      bottomRight: Radius.zero,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 2,
                                                        offset: Offset(2,
                                                            2), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    "Under Offer",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    child: Text(
                                      item["itemName"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    )),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Price",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18),
                                      ),
                                      Spacer(),
                                      Text(
                                        "£${item["price"].toString()}",
                                        style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("offers")
                                      .snapshots(),
                                  builder: (context, snapshotO) {
                                    if (!snapshotO.hasData) {
                                      return Container();
                                    }
                                    docu = snapshotO.data!.docs;
                                    countItems(docu, item);
                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Available Offers",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18),
                                          ),
                                          Spacer(),
                                          Text(
                                            (countItems(docu, item)).toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }

  countItems(docu1, QueryDocumentSnapshot<Object?> item12) {
    int count = 0;
    for (int i = 0; i < docu1.length; i++) {
      var offers123 = docu1[i];
      if (offers123["item_id"] == item12.id) {
        count = count + 1;
      }
    }
    print(count);
    return count;
  }

  Future<void> checkNumber() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    print(userId);
    var user =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    phone = user["phoneNumber"];
    print("Phone number = " + phone.toString());
  }
}
