import 'package:flutter/material.dart';
import '../../constants/apppadding.dart';
import 'app_text.dart';

class ProfileWidget extends StatelessWidget {
  final String title;
 final IconData? icon;
  final void Function()? ontap;

  const ProfileWidget({
    super.key,
    required this.title,
    required this.ontap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        children: [
          Padding(
            padding: AppPadding.defaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(
                      width: 15,
                    ),
                    AppText(
                      text: title,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff181725),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.arrow_drop_down_sharp),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            width: double.infinity,
            child: Divider(
              color: Color(0xffE2E2E2),
              thickness: 1,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
