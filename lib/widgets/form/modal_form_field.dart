import 'package:flutter/material.dart';
import 'package:iw_app/widgets/form/input_form.dart';

class ModalFormField<T> extends StatefulWidget {
  final Function(T? value) screenFactory;
  final Function(T? value) valueToText;
  final Function(T? value)? onSaved;
  final String labelText;
  final T? initialValue;

  const ModalFormField({
    Key? key,
    required this.screenFactory,
    required this.valueToText,
    this.onSaved,
    required this.labelText,
    this.initialValue,
  }) : super(key: key);

  @override
  State<ModalFormField<T>> createState() => _ModalFormFieldState<T>();
}

class _ModalFormFieldState<T> extends State<ModalFormField<T>> {
  final controller = TextEditingController();

  @override
  initState() {
    if (widget.initialValue != null) {
      controller.text = widget.valueToText(widget.initialValue);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.initialValue,
      onSaved: (value) {
        if (widget.onSaved != null) {
          widget.onSaved!(value);
        }
      },
      builder: (state) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            final screen = widget.screenFactory(state.value);
            if (screen == null) {
              return;
            }
            final value = await Navigator.of(context).push<T>(
              MaterialPageRoute(
                builder: (context) => screen,
                fullscreenDialog: true,
              ),
            );
            if (value != null) {
              state.didChange(value);
              controller.text = widget.valueToText(value);
            }
          },
          child: IgnorePointer(
            child: AppTextFormFieldBordered(
              controller: controller,
              errorText: state.errorText,
              labelText: widget.labelText,
            ),
          ),
        );
      },
    );
  }
}
