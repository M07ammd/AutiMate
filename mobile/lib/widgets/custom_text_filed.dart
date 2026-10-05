import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? errorText;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  bool hidePassword = true;

  late AnimationController _controller;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shake = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller);
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 👇 لما يظهر error → نعمل shake
    if (widget.errorText != null && oldWidget.errorText == null) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shake.value, 0),
          child: child,
        );
      },
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? hidePassword : false,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText,

          prefixIcon: widget.icon != null
              ? Icon(
            widget.icon,
            color: widget.errorText != null
                ? Colors.red
                : Colors.grey,
          )
              : null,

          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              hidePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: widget.errorText != null
                  ? Colors.red
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
          )
              : null,

          filled: true,
          fillColor: Colors.grey.shade100,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: widget.errorText != null
                  ? Colors.red
                  : Colors.transparent,
              width: 2,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: widget.errorText != null
                  ? Colors.red
                  : const Color(0xFF45BB89),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}