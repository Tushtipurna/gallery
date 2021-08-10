import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class ItemDetail extends StatefulWidget {
  final item;
  final offers;
  final phoneNumber;

  ItemDetail(this.item, this.offers,this.phoneNumber);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  double _currentSliderValue = 1;
  bool isLoading = false;
  bool purchased = false;
  var userIdd;
  String value = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    userIdd = FirebaseAuth.instance.currentUser!.uid;
    // redeemOffer();
  }

  @override
  Widget build(BuildContext context) {
    Timestamp t = widget.item['timestamp'];
    DateTime date = t.toDate();
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  widget.item["photo"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              widget.item["sale"]
                                  ? Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(bottom: 30),
                                          width: 90.0,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: widget.item["sale"]
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.zero,
                                              topRight: Radius.circular(30),
                                              bottomLeft: Radius.zero,
                                              bottomRight: Radius.circular(30),
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
                                            widget.item["sale"]
                                                ? "For Sale"
                                                : "Sold",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Text(
                            widget.item["itemName"],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
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
                              "£${widget.item["price"].toString()}",
                              style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                            Spacer(),
                            Text(
                              "${date.month}-${date.day}-${date.year}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Seller",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        "${widget.item["username"]}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                (userIdd == widget.item['user_id'])
                    ? Container(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            !purchased
                                ? Text(
                                    "Offer Values",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )
                                : Container(),
                            purchased
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 8,
                                          offset: Offset(2,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Customer Detail",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              email,
                                              style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              widget.phoneNumber.toString(),
                                              style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: widget.offers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var newDoc = widget.offers[index];
                                      print(newDoc);
                                      return (widget.item.id ==
                                              newDoc["item_id"])
                                          ? InkWell(
                                              onTap: () {
                                                print(newDoc["value"]);
                                                setState(() {
                                                  value = newDoc["value"]
                                                      .toString();
                                                  email = newDoc["email"];});
                                              },
                                              child: ListTile(
                                                visualDensity: VisualDensity(
                                                    horizontal: 0,
                                                    vertical: -4),
                                                title: Text(
                                                  "*  £${newDoc["value"].toString()}",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green.shade700,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            )
                                          : Container();
                                    }),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 8,
                                    offset: Offset(
                                        2, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selected Offer Value",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  Spacer(),
                                  Text(
                                    "£$value",
                                    style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            purchased
                                ? Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              purchased = false;
                                            });
                                            // await uploadFileAndSubmitData();
                                          },
                                          child: Text('Back'),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await updateSaleValue();
                                          },
                                          child: Text('Confirm'),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (value == "") {
                                          Fluttertoast.showToast(
                                              msg: "No offers Selected",
                                              toastLength: Toast.LENGTH_SHORT,
                                              fontSize: 18);
                                        } else {
                                          setState(() {
                                            purchased = true;
                                          });
                                        }

                                        // await uploadFileAndSubmitData();
                                      },
                                      child: Text('Accept Offer'),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Text(
                            "Choose Offer Price",
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _currentSliderValue,
                                  min: 1,
                                  max: (widget.item['price']).toDouble(),
                                  label: _currentSliderValue.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _currentSliderValue = value;
                                    });
                                  },
                                ),
                              ),
                              Text("£${_currentSliderValue.toInt()}"),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                // if (_formKey.currentState!.validate()) {
                                //   setState(() {
                                //     // isLoading = true;
                                //   });
                                //   await uploadFileAndSubmitData();
                                // }
                                setState(() {
                                  isLoading = true;
                                });
                                await uploadFileAndSubmitData();
                              },
                              child: Text('Submit'),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.black26,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()))
              : Container()
        ],
      ),
    );
  }

  Future<void> uploadFileAndSubmitData() async {
    try {
      await FirebaseFirestore.instance.collection('offers').add({
        "email": FirebaseAuth.instance.currentUser!.email,
        "phone": widget.phoneNumber.toString(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "item_id": widget.item.id,
        "value": _currentSliderValue.toInt()
      });
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Item successfully added.",
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0);
      Navigator.of(context).pop();
    } on firebase_core.FirebaseException catch (e) {
      print("Error ${e.message}");
    }
  }

  redeemOffer() {
    for (int i = 0; i < widget.offers.length; i++) {
      var offers123 = widget.offers[i];
      print(offers123["value"]);
    }
  }

  countItems(offers) {
    int count = 0;
    for (int i = 0; i < offers.length; i++) {
      var offers123 = offers[i];
      if (offers123["item_id"] == widget.item.id) {
        count = count + 1;
      }
    }
    print(count);
    return count;
  }

  Future<void> updateSaleValue() async {
    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.item.id)
          .update({
        "sale": false,
        "under_offer": true,
      });
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Item Sold.", toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
      Navigator.of(context).pop();
    } on firebase_core.FirebaseException catch (e) {
      print("Error ${e.message}");
    }
  }
}
