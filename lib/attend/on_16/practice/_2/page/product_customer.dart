import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/dummies/product_dummy.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/box_decoration_default.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/text_style_default.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/colors.dart';
import 'package:pemprograman_mobile/firebase_options.dart';


class ProductCustomerViewPage extends StatelessWidget {
  const ProductCustomerViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String titleAppBar = 'Our Products';

    final dynamic appbar = AppBar(
      backgroundColor: DefaultColors.secondaryColors,
      key: key,
      title: Text(titleAppBar,
          style: TextStyleDefault.defaultBlack35SizeTextStyle()),
      centerTitle: true,
      leading: MaterialButton(
          child: Center(
              child: Icon(Icons.arrow_circle_left_outlined,
                  color: DefaultColors.primaryColors, size: 35)),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [
        MaterialButton(
            child: Center(
                child: Icon(Icons.arrow_circle_right_outlined,
                    color: DefaultColors.primaryColors, size: 35)),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );

    final dynamic scaffold = Scaffold(
        key: key,
        backgroundColor: DefaultColors.quadryColors,
        body: Container(
            key: key,
            margin: EdgeInsets.all(10),
            decoration: BoxDecorationDefault.defaultYellowBoxDecoration(
                color: DefaultColors.primaryColors),
            child: WidgetListProduct(key: key)),
        appBar: appbar);

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}


class WidgetListProduct extends StatelessWidget {
  const WidgetListProduct({super.key});

  @override
  Widget build(BuildContext context) {
    log("WidgetListProduct build function called.");

    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    CollectionReference<Product> productCollection = FirebaseFirestore.instance
        .collection(Product.collectionName)
        .withConverter(fromFirestore: (snapshots, _) {
      return Product.fromJson(snapshots.data());
    }, toFirestore: (mahasiswa, _) {
      return mahasiswa.toJson();
    });

    return StreamBuilder<QuerySnapshot<Product>>(
        stream: productCollection.snapshots(),
        builder: (contextStream, snapshotStream) {
          log("snapshotStream Anonymous Function Called.");
          if (snapshotStream.connectionState == ConnectionState.active) {
            return ListView(
              key: key,
              padding: const EdgeInsets.all(8.0),
              children: List<Widget>.generate(
                snapshotStream.data!.size,
                (index) {
                  Product data = snapshotStream.data!.docs[index].data();
                  log(data.toString());
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: DefaultColors.secondaryColors,
                      child: ProductCard(product: data, key: key),
                    ),
                  );
                },
              ),
            );
          }

          if (snapshotStream.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return WidgetProductListDummy(key: key);
        });
  }
}
