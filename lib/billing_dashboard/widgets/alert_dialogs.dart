import 'package:flutter/material.dart';
import 'package:umeshsons_billing/helper/app_constant.dart';

alertDialogWidget(context, color, msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: displayWidth(context) / 3,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      // margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: color,
      content: Center(
        child: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
