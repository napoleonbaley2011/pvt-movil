import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:muserpol_pvt/components/button.dart';

class TabInfo extends StatelessWidget {
  final String text;
  final Function() nextScreen;
  const TabInfo({super.key, required this.text, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: text != ''
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                          child: Text(
                  text,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20.sp),
                )),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ButtonComponent(
                  text: 'INICIAR',
                  onPressed: () => nextScreen(),
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
            )
          : Center(
              child: Image.asset(
              'assets/images/load.gif',
              fit: BoxFit.cover,
              height: 20,
            )),
    );
  }
}
