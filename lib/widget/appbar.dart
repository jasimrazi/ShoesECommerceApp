import 'package:flutter/material.dart';
import 'package:shoesapp/screens/profiledetails.dart';
import 'package:shoesapp/utils/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isBack;
  final bool? isEdit;

  const CustomAppBar({
    Key? key,
    this.title,
    this.isBack,
    this.isEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      leading: isBack == true
          ? Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                iconSize: 28, // Adjust icon size as needed
                splashRadius: 20, // Set splash radius for touch feedback
              ),
            )
          : null,
      actions: isEdit == true
          ? [
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 24,
                    color: kPrimary,
                  ),
                  onPressed: () {
                    // Define your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const ProfileDetails()),
                    );
                  },
                  iconSize: 28, // Adjust icon size as needed
                  splashRadius: 20, // Set splash radius for touch feedback
                ),
              ),
            ]
          : [],
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
