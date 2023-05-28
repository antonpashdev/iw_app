import 'package:flutter/material.dart';

class _CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _CustomBottomSheet({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 35, 35, 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

// define function to show modal bottom sheet
void showBottomSheetCustom(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return _CustomBottomSheet(
        title: title,
        child: child,
      );
    },
  );
}
