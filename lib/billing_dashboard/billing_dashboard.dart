import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

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
  bool kotButton = true;
  bool kotDone = false;
  bool billButton = false;
  bool billDone = false;
  bool paymentButton = false;
  bool paymentDone = false;
  bool cancelTableButton = false;
  bool cancelTableDone = false;
  String _productHover = '';
  String _tableHover = '';
  String _tableSelected = '1';
  String menuItemHover = 'Billing';
  String billType = 'Dine In';
  String genderType = 'Male';

  TextEditingController searchController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String totalTables = '';

  Future addNewTable(id) async {
    FirebaseFirestore.instance.collection('tables').doc(id).set(
      {
        'status': 'vacant',
        'customer_name': 'New Customer',
        'items': '0',
        'amount': '0',
        'time': '${DateTime.now().hour}:${DateTime.now().minute}',
        'table_id': id,
      },
    );
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
                      // child: billingCustomers(),
                      child: showProducts
                          ? billingProducts()
                          : showCustomer
                              ? billingCustomers()
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
              Text(
                'Customer Details',
                style: GoogleFonts.poppins(
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
                  searchController,
                  'Contact Number',
                  'Enter Contact Number',
                ),
                billingContactTextFieldWidget(
                  searchController,
                  'Full Name',
                  'Enter Customer Full Name',
                ),
                billingContactTextFieldWidget(
                  searchController,
                  'Email',
                  'Enter Customer Email',
                ),
                billingContactTextFieldWidget(
                  searchController,
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
                        style: GoogleFonts.poppins(
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
                            style: GoogleFonts.poppins(
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
                            style: GoogleFonts.poppins(
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
                        onTap: () => setState(() => showCustomer = false),
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
                                style: GoogleFonts.poppins(
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
                              style: GoogleFonts.poppins(
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
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
            prefixStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              fontSize: 12,
            ),
            label: Text(label),
            floatingLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: greenShadeColor,
            ),
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
            ),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.3),
              fontSize: 13,
            ),
          ),
          style: GoogleFonts.poppins(
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "Vacant",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent[700],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "Occupied",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.amberAccent,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "Bill Printed",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "Payment Done",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
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
                    style: GoogleFonts.poppins(
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
                        style: GoogleFonts.poppins(
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
                        style: GoogleFonts.poppins(
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
                    Text(
                      "Add New Table",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                        fontSize: 12,
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
                  minItemsPerRow: 3,
                  children: List.generate(
                    streamSnapshot.data!.docs.length,
                    (index) {
                      DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _tableSelected = documentSnapshot.id.toString();
                              _tableHover = '';
                              showProducts = true;
                            });
                          },
                          onHover: (value) {
                            if (value) {
                              setState(() {
                                _tableHover = documentSnapshot.id.toString();
                              });
                            } else {
                              setState(() {
                                _tableHover = '';
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  _tableHover == documentSnapshot.id.toString()
                                      ? greenLightShadeColor
                                      : _tableSelected ==
                                              documentSnapshot.id.toString()
                                          ? mainShadeColor
                                          : whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: greenShadeColor.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color:
                                        documentSnapshot['status'] == 'vacant'
                                            ? Colors.blueGrey[100]
                                            : documentSnapshot['status'] ==
                                                    'occupied'
                                                ? Colors.purple
                                                : documentSnapshot['status'] ==
                                                        'bill-printed'
                                                    ? Colors.amber
                                                    : Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: greenShadeColor.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "T${documentSnapshot.id}",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              documentSnapshot['customer_name'],
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                                fontSize: 14,
                                                color: _tableSelected ==
                                                        documentSnapshot.id
                                                    ? whiteColor
                                                        .withOpacity(0.8)
                                                    : Colors.black
                                                        .withOpacity(0.5),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            MaterialButton(
                                              minWidth: 0,
                                              onPressed: () {},
                                              child: FaIcon(
                                                FontAwesomeIcons
                                                    .ellipsisVertical,
                                                color: _tableSelected ==
                                                        documentSnapshot.id
                                                    ? whiteColor
                                                        .withOpacity(0.8)
                                                    : Colors.black
                                                        .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 40),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${documentSnapshot['items']} Items',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                    fontSize: 10,
                                                    color: _tableSelected ==
                                                            documentSnapshot.id
                                                        ? whiteColor
                                                            .withOpacity(0.8)
                                                        : Colors.black
                                                            .withOpacity(0.4),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                FaIcon(
                                                  FontAwesomeIcons.arrowRight,
                                                  color: _tableSelected ==
                                                          documentSnapshot.id
                                                      ? whiteColor
                                                          .withOpacity(0.8)
                                                      : Colors.black
                                                          .withOpacity(0.4),
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "$rupeeSign${documentSnapshot['amount']}",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: _tableSelected ==
                                                        documentSnapshot.id
                                                    ? whiteColor
                                                        .withOpacity(0.8)
                                                    : Colors.black
                                                        .withOpacity(0.6),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: greenShadeColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "0:00",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor.withOpacity(0.6),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        documentSnapshot['status'] == 'vacant'
                                            ? "Available"
                                            : documentSnapshot['status'] ==
                                                    'bill-printed'
                                                ? 'Bill Printed'
                                                : documentSnapshot['status'] ==
                                                        'payment-done'
                                                    ? 'Payment Done'
                                                    : 'Occupied',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
        InkWell(
          onTap: () => setState(() => showProducts = false),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 14,
                  color: whiteColor,
                ),
                const SizedBox(width: 10),
                Text(
                  "Create New Bill For Another table",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: whiteColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => setState(() => showCategories = !showCategories),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 140,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
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
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 13,
                          ),
                        ),
                        style: GoogleFonts.poppins(
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
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 20,
                        bottom: 10,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index.toString();
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
                          width: 120,
                          decoration: BoxDecoration(
                            color: index.toString() == selectedCategoryIndex
                                ? Colors.greenAccent
                                : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: index.toString() == selectedCategoryIndex
                                    ? Colors.greenAccent.withOpacity(0.9)
                                    : Colors.greenAccent.withOpacity(0.2),
                                blurRadius:
                                    index.toString() == selectedCategoryIndex
                                        ? 20
                                        : 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/food.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                'Chaap',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  fontSize: 10,
                                  color:
                                      index.toString() == selectedCategoryIndex
                                          ? whiteColor.withOpacity(0.7)
                                          : Colors.black.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '12 items',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  // fontSize: 16,
                                  color:
                                      index.toString() == selectedCategoryIndex
                                          ? whiteColor.withOpacity(0.7)
                                          : Colors.black.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
          padding: const EdgeInsets.all(20),
          child: ResponsiveGridList(
            listViewBuilderOptions: ListViewBuilderOptions(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            minItemWidth: 200,
            minItemsPerRow: 1,
            children: List.generate(
              100,
              (index) => InkWell(
                onTap: () {},
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
                child: Container(
                  decoration: BoxDecoration(
                    color: _productHover == index.toString()
                        ? Colors.greenAccent
                        : whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Text(
                          "Product Name",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: _productHover == index.toString()
                                ? whiteColor.withOpacity(0.9)
                                : Colors.black.withOpacity(0.3),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${rupeeSign}100",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: index.isEven
                                  ? greenLightShadeColor
                                  : Colors.purpleAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              index.isEven ? 'half' : 'full',
                              style: GoogleFonts.poppins(
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  billingCart(BuildContext context) {
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
          child: Column(
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
                            onTap: () => setState(() => billType = 'Dine In'),
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
                            onTap: () =>
                                setState(() => billType = 'Home Delivery'),
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
                            onTap: () => setState(() => billType = 'Take Away'),
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
                              padding: const EdgeInsets.all(20),
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
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: whiteColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        _tableSelected.toString(),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          // color: whiteColor,
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
                            onTap: () => setState(() => showCustomer = true),
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
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              color: whiteColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'Add Details',
                                            style: GoogleFonts.poppins(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Details',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            FaIcon(
                              FontAwesomeIcons.ellipsisVertical,
                              color: Colors.black.withOpacity(0.5),
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
                              .collection('products')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> productSnapshot) {
                            if (productSnapshot.hasData) {
                              return ListView.builder(
                                itemCount: productSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot productDocumentSnapshot =
                                      productSnapshot.data!.docs[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        235,
                                        246,
                                        254,
                                      ),
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.05),
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              productDocumentSnapshot[
                                                  'product_name'],
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 1,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                'half',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            MaterialButton(
                                              minWidth: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              color: Colors.greenAccent,
                                              onPressed: () {},
                                              child: FaIcon(
                                                FontAwesomeIcons.minus,
                                                size: 14,
                                                color: whiteColor,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '1',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                            MaterialButton(
                                              minWidth: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              color: Colors.greenAccent,
                                              onPressed: () {},
                                              child: FaIcon(
                                                FontAwesomeIcons.plus,
                                                size: 14,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${rupeeSign}100',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            MaterialButton(
                                              minWidth: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              color: mainColor,
                                              onPressed: () {},
                                              child: Text(
                                                'Remove',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteColor,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
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
                  Column(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Item Count: 0',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Sub Total',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.5),
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                '${rupeeSign}100',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              minWidth: 120,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: greenShadeColor,
                              onPressed: () {},
                              child: Text(
                                'Discount',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                  color: whiteColor,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Total Discount',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.5),
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                '${rupeeSign}100',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              '${rupeeSign}100',
                              style: GoogleFonts.poppins(
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
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      color: kotButton || kotDone ? mainColor : whiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.circular(05),
                      ),
                      onPressed: () => setState(() {
                        kotButton = false;
                        kotDone = true;
                        billButton = true;
                      }),
                      child: Row(
                        children: [
                          kotDone
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: FaIcon(
                                    Icons.done_all_rounded,
                                    color: Colors.greenAccent,
                                    size: 16,
                                  ),
                                )
                              : const SizedBox(),
                          Text(
                            'KOT',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: kotButton || kotDone
                                  ? whiteColor
                                  : Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: billButton || billDone ? mainColor : whiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.circular(05),
                      ),
                      onPressed: () => setState(() {
                        kotDone = true;
                        billButton = false;
                        billDone = true;
                        paymentButton = true;
                      }),
                      child: Row(
                        children: [
                          billDone
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: FaIcon(
                                    Icons.done_all_rounded,
                                    color: Colors.greenAccent,
                                    size: 16,
                                  ),
                                )
                              : const SizedBox(),
                          Text(
                            'Print Bill',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: billButton || billDone
                                  ? whiteColor
                                  : Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      color:
                          paymentButton || paymentDone ? mainColor : whiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.circular(05),
                      ),
                      onPressed: () => setState(() {
                        kotDone = true;
                        billDone = true;
                        paymentButton = false;
                        paymentDone = true;
                        cancelTableButton = true;
                      }),
                      child: Row(
                        children: [
                          paymentDone
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: FaIcon(
                                    Icons.done_all_rounded,
                                    color: Colors.greenAccent,
                                    size: 16,
                                  ),
                                )
                              : const SizedBox(),
                          Text(
                            'Payment',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: paymentButton || paymentDone
                                  ? whiteColor
                                  : Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: cancelTableButton || cancelTableDone
                          ? mainColor
                          : whiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.circular(05),
                      ),
                      onPressed: () => setState(() {
                        kotDone = true;
                        billDone = true;
                        paymentDone = true;
                        cancelTableButton = false;
                        cancelTableDone = true;
                      }),
                      child: Row(
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
                          Text(
                            'Close Table',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: cancelTableButton || cancelTableDone
                                  ? whiteColor
                                  : Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Shri',
                    style: GoogleFonts.poppins(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " UmeshSon's",
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Healthy Foods",
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
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
        style: GoogleFonts.poppins(
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
    return Text(
      heading,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: whiteColor,
      ),
    );
  }

  billingHeaderWidget(heading, billType) {
    return Text(
      heading,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: billType == heading ? whiteColor : Colors.black.withOpacity(0.5),
      ),
    );
  }
}
