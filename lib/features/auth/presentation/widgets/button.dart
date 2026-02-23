import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final Text text;
  final Color color;

  const ButtonWidget({required this.onPressed, required this.text,required this.color, super.key});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(),
        ),

        onPressed: widget.onPressed,
        child: widget.text,
      ),
    );
  }
}
