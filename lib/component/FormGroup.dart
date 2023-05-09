import 'package:flutter/material.dart';

class FormGroup extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry padding;

  final String? Function(String? input) validator;

  const FormGroup(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.label,
      required this.isPassword,
      this.keyboardType = TextInputType.text,
      this.padding = const EdgeInsets.fromLTRB(32, 32, 32, 0),
      required this.validator})
      : super(key: key);

  @override
  State<FormGroup> createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: TextFormField(
              controller: widget.controller,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: widget.isPassword ? _obscureText : false,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null),
            ),
          ),
        ],
      ),
    );
  }
}
