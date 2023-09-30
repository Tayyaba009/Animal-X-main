import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'app_text.dart';

class AppButton2 extends StatelessWidget {
  final String btnText;
  final void Function() ontap;
  final bool isLoading;

  const AppButton2({
    Key? key,
    required this.btnText,
    this.isLoading = false,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white)),
        child: Center(
          child: isLoading
              ? const SpinKitThreeBounce(
                  size: 20,
                  color: Colors.white,
                )
              : AppText(
                  text: btnText,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
        ),
      ),
    );
  }
}
