import 'package:flutter/material.dart';
import 'package:hawely/shared/widgets/apptheme.dart';

class CustomBottomAppbar extends StatelessWidget {
  const CustomBottomAppbar({super.key});

  //const CustomBottomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Apptheme.blackwithblue,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.currency_exchange_outlined,
              size: 30,
              color: Apptheme.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.settings,
          //     size: 30,
          //     color: Apptheme.white,
          //   ),
          //   onPressed: () {
          //     Navigator.pushReplacementNamed(context, '/settings');
          //   },
          //),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              size: 30,
              color: Apptheme.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/accountdata');
            },
          ),
        ],
      ),
    );
  }
}
