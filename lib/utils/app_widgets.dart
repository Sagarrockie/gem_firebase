import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';

class WidgetUtils {
  static Widget pingoButton(
      BuildContext context, String buttonText, VoidCallback buttonAction) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
        onPressed: buttonAction,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
              AppColors.primaryColor), // Background color
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Border radius
              side: const BorderSide(color: Colors.blue), // Border color and width
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ), // Text color
        ),
      ),
    );
  }

  static Widget pingoTextField(
      TextEditingController controller, String labelText, bool obscureText,
      {required FormValidator validator}) {
    return Padding(
      padding: const EdgeInsets.all(19.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator ?? (value) => null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 15.0), // Adjust padding as needed
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
            const BorderSide(color: AppColors.whiteColor), // Border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
            const BorderSide(color: AppColors.whiteColor), // Enabled border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
            const BorderSide(color: AppColors.whiteColor), // Focused border color
          ),
        ),
        cursorHeight: 20.0, // Adjust cursor height as needed
        cursorColor: Colors.blue, // Cursor color
        style: const TextStyle(fontSize: 16.0), // Adjust text style as needed
        keyboardType: TextInputType.text, // Specify input type as needed
        maxLines: 1, // Limit to single line input
        textAlignVertical:
        TextAlignVertical.center, // Center align text vertically
      ),
    );
  }
}

typedef FormValidator = String? Function(String? value);
