// import 'package:flutter/material.dart';
//
// import 'components/sign_up_body.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const SafeArea(
//         child: Scaffold(
//       body: Center(
//         child: SignUpBodyScreen(),
//       ),
//     ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Screens/signup/components/flow_one.dart';
import '../Screens/signup/components/flow_three.dart';
import '../Screens/signup/components/flow_two.dart';
import '../controller/flow_controller.dart';


class SignUpBodyScreen extends StatefulWidget {
  const SignUpBodyScreen({super.key});

  @override
  State<SignUpBodyScreen> createState() => _SignUpBodyScreenState();
}

class _SignUpBodyScreenState extends State<SignUpBodyScreen> {
  FlowController flowController = Get.put(FlowController());
  late int _currentFlow;

  @override
  void initState() {
    _currentFlow = FlowController().currentFlow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.green,
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 735,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: HexColor("#ffffff"),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: GetBuilder<FlowController>(
                        builder: (context) {
                          // Menampilkan tampilan sesuai dengan alur saat ini
                          // if (flowController.currentFlow == 1) {
                            return const SignUpOne();
                          // } else if (flowController.currentFlow == 2) {
                            return const SignUpTwo();
                          // } else {
                          //   return const SignUpThree();
                          // }
                        },
                      ),
                    ),
                    // Transform.translate(
                    //   offset: const Offset(0, -253),
                    //   child: Image.asset(
                    //     'assets/Images/plants2.png',
                    //     scale: 1.5,
                    //     width: double.infinity,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
