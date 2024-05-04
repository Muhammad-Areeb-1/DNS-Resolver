import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color primaryColor;
  final Color secondaryColor;

  const RoundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false,
      this.primaryColor = Colors.indigo,
      this.secondaryColor = const Color.fromARGB(255, 255, 255, 255)});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 70,
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: loading ? CircularProgressIndicator(strokeWidth: 3, color: secondaryColor,) :
          Text(
            title,
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
