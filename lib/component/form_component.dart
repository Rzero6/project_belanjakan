import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputForm extends StatefulWidget {
  final Function(String?) validasi;
  final TextEditingController controller;
  final String hintTxt;
  final String? helperTxt;
  final IconData iconData;
  final bool password;
  final bool date;
  const InputForm(
      {super.key,
      required this.validasi,
      required this.controller,
      required this.hintTxt,
      this.helperTxt,
      this.date=false,
      required this.iconData,
      this.password = false});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool _isVisible = false;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _isVisible = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
          width: 350,
          child: TextFormField(
            validator: (value) => widget.validasi(value),
            autofocus: true,
            controller: widget.controller,
            obscureText: _isVisible,
            decoration: InputDecoration(
              hintText: widget.hintTxt,
              border: const OutlineInputBorder(),
              helperText: widget.helperTxt,
              prefixIcon: Icon(widget.iconData),
              suffixIcon: widget.password ? togglePassword() : widget.date ? showCupertinoDatePicker() : null,
            ),
          )),
    );
  }

  Widget showCupertinoDatePicker(){
    return IconButton(onPressed: () async {
      widget.controller.text = formatDate(dateTime);
      showCupertinoModalPopup(context: context, builder: (BuildContext context) => SizedBox(height: 250, child: CupertinoDatePicker(
        backgroundColor: Colors.white,
        initialDateTime: dateTime,
        onDateTimeChanged: (DateTime newTime){
          setState(() {
            dateTime = newTime;
          }
          );
          widget.controller.text = formatDate(dateTime);
        },
        mode: CupertinoDatePickerMode.date,
      ),));
    }, icon: const Icon(Icons.date_range_rounded));
  }
  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
        icon: _isVisible
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility));
  }

  String formatDate(DateTime dateTime){
    final formatter = DateFormat.yMd();
    return formatter.format(dateTime);
  }
}
