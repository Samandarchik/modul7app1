import 'package:flutter/material.dart';

class MyTextFild extends StatefulWidget {
  final String text;
  final bool obscureText;
  final TextInputType textInputType;
  void Function(String)? press;

  MyTextFild(
      {super.key,
      required this.press,
      required this.text,
      required this.obscureText,
      required this.textInputType});

  @override
  State<MyTextFild> createState() => _MyTextFildState();
}

class _MyTextFildState extends State<MyTextFild> {
  // Bu o'zgaruvchi obscureText holatini boshqarish uchun kerak
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextField(
        onChanged: widget.press,
        style: const TextStyle(color: Colors.white),
        obscureText: _isObscured, // Parol yashirin yoki ochiq bo'lishi
        keyboardAppearance: Brightness.dark,
        keyboardType: widget.textInputType,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured =
                          !_isObscured; // Parolni yashirish yoki ko'rsatish
                    });
                  },
                  child: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xffd2fe55),
                  ),
                )
              : const SizedBox(),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: widget.text,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
