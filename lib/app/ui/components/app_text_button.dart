import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.blueAccent
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
            )
          ),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          fixedSize: MaterialStateProperty.all<Size>(
              const Size(double.maxFinite, 50)
          ),
        ),
        child: Text(text)
    );
  }
}
