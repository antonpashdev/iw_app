import 'package:flutter/material.dart';

class _CustomBottomSheet extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? child;

  const _CustomBottomSheet({
    Key? key,
    this.title,
    this.description,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 35, 35, 50),
        child: child ??
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.grey,
                      size: 25,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      title!,
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  description!,
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 330,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Got it'),
                      ),
                    )
                  ],
                ),
              ],
            ),
      ),
    );
  }
}

// define function to show modal bottom sheet
void showBottomInfoSheet(
  BuildContext context, {
  String? title,
  String? description,
  Widget? child,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return _CustomBottomSheet(
        title: title,
        description: description,
        child: child,
      );
    },
  );
}
