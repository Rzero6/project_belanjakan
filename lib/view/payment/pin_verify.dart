import 'package:flutter/material.dart';

class PinVerificationScreen extends StatefulWidget {
  @override
  _PinVerificationScreenState createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String enteredPin = "";
  bool obscurePin = true;

  void onPinEntered(String pin) {
    setState(() {
      enteredPin = pin;
    });

    if (enteredPin.length == 6) {
      // Validate the PIN here
      if (enteredPin == "123456") {
        // Correct PIN, you can navigate to the next screen
        print("Correct PIN! Navigating to the next screen.");
      } else {
        // Incorrect PIN, you can show an error message
        print("Incorrect PIN! Please try again.");
        setState(() {
          enteredPin = ""; // Clear the entered PIN
        });
      }
    }
  }

  void togglePinVisibility() {
    setState(() {
      obscurePin = !obscurePin;
    });
  }

  void onSubmitPressed() {
    // Handle the "Submit" button press
    print("Submit pressed!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PIN Verification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Your PIN",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            PinInput(onPinEntered: onPinEntered, obscurePin: obscurePin),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Adjusted to space between the two buttons
              children: [
                ElevatedButton(
                  onPressed: togglePinVisibility,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.blue),
                    ),
                    primary: Colors.white,
                  ),
                  child: Text(
                    obscurePin ? "Tampilkan" : "Sembunyikan",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 220, // Set the width as per your PIN input container
              child: ElevatedButton(
                onPressed: onSubmitPressed,
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PinInput extends StatelessWidget {
  final Function(String) onPinEntered;
  final bool obscurePin;

  PinInput({required this.onPinEntered, required this.obscurePin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      child: TextFormField(
        onChanged: (value) {
          onPinEntered(value);
        },
        obscureText: obscurePin,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, letterSpacing: 20),
        decoration: InputDecoration(
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
