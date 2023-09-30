import 'package:flutter/material.dart';
import '../../../widgets/app_text.dart';
import '../../constants/apppadding.dart';

class NotificationBusiness extends StatelessWidget {
  const NotificationBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const AppText(
          text: "Notifications",
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPadding.defaultPadding,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Card(
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xffF6F6F6),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: Offset(4, 2))
                    ]),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: AppText(
                        text: "Your order has been placed",
                        color: Color(0xff183046),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5, top: 25),
                      child: AppText(
                        text: "11:32PM",
                        fontSize: 12,
                        color: Color(0xff9E9E9E),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xffF6F6F6),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: Offset(4, 2))
                    ]),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: AppText(
                        text: "Order Accepted",
                        color: Color(0xff183046),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5, top: 25),
                      child: AppText(
                        text: "11:32PM",
                        fontSize: 12,
                        color: Color(0xff9E9E9E),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
