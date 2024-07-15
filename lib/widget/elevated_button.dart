import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isGoogle;
  final bool isLoading;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isGoogle = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 56,
        margin: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity, // Set width to fill available space
        child: Ink(
          decoration: BoxDecoration(
            color: isGoogle ? Colors.white : Color(0xff5B9EE1),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            splashColor: Colors.white38, // Customize splash color here
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    CupertinoActivityIndicator(
                      color: isGoogle ? Colors.black : Colors.white,
                    ),
                  if (isGoogle && !isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'assets/images/google.png', // Replace with your Google logo asset
                        height: 24,
                        width: 24,
                      ),
                    ),
                  if (!isLoading)
                    Text(
                      isGoogle ? 'Sign in with Google' : text,
                      style: TextStyle(
                        color: isGoogle ? Colors.black : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
