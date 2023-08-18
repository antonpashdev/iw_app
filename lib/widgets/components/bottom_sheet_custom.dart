import 'package:flutter/material.dart';

class _CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? left;
  final Widget? right;

  const _CustomBottomSheet({
    Key? key,
    this.title,
    this.left,
    this.right,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  left ?? const Text(''),
                  Expanded(
                    child: Center(
                      child: Text(
                        title ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  right ?? const Text(''),
                ],
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
showBottomSheetCustom(
  BuildContext context, {
  required Widget child,
  String? title,
  Widget? left,
  Widget? right,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _CustomBottomSheet(
        title: title,
        left: left,
        right: right,
        child: child,
      );
    },
  );
}
