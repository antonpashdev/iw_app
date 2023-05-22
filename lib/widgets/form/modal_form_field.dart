import 'package:flutter/material.dart';
import 'package:iw_app/widgets/form/input_form.dart';

class ModalFormField<T> extends StatefulWidget {
  final Function(T? value) screenFactory;
  final Function(T? value) valueToText;
  final Function(T? value)? onSaved;
  final Function(T? value)? onChanged;
  final String labelText;
  final T? initialValue;
  final bool enabled;

  const ModalFormField({
    Key? key,
    required this.screenFactory,
    required this.valueToText,
    this.onSaved,
    this.onChanged,
    required this.labelText,
    this.initialValue,
    this.enabled = true,
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
  void didUpdateWidget(covariant ModalFormField<T> oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.initialValue != null) {
        controller.text = widget.valueToText(widget.initialValue);
      } else {
        controller.text = '';
      }
    });
    super.didUpdateWidget(oldWidget);
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
          onTap: widget.enabled
              ? () async {
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
                    widget.onChanged?.call(value);
                    state.didChange(value);
                    controller.text = widget.valueToText(value);
                  }
                }
              : null,
          child: IgnorePointer(
            child: AppTextFormFieldBordered(
              enabled: widget.enabled,
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
