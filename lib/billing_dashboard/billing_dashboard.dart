// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:umeshsons_billing/billing_dashboard/widgets/alert_dialogs.dart';
import 'package:umeshsons_billing/billing_dashboard/widgets/timedifferencewidget.dart';

import '../helper/app_constant.dart';

class BillingDashboard extends StatefulWidget {
  const BillingDashboard({super.key});

  @override
  State<BillingDashboard> createState() => _BillingDashboardState();
}

class _BillingDashboardState extends State<BillingDashboard> {
  String selectedCategoryIndex = '';
  bool showCart = false;
  bool showCategories = true;
  bool showOrders = true;
  bool showProducts = false;
  bool showCustomer = false;
  bool showPayments = false;
  bool kotButton = true;
  bool kotDone = false;
  bool billButton = false;
  bool billDone = false;
  bool paymentButton = false;
  bool paymentDone = false;
  bool cancelTableButton = false;
  bool cancelTableDone = false;
  bool discountbutton = true;
  bool clickkot = true;
  bool clickprintbill = false;
  bool clickpayment = false;
  bool addInstructions = false;

  bool discountstatus = true;
  String _productHover = '';
  String _tableHover = '';
  String _tableSelected = '0';
  String menuItemHover = 'Billing';
  String billType = 'Dine In';
  String genderType = 'Male';
  String itemlenght = '';
  String selectedpaymentType = '';
  String tableOrderId = '';
  TextEditingController searchController = TextEditingController();
  String search = '';
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController addnoteController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  String totalTables = '';
  String totalproducts = '';
  var discount = 0;
  String securityKey = "dev";
  var categery = '';
  var productid = '';
  var productprice = '';
  var producttype = '';
  var productname = '';
  var itemcount = '';
  var userId = '100';
  var paymenttype = 'Billing_panel';
  List productNames = [];
  List productPrice = [];
  List productType = [];
  List quantitytype = [];

  num grandtotal = 0;

  String categoryid = "";

  Future addNewTable(id) async {
    FirebaseFirestore.instance.collection('tables').doc(id).set(
      {
        'status': 'vacant',
        'discount': '0',
        'customer_name': 'New Customer',
        'items': '0',
        'amount': '0',
        'time': '00:00',
        'table_id': id,
        'kot_done': 'false',
        'bill_done': 'false',
        'payment_done': 'false',
        'email': '',
        'number': '',
        'gender': '',
        'address': '',
        'order_id': '',
        'instructions': '',
      },
    );
  }

  Future<void> addNewTableProduct(
      String id, DocumentSnapshot documentSnapshot) async {
    try {
      var docRef = FirebaseFirestore.instance
          .collection('tables')
          .doc(id)
          .collection('product')
          .doc(documentSnapshot.id);
      var doc = await docRef.get();

      FirebaseFirestore.instance
          .collection('tables')
          .doc(id)
          .collection('product')
          .get()
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
          } else {
            FirebaseFirestore.instance.collection('tables').doc(id).update(
              {
                'status': 'occupied',
                'time': DateFormat('MMM d, y hh:mm a').format(DateTime.now())
              },
            );
          }
        },
      );

      if (doc.exists) {
        if (kIsWeb) {
          String basePrice = documentSnapshot['product_price'];
          String totalPrice = doc.get('total_price');
          String total = "${int.parse(totalPrice) + int.parse(basePrice)}";
          String quantity = doc.get('quantity');
          await FirebaseFirestore.instance
              .collection('tables')
              .doc(id)
              .collection('product')
              .doc(documentSnapshot.id)
              .update(
            {
              'total_price': total,
              'quantity': '${int.parse(quantity) + 1}',
            },
          );
        }
      } else {
        if (kIsWeb) {
          await FirebaseFirestore.instance
              .collection('tables')
              .doc(id)
              .collection('product')
              .doc(documentSnapshot.id)
              .set(
            {
              'product_name': documentSnapshot['product_name'],
              'categery': documentSnapshot['categery'],
              'product_id': documentSnapshot['product_id'],
              'product_price': documentSnapshot['product_price'],
              'total_price': documentSnapshot['product_price'],
              'product_type': documentSnapshot['product_type'],
              'quantity': '1',
            },
          );
        }
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future getCustomerDetails() async {
    log('tables selected is $_tableSelected');
    await FirebaseFirestore.instance
        .collection('tables')
        .doc(_tableSelected)
        .get()
        .then(
      (value) {
        setState(() {
          nameController.text = value.get('customer_name');
          emailController.text = value.get('email');
          numberController.text = value.get('number');
          addressController.text = value.get('address');
          genderType = value.get('gender');
        });
      },
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> MinusNewTableProduct(
      String id, DocumentSnapshot documentSnapshot) async {
    try {
      var docRef = FirebaseFirestore.instance
          .collection('tables')
          .doc(id)
          .collection('product')
          .doc(documentSnapshot.id);
      var doc = await docRef.get();

      if (doc.exists) {
        String basePrice = documentSnapshot['product_price'];
        String totalPrice = doc.get('total_price');
        String total = "${int.parse(totalPrice) - int.parse(basePrice)}";
        String quantity = doc.get('quantity');
        if (int.parse(quantity) > 1) {
          if (kIsWeb) {
            await FirebaseFirestore.instance
                .collection('tables')
                .doc(id)
                .collection('product')
                .doc(documentSnapshot.id)
                .update(
              {
                'total_price': total,
                'quantity': '${int.parse(quantity) - 1}',
              },
            );
          }
        } else {
          if (kIsWeb) {
            deleteTableProduct(id, documentSnapshot);
          }
        }
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> deleteTableProduct(String id, documentSnapshot) async {
    try {
      await FirebaseFirestore.instance
          .collection('tables')
          .doc(id)
          .collection('product')
          .doc(documentSnapshot.id)
          .delete();
      print('Product deleted successfully');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future insertOrderbilling(
      productNames,
      categery,
      productid,
      productPrice,
      grandtotal,
      productType,
      quantitytype,
      discount,
      itemcount,
      id,
      paymenttype,
      userId) async {
    String apiurl =
        "http://dominatortechnology.com/ankit/admin_api/insert_order.php?key=$securityKey&user_id=$userId&products_name=${productNames.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}&order_ammount=${productPrice.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}&discount=$discount&total_ammount=$grandtotal&payment_type=${categery.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}&product_quantity_type=${quantitytype.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}&payment_type=$paymenttype";
    try {
      log('place order $apiurl');
      final response = await http.get(
        Uri.parse(apiurl),
      );
      if (response.statusCode == 200) {
        log('order id is ${response.body}');
        FirebaseFirestore.instance
            .collection('tables')
            .doc(_tableSelected)
            .update(
          {
            'order_id': response.body,
          },
        );
      }
    } on Exception catch (e) {
      log('exception is $e');
    }
    log("Insert order is $apiurl");
  }

  Future updateOrderbillingPaymentType(id, paymenttype) async {
    String apiurl =
        "http://dominatortechnology.com/ankit/admin_api/update_order_payment_type.php?key=$securityKey&order_id=$id&payment_type=billing-$paymenttype&payment_id=billing-$paymenttype&payment_note=${addnoteController.text}";
    try {
      log('update order $apiurl');
      final response = await http.get(
        Uri.parse(apiurl),
      );
      log('update order is ${response.body}');
      if (response.statusCode == 200) {
        alertDialogWidget(
          context,
          greenLightShadeColor,
          'Payment detail added successfully',
        );
      }
    } on Exception catch (e) {
      log('exception is $e');
    }
    log("update order is $apiurl");
  }

  Future updateOrderbillingInstructions(id, instructions) async {
    String apiurl =
        "http://dominatortechnology.com/ankit/admin_api/update_instructions.php?key=$securityKey&order_id=$id&instructions=$instructions";
    try {
      log('update order $apiurl');
      final response = await http.get(
        Uri.parse(apiurl),
      );
      log('update order is ${response.body}');
      if (response.statusCode == 200) {
        alertDialogWidget(
          context,
          greenLightShadeColor,
          'Instruction detail added successfully',
        );
      }
    } on Exception catch (e) {
      log('exception is $e');
    }
    log("update order is $apiurl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          billingTopBarWidget(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    height: displayHeight(context) / 1.17,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: showProducts
                          ? billingProducts()
                          : showCustomer
                              ? billingCustomers()
                              : showPayments
                                  ? billingPayments()
                                  : addInstructions
                                      ? billingInstructions()
                                      : billingTables(),
                    ),
                  ),
                ),
              ),
              !showCart ? billingCart(context) : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  billingInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    showCustomer = false;
                    showProducts = true;
                    showPayments = false;
                    addInstructions = false;
                  });
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: whiteColor,
                ),
              ),
              Text(
                'Instructions',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(05),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.4),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              maxLines: 20,
              controller: instructionsController,
              decoration: InputDecoration(
                prefixStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                hintText: 'Add Instructions Here',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.3),
                  fontSize: 13,
                ),
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                padding: EdgeInsets.all(20),
                color: greenSelectedColor,
                onPressed: () {
                  setState(() {
                    instructionsController.clear();
                  });
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 30),
              MaterialButton(
                padding: EdgeInsets.all(20),
                color: greenShadeColor,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('tables')
                      .doc(_tableSelected)
                      .update(
                    {
                      'instructions': instructionsController.text,
                    },
                  ).whenComplete(
                    () => alertDialogWidget(
                      context,
                      greenLightShadeColor,
                      'instructions Add Successfully',
                    ),
                  );
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  billingCustomers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    showCustomer = false;
                    showProducts = false;
                    showPayments = false;
                    addInstructions = false;
                    _tableSelected = '0';
                  });
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: whiteColor,
                ),
              ),
              Text(
                'Customer Details',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: displayWidth(context) / 5,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                billingContactTextFieldWidget(
                  numberController,
                  'Contact Number',
                  'Enter Contact Number',
                ),
                billingContactTextFieldWidget(
                  nameController,
                  'Full Name',
                  'Enter Customer Full Name',
                ),
                billingContactTextFieldWidget(
                  emailController,
                  'Email',
                  'Enter Customer Email',
                ),
                billingContactTextFieldWidget(
                  addressController,
                  'Address',
                  'Enter Customer Full Address',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => setState(() => genderType = 'Male'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: genderType == 'Male'
                                ? greenShadeColor
                                : whiteColor,
                            border: Border.all(
                              color: genderType == 'Male'
                                  ? greenShadeColor
                                  : Colors.greenAccent,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            'Male',
                            style: TextStyle(
                              color: genderType == 'Male'
                                  ? whiteColor
                                  : Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => setState(() => genderType = 'Female'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: genderType == 'Female'
                                ? greenShadeColor
                                : whiteColor,
                            border: Border.all(
                              color: genderType == 'Female'
                                  ? greenShadeColor
                                  : Colors.greenAccent,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            'Female',
                            style: TextStyle(
                              color: genderType == 'Female'
                                  ? whiteColor
                                  : Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(
                          () {
                            showCustomer = false;
                            showProducts = true;
                            showPayments = false;
                          },
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: mainShadeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Skip',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection('tables')
                              .doc(_tableSelected)
                              .update(
                            {
                              'customer_name': nameController.text,
                              'email': emailController.text,
                              'gender': genderType,
                              'number': numberController.text,
                              'address': addressController.text,
                            },
                          ).whenComplete(() {
                            alertDialogWidget(
                              context,
                              greenLightShadeColor,
                              'Customer Details Added!',
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: greenShadeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  billingContactTextFieldWidget(controller, label, hintText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(05),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          maxLines: label == 'Address' ? 5 : 1,
          controller: controller,
          decoration: InputDecoration(
            prefix: label == 'Contact Number'
                ? const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text('+91'),
                  )
                : null,
            prefixStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              fontSize: 12,
            ),
            label: Text(label),
            floatingLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: greenShadeColor,
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
            ),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.3),
              fontSize: 13,
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  billingTables() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Vacant",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.purpleAccent[700],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Occupied",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Bill Printed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Payment Done",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(width: 60),
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  content: Text(
                    'Do you want to create another table?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.5),
                      letterSpacing: 0.3,
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      color: Colors.greenAccent,
                      onPressed: () {
                        addNewTable(
                          (int.parse(totalTables) + 1).toString(),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: whiteColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: mainColor,
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: whiteColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.plus,
                      color: whiteColor,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Add New Table",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tables').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                totalTables = streamSnapshot.data!.docs.length.toString();
                return ResponsiveGridList(
                  listViewBuilderOptions: ListViewBuilderOptions(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  minItemWidth: 360,
                  minItemsPerRow: 4,
                  children: List.generate(
                    streamSnapshot.data!.docs.length,
                    (index) {
                      DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _tableSelected = documentSnapshot.id.toString();
                            _tableHover = '';
                            showProducts = true;
                          });
                        },
                        // onHover: (value) {
                        //   if (value) {
                        //     setState(() {
                        //       _tableHover = documentSnapshot.id.toString();
                        //     });
                        //   } else {
                        //     setState(() {
                        //       _tableHover = '';
                        //     });
                        //   }
                        // },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 2,
                                  color: documentSnapshot['status'] == 'vacant'
                                      ? Colors.blueGrey[100]!
                                      : documentSnapshot['status'] == 'occupied'
                                          ? Colors.purple
                                          : documentSnapshot['status'] ==
                                                  'bill-printed'
                                              ? Colors.amber
                                              : Colors
                                                  .greenAccent, // Border color
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "T${documentSnapshot.id}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 34,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        MaterialButton(
                                          minWidth: 0,
                                          onPressed: () {},
                                          child: FaIcon(
                                            FontAwesomeIcons.ellipsisVertical,
                                            color: _tableSelected ==
                                                    documentSnapshot.id
                                                ? whiteColor.withOpacity(0.8)
                                                : Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              documentSnapshot['customer_name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "$rupeeSign${documentSnapshot['amount']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _tableSelected ==
                                                        documentSnapshot.id
                                                    ? whiteColor
                                                        .withOpacity(0.8)
                                                    : Colors.black
                                                        .withOpacity(0.6),
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                documentSnapshot['time']
                                                            .toString()
                                                            .contains('am') ||
                                                        documentSnapshot['time']
                                                            .toString()
                                                            .contains('pm') ||
                                                        documentSnapshot['time']
                                                            .toString()
                                                            .contains('AM') ||
                                                        documentSnapshot['time']
                                                            .toString()
                                                            .contains('PM')
                                                    ? TimeDifferenceWidget(
                                                        orderPlacedTime:
                                                            documentSnapshot[
                                                                'time'],
                                                      )
                                                    : Text(
                                                        "00",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: whiteColor,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                Text(
                                                  "Mins",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: documentSnapshot['status'] ==
                                              'vacant'
                                          ? Colors.blueGrey[100]!
                                          : documentSnapshot['status'] ==
                                                  'occupied'
                                              ? Colors.purple
                                              : documentSnapshot['status'] ==
                                                      'bill-printed'
                                                  ? Colors.amber
                                                  : Colors.greenAccent,
                                      // ignore: prefer_const_constructors
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: const Radius.circular(6),
                                          bottomRight:
                                              const Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 40),
                                          Text(
                                            documentSnapshot['time'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: whiteColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  billingProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => setState(() => showCategories = !showCategories),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    MaterialButton(
                      minWidth: 0,
                      onPressed: () {
                        setState(
                          () {
                            showProducts = false;
                            showCustomer = false;
                            showPayments = false;
                            addInstructions = false;
                            _tableSelected = '0';
                          },
                        );
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: whiteColor,
                      ),
                    ),
                    billingHeaderTextWidget('Categories'),
                    const SizedBox(width: 10),
                    FaIcon(
                      showCategories
                          ? FontAwesomeIcons.circleChevronUp
                          : FontAwesomeIcons.circleChevronDown,
                      color: whiteColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.4),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.black.withOpacity(0.3),
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search Products',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 13,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = searchController.text;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            search = searchController.text;
                          });
                        },
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        !showCategories
            ? const SizedBox()
            : SizedBox(
                height: 40,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot productDocumentSnapshot =
                                snapshot.data!.docs[index];

                            categery = productDocumentSnapshot['categery_name'];

                            return Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedCategoryIndex = index.toString();

                                    if (productDocumentSnapshot[
                                            'categery_name'] !=
                                        "All") {
                                      categoryid = productDocumentSnapshot[
                                          'categery_id'];
                                    } else {
                                      categoryid = "";
                                    }
                                  });
                                },
                                onHover: (value) {
                                  if (value) {
                                    setState(() {
                                      selectedCategoryIndex = index.toString();
                                    });
                                  } else {
                                    setState(() {
                                      selectedCategoryIndex = '';
                                    });
                                  }
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: index.toString() ==
                                            selectedCategoryIndex
                                        ? Colors.greenAccent
                                        : whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: index.toString() ==
                                                selectedCategoryIndex
                                            ? Colors.greenAccent
                                                .withOpacity(0.9)
                                            : Colors.greenAccent
                                                .withOpacity(0.2),
                                        blurRadius: index.toString() ==
                                                selectedCategoryIndex
                                            ? 20
                                            : 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    productDocumentSnapshot['categery_name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      fontSize: 18,
                                      color: index.toString() ==
                                              selectedCategoryIndex
                                          ? whiteColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    }),
              ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: StreamBuilder(
            stream: categoryid.isEmpty
                ? FirebaseFirestore.instance
                    .collection('billing_products')
                    .where('product_price', isNotEqualTo: "0")
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('billing_products')
                    .where('categery', isEqualTo: categoryid)
                    .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                streamSnapshot.data!.docs.length.toString();
                return ResponsiveGridList(
                  listViewBuilderOptions: ListViewBuilderOptions(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  minItemWidth: 215,
                  minItemsPerRow: 4,
                  children: List.generate(
                      streamSnapshot.data!.docs
                          .where(
                            (element) =>
                                element['product_name']
                                    .toString()
                                    .contains(search) ||
                                element['product_type']
                                    .toString()
                                    .contains(search) ||
                                element['product_price']
                                    .toString()
                                    .contains(search),
                          )
                          .length, (index) {
                    final filteredData = streamSnapshot.data!.docs.where(
                        (element) =>
                            element['product_name']
                                .toString()
                                .contains(search) ||
                            element['product_type']
                                .toString()
                                .contains(search) ||
                            element['product_price']
                                .toString()
                                .contains(search));
                    final documentSnapshot = filteredData.elementAt(index);

                    return InkWell(
                      onTap: () {
                        addNewTableProduct(
                          _tableSelected.toString(),
                          documentSnapshot,
                        );
                      },
                      onHover: (value) {
                        if (value) {
                          setState(() {
                            _productHover = index.toString();
                          });
                        } else {
                          setState(() {
                            _productHover = '';
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: _productHover == index.toString() ? 2 : 1,
                              color: _productHover == index.toString()
                                  ? Colors.greenAccent
                                  : Colors.grey, // Border color
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "${documentSnapshot['product_name']} ${documentSnapshot['product_type']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "$rupeeSign${documentSnapshot['product_price']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 40,
                                // ignore: prefer_const_constructors
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  // ignore: prefer_const_constructors
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(6),
                                      bottomRight: const Radius.circular(6)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(width: 40),
                                      Text(
                                        "#${documentSnapshot['categery']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }
              return Container();
            },
          ),
        )
      ],
    );
  }

  billingPayments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    showCustomer = false;
                    showProducts = false;
                    showPayments = false;
                    addInstructions = false;
                    _tableSelected = '0';
                  });
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: whiteColor,
                ),
              ),
              Text(
                'Payments',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'cash';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'cash'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'cash'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Cash',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'card';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'card'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'card'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Card',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'online';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'online'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'online'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'company';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'company'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'company'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Company',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.4),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  maxLines: 5,
                  controller: addnoteController,
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      fontSize: 12,
                    ),
                    label: Text('Add Note'),
                    floatingLabelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: greenShadeColor,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    hintText: 'Enter any aditional information here',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.3),
                      fontSize: 13,
                    ),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: greenSelectedColor,
                    onPressed: () {
                      setState(() {
                        addnoteController.clear();
                        selectedpaymentType = '';
                      });
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: greenShadeColor,
                    onPressed: () {
                      updateOrderbillingPaymentType(
                        tableOrderId,
                        selectedpaymentType,
                      );
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  billingCart(context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          constraints: BoxConstraints(
            minHeight: displayHeight(context) / 1.17,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: _tableSelected == '0'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/welcome.json'),
                    Text(
                      'Please select any table to continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(
                              color: Colors.black.withOpacity(0.05),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.utensils,
                                          color: whiteColor,
                                          size: 28,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Table No.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: whiteColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              _tableSelected.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: whiteColor,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _tableSelected != '0'
                                      ? setState(
                                          () {
                                            showCustomer = true;
                                            showPayments = false;
                                            addInstructions = false;
                                            showProducts = false;
                                            getCustomerDetails();
                                          },
                                        )
                                      : alertDialogWidget(
                                          context,
                                          Colors.red,
                                          'Please select table to continue',
                                        ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.person,
                                              color: whiteColor,
                                              size: 28,
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Customer',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  'Add Details',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    // color: whiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const FaIcon(
                                          FontAwesomeIcons.plus,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(
                              color: Colors.black.withOpacity(0.05),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(
                                    () {
                                      discountbutton = true;
                                      billType = 'Dine In';
                                    },
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: billType == "Dine In"
                                          ? mainColor
                                          : whiteColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: billingHeaderWidget(
                                        'Dine In',
                                        billType,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(
                                      () => billType = 'Home Delivery'),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: billType == "Home Delivery"
                                          ? mainColor
                                          : whiteColor,
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: billingHeaderWidget(
                                        'Home Delivery',
                                        billType,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      setState(() => billType = 'Take Away'),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: billType == "Take Away"
                                          ? mainColor
                                          : whiteColor,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: billingHeaderWidget(
                                        'Take Away',
                                        billType,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: whiteColor,
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  MaterialButton(
                                    minWidth: 120,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: greenShadeColor,
                                    onPressed: () {
                                      setState(() {
                                        showCustomer = false;
                                        showPayments = false;
                                        addInstructions = true;
                                        showProducts = false;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add_rounded,
                                          color: whiteColor,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Add Instructions',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                            color: whiteColor,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: displayHeight(context) / 2.8,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('tables')
                                    .doc(_tableSelected)
                                    .collection('product')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        productSnapshot) {
                                  if (productSnapshot.hasData) {
                                    productNames.clear();
                                    productPrice.clear();
                                    productType.clear();
                                    quantitytype.clear();
                                    return ListView.builder(
                                      itemCount:
                                          productSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot
                                            productDocumentSnapshot =
                                            productSnapshot.data!.docs[index];
                                        productNames.add(
                                            productDocumentSnapshot[
                                                    'product_name']
                                                .toString());
                                        productPrice.add(
                                            productDocumentSnapshot[
                                                    'product_price']
                                                .toString());
                                        productType.add(productDocumentSnapshot[
                                                'product_type']
                                            .toString());

                                        quantitytype.add(
                                            productDocumentSnapshot[
                                                'quantity']);

                                        log("ljiksdldfsljksdf $productType");

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              255,
                                              235,
                                              246,
                                              254,
                                            ),
                                            border: Border.all(
                                              color:
                                                  Colors.blue.withOpacity(0.05),
                                              width: 1,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        " ${productDocumentSnapshot['product_name']} ${productDocumentSnapshot['product_type']}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                                child: Text(
                                                  '$rupeeSign${productDocumentSnapshot['product_price']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  MaterialButton(
                                                    minWidth: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    color: Colors.greenAccent,
                                                    onPressed: () {
                                                      MinusNewTableProduct(
                                                          _tableSelected,
                                                          productDocumentSnapshot);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.minus,
                                                      size: 14,
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                    child: Text(
                                                      productDocumentSnapshot[
                                                          'quantity'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  MaterialButton(
                                                    minWidth: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    color: Colors.greenAccent,
                                                    onPressed: () {
                                                      addNewTableProduct(
                                                          _tableSelected,
                                                          productDocumentSnapshot);
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.plus,
                                                      size: 14,
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 50,
                                                child: Text(
                                                  '$rupeeSign${productDocumentSnapshot['total_price']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Row(
                                                  children: [
                                                    MaterialButton(
                                                      minWidth: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      color: mainColor,
                                                      onPressed: () {
                                                        deleteTableProduct(
                                                            _tableSelected,
                                                            productDocumentSnapshot);
                                                      },
                                                      child: FaIcon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    MaterialButton(
                                                      minWidth: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      color: mainColor,
                                                      onPressed: () {
                                                        // deleteTableProduct(
                                                        //     _tableSelected,
                                                        //     productDocumentSnapshot);
                                                      },
                                                      child: FaIcon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('tables')
                              .doc(_tableSelected)
                              .collection('product')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              var totalprice = 0;
                              for (var i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
                                totalprice += int.parse(
                                    snapshot.data!.docs[i]['total_price']);
                              }

                              grandtotal = discountstatus
                                  ? (totalprice - discount)
                                  : (totalprice -
                                      (totalprice * discount / 100));
                              itemcount = "${snapshot.data!.docs.length}";

                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.1),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            'Item Count: ${snapshot.data!.docs.length}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            'Sub Total',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              letterSpacing: 0.3,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            '$rupeeSign$totalprice',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.3,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  showProducts
                                      ? Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.blue.withOpacity(0.1),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 16,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              discountbutton
                                                  ? MaterialButton(
                                                      minWidth: 120,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      color: greenShadeColor,
                                                      onPressed: () {
                                                        setState(() {
                                                          discountbutton =
                                                              false;
                                                        });
                                                      },
                                                      child: Text(
                                                        'Discount',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.3,
                                                          color: whiteColor,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ))
                                                  : Row(
                                                      children: [
                                                        MaterialButton(
                                                          minWidth: 60,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          color: discountstatus
                                                              ? whiteColor
                                                              : greenShadeColor,
                                                          onPressed: () {
                                                            setState(() {
                                                              discountController
                                                                  .clear();
                                                              discountstatus =
                                                                  false;
                                                              discount = 0;
                                                            });
                                                          },
                                                          child: Text(
                                                            '%',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing:
                                                                  0.3,
                                                              color: discountstatus
                                                                  ? Colors.black
                                                                  : whiteColor,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        SizedBox(
                                                          width: 60,
                                                          child: TextField(
                                                            onChanged: (value) {
                                                              if (value
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  discount =
                                                                      int.parse(
                                                                          value);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  discountController
                                                                      .clear();
                                                                  discountstatus =
                                                                      true;
                                                                  discount = 0;
                                                                });
                                                              }
                                                              log("hjlksdgfljkhdsgflhjksd $value");
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(
                                                                  3)
                                                            ],
                                                            controller:
                                                                discountController,
                                                            decoration: InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                isDense: true,
                                                                hintText:
                                                                    discountController
                                                                        .text,
                                                                border:
                                                                    OutlineInputBorder()),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        MaterialButton(
                                                          minWidth: 60,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          color: discountstatus
                                                              ? greenShadeColor
                                                              : whiteColor,
                                                          onPressed: () {
                                                            setState(() {
                                                              discountController
                                                                  .clear();
                                                              discountstatus =
                                                                  true;
                                                              discount = 0;
                                                            });
                                                          },
                                                          child: Text(
                                                            // ignore: unnecessary_string_interpolations
                                                            '$rupeeSign',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing:
                                                                  0.3,
                                                              color: discountstatus
                                                                  ? whiteColor
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              SizedBox(
                                                  width: 120,
                                                  child: discountstatus
                                                      ? Text(
                                                          '$rupeeSign$discount',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 0.3,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        )
                                                      : Text(
                                                          '$discount${"%"}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 0.3,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        )),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 16,
                                          ),
                                        ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: greenShadeColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Grand Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: whiteColor,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        Text(
                                          "$rupeeSign${grandtotal.toString()}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                            color: whiteColor,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                    // button stream builder
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('tables')
                          .where('table_id', isEqualTo: _tableSelected)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          for (var v = 0; v < snapshot.data!.docs.length;) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[v];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: documentSnapshot['kot_done'] == 'true' &&
                                      documentSnapshot['bill_done'] == 'false'
                                  ? Stack(
                                      children: [
                                        clearButton(context, documentSnapshot),
                                        paymentsButton(
                                            context, documentSnapshot),
                                        kotPrintDone(context, documentSnapshot),
                                        printBillButton(
                                            context, documentSnapshot),
                                      ],
                                    )
                                  : documentSnapshot['bill_done'] == 'true' &&
                                          documentSnapshot['kot_done'] == 'true'
                                      ? Stack(
                                          children: [
                                            clearButton(
                                                context, documentSnapshot),
                                            kotPrintDone(
                                                context, documentSnapshot),
                                            printBillButton(
                                                context, documentSnapshot),
                                            paymentsButton(
                                                context, documentSnapshot),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            clearButton(
                                                context, documentSnapshot),
                                            paymentsButton(
                                                context, documentSnapshot),
                                            printBillButton(
                                                context, documentSnapshot),
                                            kotPrintDone(
                                                context, documentSnapshot),
                                          ],
                                        ),
                            );
                          }
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  kotPrintDone(context, documentSnapshot) {
    return Positioned(
      right: MediaQuery.of(context).size.width / 5.6,
      child: MaterialButton(
        height: MediaQuery.of(context).size.height / 21,
        minWidth: MediaQuery.of(context).size.width / 13,
        color: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tables')
              .doc(_tableSelected)
              .collection('product')
              .get()
              .then(
            (value) {
              if (value.size > 0) {
                insertOrderbilling(
                    productNames,
                    categery,
                    productid,
                    productPrice,
                    grandtotal,
                    productType,
                    quantitytype,
                    discount,
                    itemcount,
                    _tableSelected,
                    paymenttype,
                    userId);
                FirebaseFirestore.instance
                    .collection('tables')
                    .doc(_tableSelected)
                    .update(
                  {
                    'kot_done': 'true',
                    'status': 'occupied',
                  },
                );
              } else {
                alertDialogWidget(
                  context,
                  Colors.red,
                  'Please add any product to continue',
                );
              }
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            documentSnapshot['kot_done'] == 'true'
                ? const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: FaIcon(
                      Icons.done_all_rounded,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'KOT',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  printBillButton(context, documentSnapshot) {
    return Positioned(
      right: MediaQuery.of(context).size.width / 8.1,
      child: MaterialButton(
        height: MediaQuery.of(context).size.height / 21,
        minWidth: MediaQuery.of(context).size.width / 13,
        color: documentSnapshot['bill_done'] == 'true'
            ? Colors.amber
            : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tables')
              .doc(_tableSelected)
              .collection('product')
              .get()
              .then(
            (value) {
              if (value.size > 0) {
                setState(() {
                  showPayments = true;
                  showProducts = false;
                  showCustomer = false;
                });
                if (documentSnapshot['kot_done'] == 'true') {
                  setState(() {
                    tableOrderId = documentSnapshot['order_id'];
                    updateOrderbillingInstructions(
                      tableOrderId,
                      documentSnapshot['instructions'],
                    );
                  });
                  FirebaseFirestore.instance
                      .collection('tables')
                      .doc(_tableSelected)
                      .update(
                    {
                      'bill_done': 'true',
                      'status': 'bill-printed',
                    },
                  );
                } else {
                  insertOrderbilling(
                    productNames,
                    categery,
                    productid,
                    productPrice,
                    grandtotal,
                    productType,
                    quantitytype,
                    discount,
                    itemcount,
                    _tableSelected,
                    paymenttype,
                    userId,
                  );

                  FirebaseFirestore.instance
                      .collection('tables')
                      .doc(_tableSelected)
                      .update(
                    {
                      'bill_done': 'true',
                      'kot_done': 'true',
                      'status': 'bill-printed',
                    },
                  );
                  setState(() {
                    tableOrderId = documentSnapshot['order_id'];
                    updateOrderbillingInstructions(
                      tableOrderId,
                      documentSnapshot['instructions'],
                    );
                  });
                }
              } else {
                alertDialogWidget(
                  context,
                  Colors.red,
                  'Please add any product to continue',
                );
              }
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            documentSnapshot['bill_done'] == 'true'
                ? Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: FaIcon(
                      Icons.done_all_rounded,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                'Print Bill',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  paymentsButton(context, documentSnapshot) {
    return Positioned(
      right: MediaQuery.of(context).size.width / 15,
      child: MaterialButton(
        height: MediaQuery.of(context).size.height / 21,
        minWidth: MediaQuery.of(context).size.width / 13,
        color: documentSnapshot['payment_done'] == 'true'
            ? Colors.green
            : Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tables')
              .doc(_tableSelected)
              .collection('product')
              .get()
              .then(
            (value) {
              if (value.size > 0) {
                setState(() {
                  showPayments = true;
                  showProducts = false;
                  showCustomer = false;
                });
                if (documentSnapshot['kot_done'] == 'true' &&
                    documentSnapshot['bill_done'] == 'true') {
                  FirebaseFirestore.instance
                      .collection('tables')
                      .doc(_tableSelected)
                      .update(
                    {
                      'payment_done': 'true',
                      'status': 'payment',
                    },
                  );
                  setState(() {
                    tableOrderId = documentSnapshot['order_id'];
                    updateOrderbillingInstructions(
                      tableOrderId,
                      documentSnapshot['instructions'],
                    );
                  });
                } else if (documentSnapshot['kot_done'] != 'true') {
                  insertOrderbilling(
                    productNames,
                    categery,
                    productid,
                    productPrice,
                    grandtotal,
                    productType,
                    quantitytype,
                    discount,
                    itemcount,
                    _tableSelected,
                    paymenttype,
                    userId,
                  );

                  FirebaseFirestore.instance
                      .collection('tables')
                      .doc(_tableSelected)
                      .update(
                    {
                      'bill_done': 'true',
                      'kot_done': 'true',
                      'payment_done': 'true',
                      'status': 'payment',
                    },
                  );
                  setState(() {
                    tableOrderId = documentSnapshot['order_id'];
                    updateOrderbillingInstructions(
                      tableOrderId,
                      documentSnapshot['instructions'],
                    );
                  });
                } else {
                  FirebaseFirestore.instance
                      .collection('tables')
                      .doc(_tableSelected)
                      .update(
                    {
                      'bill_done': 'true',
                      'kot_done': 'true',
                      'payment_done': 'true',
                      'status': 'payment',
                    },
                  );
                  setState(() {
                    tableOrderId = documentSnapshot['order_id'];
                    updateOrderbillingInstructions(
                      tableOrderId,
                      documentSnapshot['instructions'],
                    );
                  });
                }
              } else {
                alertDialogWidget(
                  context,
                  Colors.red,
                  'Please add any product to continue',
                );
              }
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            documentSnapshot['payment_done'] == 'true'
                ? const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: FaIcon(
                      Icons.done_all_rounded,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Payment',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clearButton(context, documentSnapshot) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: MaterialButton(
        height: MediaQuery.of(context).size.height / 21,
        minWidth: MediaQuery.of(context).size.width / 13,
        color: Colors.black.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tables')
              .doc(_tableSelected)
              .update(
            {
              'status': 'vacant',
              'customer_name': 'New Customer',
              'bill_done': 'false',
              'payment_done': 'false',
              'kot_done': 'false',
              'time': '00:00',
              'address': '',
              'instructions': '',
              'order_id': '',
            },
          );
          FirebaseFirestore.instance
              .collection('tables')
              .doc(_tableSelected)
              .collection('product')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot doc in snapshot.docs) {
              doc.reference.delete();
            }
          }).then((_) {
            FirebaseFirestore.instance
                .collection('tables')
                .doc(_tableSelected)
                .collection('product')
                .doc()
                .delete();
          });
          setState(() {
            showProducts = false;
            _tableSelected = "0";
            discountbutton = true;
            showPayments = false;
            discount = 0;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              cancelTableDone
                  ? const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: FaIcon(
                        Icons.done_all_rounded,
                        color: Colors.greenAccent,
                        size: 16,
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Close Table',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: whiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  billingTopBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: whiteColor,
        shadowColor: Colors.greenAccent.withOpacity(0.3),
        elevation: 10,
        centerTitle: false,
        title: InkWell(
          onTap: () => setState(
            () {
              showProducts = false;
              _tableSelected = "0";
              discountbutton = true;
              discount = 0;
            },
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Shri',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " UmeshSon's",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Healthy Foods",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    menuItemHover = 'Billing Panel';
                  });
                },
                child: menuItemWidget('Billing Panel', menuItemHover),
              ),
              InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    menuItemHover = 'Delivery Panel';
                  });
                },
                child: menuItemWidget('Delivery Panel', menuItemHover),
              ),
              InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    menuItemHover = 'Settings';
                  });
                },
                child: menuItemWidget('Settings', menuItemHover),
              ),
            ],
          ),
          const SizedBox(width: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  showCart = !showCart;
                });
              },
              icon: FaIcon(
                !showCart ? FontAwesomeIcons.xing : FontAwesomeIcons.bars,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  menuItemWidget(title, hoverMenu) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(
          bottom: BorderSide(
            color: hoverMenu == title ? Colors.greenAccent : whiteColor,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: hoverMenu == title
              ? Colors.black.withOpacity(0.6)
              : Colors.black.withOpacity(0.3),
          fontSize: 14,
        ),
      ),
    );
  }

  billingHeaderTextWidget(heading) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        heading,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: whiteColor,
        ),
      ),
    );
  }

  billingHeaderWidget(heading, billType) {
    return Text(
      heading,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: billType == heading ? whiteColor : Colors.black.withOpacity(0.5),
      ),
    );
  }
}
