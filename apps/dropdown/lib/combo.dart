import 'package:flutter/material.dart';

/// A [FormField] that contains a [DropdownButton].
///
/// This is a convenience widget that wraps a [DropdownButton] widget in a
/// [FormField].
///
/// A [FormTest] ancestor is not required. The [FormTest] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [FormTest],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// See also:
///
///  * [DropdownButton], which is the underlying text field without the [FormTest]
///    integration.
class ComboTest<T> extends FormField<T> {
  /// Creates a [DropdownButton] widget that is a [FormField], wrapped in an
  /// [InputDecorator].
  ///
  /// For a description of the `onSaved`, `validator`, or `autovalidateMode`
  /// parameters, see [FormField]. For the rest (other than [decoration]), see
  /// [DropdownButton].
  ///
  /// The `items`, `elevation`, `iconSize`, `isDense`, `isExpanded`,
  /// `autofocus`, and `decoration`  parameters must not be null.
  ComboTest({
    Key? key,
    required List<DropdownMenuItem<T>>? items,
    DropdownButtonBuilder? selectedItemBuilder,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    required this.onChanged,
    VoidCallback? onTap,
    int elevation = 8,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool autofocus = false,
    Color? dropdownColor,
    InputDecoration? decoration,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((DropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [DropdownButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [DropdownMenuItem]s were detected '
          'with the same value',
        ),
        assert(elevation != null),
        assert(iconSize != null),
        assert(isDense != null),
        assert(isExpanded != null),
        assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        assert(autofocus != null),
        decoration = decoration ?? InputDecoration(focusColor: focusColor),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<T> field) {
            print('ComboTest - Builder FormFieldState');
            final _ComboTestState<T> state = field as _ComboTestState<T>;
            final InputDecoration decorationArg =
                decoration ?? InputDecoration(focusColor: focusColor);
            final InputDecoration effectiveDecoration =
                decorationArg.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            final bool showSelectedItem = items != null &&
                items
                    .where(
                        (DropdownMenuItem<T> item) => item.value == state.value)
                    .isNotEmpty;
            bool isHintOrDisabledHintAvailable() {
              final bool isDropdownDisabled =
                  onChanged == null || (items == null || items.isEmpty);
              if (isDropdownDisabled) {
                return hint != null || disabledHint != null;
              } else {
                return hint != null;
              }
            }

            final bool isEmpty =
                !showSelectedItem && !isHintOrDisabledHintAvailable();
            print(
                'ComboTest - Show selected row = $showSelectedItem --- isHint = ${isHintOrDisabledHintAvailable()} --- Tom = $isEmpty');

            // An unfocusable Focus widget so that this widget can detect if its
            // descendants have focus or not.
            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(builder: (BuildContext context) {
                print('ComboTest - Return InputDecorator');
                return InputDecorator(
                  decoration:
                      effectiveDecoration.copyWith(errorText: field.errorText),
                  isEmpty: isEmpty,
                  isFocused: Focus.of(context).hasFocus,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      items: items,
                      selectedItemBuilder: selectedItemBuilder,
                      value: state.value,
                      hint: hint,
                      disabledHint: disabledHint,
                      onChanged: onChanged == null ? null : state.didChange,
                      onTap: onTap,
                      elevation: elevation,
                      style: style,
                      icon: icon,
                      iconDisabledColor: iconDisabledColor,
                      iconEnabledColor: iconEnabledColor,
                      iconSize: iconSize,
                      isDense: isDense,
                      isExpanded: isExpanded,
                      itemHeight: itemHeight,
                      focusColor: focusColor,
                      focusNode: focusNode,
                      autofocus: autofocus,
                      dropdownColor: dropdownColor,
                      menuMaxHeight: menuMaxHeight,
                      enableFeedback: enableFeedback,
                      alignment: alignment,
                    ),
                  ),
                );
              }),
            );
          },
        );

  /// {@macro flutter.material.dropdownButton.onChanged}
  final ValueChanged<T?>? onChanged;

  /// The decoration to show around the dropdown button form field.
  ///
  /// By default, draws a horizontal line under the dropdown button field but
  /// can be configured to show an icon, label, hint text, and error text.
  ///
  /// If not specified, an [InputDecorator] with the `focusColor` set to the
  /// supplied `focusColor` (if any) will be used.
  final InputDecoration decoration;

  @override
  FormFieldState<T> createState() => _ComboTestState<T>();
}

class _ComboTestState<T> extends FormFieldState<T> {
  @override
  ComboTest<T> get widget => super.widget as ComboTest<T>;

  @override
  void didChange(T? value) {
    print('ComboTest - didChange - $value');
    super.didChange(value);
    assert(widget.onChanged != null);
    widget.onChanged!(value);
  }

  @override
  void didUpdateWidget(ComboTest<T> oldWidget) {
    print(
        'ComboTest - didUpdateWidget - ${oldWidget.initialValue} --- ${widget.initialValue}');
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}

//======================================================================================================================

//======================================================================================================================
//======================================================================================================================
//======================================================================================================================

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// An optional container for grouping together multiple form field widgets
/// (e.g. [TextField] widgets).
///
/// Each individual form field should be wrapped in a [FormField] widget, with
/// the [FormTest] widget as a common ancestor of all of those. Call methods on
/// [FormTestState] to save, reset, or validate each [FormField] that is a
/// descendant of this [FormTest]. To obtain the [FormTestState], you may use [FormTest.of]
/// with a context whose ancestor is the [FormTest], or pass a [GlobalKey] to the
/// [FormTest] constructor and call [GlobalKey.currentState].
///
/// {@tool dartpad}
/// This example shows a [FormTest] with one [TextFormField] to enter an email
/// address and an [ElevatedButton] to submit the form. A [GlobalKey] is used here
/// to identify the [FormTest] and validate input.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/widgets/form.png)
///
/// ** See code in examples/api/lib/widgets/form/form.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [GlobalKey], a key that is unique across the entire app.
///  * [FormField], a single form field widget that maintains the current state.
///  * [TextFormField], a convenience widget that wraps a [TextField] widget in a [FormField].
class FormTest extends StatefulWidget {
  /// Creates a container for form fields.
  ///
  /// The [child] argument must not be null.
  const FormTest({
    Key? key,
    required this.child,
    this.onWillPop,
    this.onChanged,
    AutovalidateMode? autovalidateMode,
  })  : assert(child != null),
        autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled,
        super(key: key);

  /// Returns the closest [FormTestState] which encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// FormState form = Form.of(context);
  /// form.save();
  /// ```
  static FormTestState? of(BuildContext context) {
    final _FormScope? scope =
        context.dependOnInheritedWidgetOfExactType<_FormScope>();
    return scope?._formState;
  }

  /// The widget below this widget in the tree.
  ///
  /// This is the root of the widget hierarchy that contains this form.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  ///
  /// If the callback returns a Future that resolves to false, the form's route
  /// will not be popped.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], another widget that provides a way to intercept the
  ///    back button.
  final WillPopCallback? onWillPop;

  /// Called when one of the form fields changes.
  ///
  /// In addition to this callback being invoked, all the form fields themselves
  /// will rebuild.
  final VoidCallback? onChanged;

  /// Used to enable/disable form fields auto validation and update their error
  /// text.
  ///
  /// {@macro flutter.widgets.FormField.autovalidateMode}
  final AutovalidateMode autovalidateMode;

  @override
  FormTestState createState() => FormTestState();
}

/// State associated with a [FormTest] widget.
///
/// A [FormTestState] object can be used to [save], [reset], and [validate] every
/// [FormField] that is a descendant of the associated [FormTest].
///
/// Typically obtained via [FormTest.of].
class FormTestState extends State<FormTest> {
  int _generation = 0;
  bool _hasInteractedByUser = false;
  final Set<FormFieldState<dynamic>> _fields = <FormFieldState<dynamic>>{};

  // Called when a form field has changed. This will cause all form fields
  // to rebuild, useful if form fields have interdependencies.
  void _fieldDidChange() {
    widget.onChanged?.call();

    _hasInteractedByUser = _fields.any(
        (FormFieldState<dynamic> field) => field._hasInteractedByUser.value);
    _forceRebuild();
  }

  void _forceRebuild() {
    setState(() {
      ++_generation;
    });
  }

  void _register(FormFieldState<dynamic> field) {
    _fields.add(field);
  }

  void _unregister(FormFieldState<dynamic> field) {
    _fields.remove(field);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.autovalidateMode) {
      case AutovalidateMode.always:
        _validate();
        break;
      case AutovalidateMode.onUserInteraction:
        if (_hasInteractedByUser) {
          _validate();
        }
        break;
      case AutovalidateMode.disabled:
        break;
    }

    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: _FormScope(
        formState: this,
        generation: _generation,
        child: widget.child,
      ),
    );
  }

  /// Saves every [FormField] that is a descendant of this [FormTest].
  void save() {
    for (final FormFieldState<dynamic> field in _fields) field.save();
  }

  /// Resets every [FormField] that is a descendant of this [FormTest] back to its
  /// [FormField.initialValue].
  ///
  /// The [FormTest.onChanged] callback will be called.
  ///
  /// If the form's [FormTest.autovalidateMode] property is [AutovalidateMode.always],
  /// the fields will all be revalidated after being reset.
  void reset() {
    for (final FormFieldState<dynamic> field in _fields) field.reset();
    _hasInteractedByUser = false;
    _fieldDidChange();
  }

  /// Validates every [FormField] that is a descendant of this [FormTest], and
  /// returns true if there are no errors.
  ///
  /// The form will rebuild to report the results.
  bool validate() {
    _hasInteractedByUser = true;
    _forceRebuild();
    return _validate();
  }

  bool _validate() {
    bool hasError = false;
    for (final FormFieldState<dynamic> field in _fields)
      hasError = !field.validate() || hasError;
    return !hasError;
  }
}

class _FormScope extends InheritedWidget {
  const _FormScope({
    Key? key,
    required Widget child,
    required FormTestState formState,
    required int generation,
  })  : _formState = formState,
        _generation = generation,
        super(key: key, child: child);

  final FormTestState _formState;

  /// Incremented every time a form field has changed. This lets us know when
  /// to rebuild the form.
  final int _generation;

  /// The [FormTest] associated with this widget.
  FormTest get form => _formState.widget;

  @override
  bool updateShouldNotify(_FormScope old) => _generation != old._generation;
}

/// Signature for validating a form field.
///
/// Returns an error string to display if the input is invalid, or null
/// otherwise.
///
/// Used by [FormField.validator].
typedef FormFieldValidator<T> = String? Function(T? value);

/// Signature for being notified when a form field changes value.
///
/// Used by [FormField.onSaved].
typedef FormFieldSetter<T> = void Function(T? newValue);

/// Signature for building the widget representing the form field.
///
/// Used by [FormField.builder].
typedef FormFieldBuilder<T> = Widget Function(FormFieldState<T> field);

/// A single form field.
///
/// This widget maintains the current state of the form field, so that updates
/// and validation errors are visually reflected in the UI.
///
/// When used inside a [FormTest], you can use methods on [FormTestState] to query or
/// manipulate the form data as a whole. For example, calling [FormTestState.save]
/// will invoke each [FormField]'s [onSaved] callback in turn.
///
/// Use a [GlobalKey] with [FormField] if you want to retrieve its current
/// state, for example if you want one form field to depend on another.
///
/// A [FormTest] ancestor is not required. The [FormTest] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [FormTest],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// See also:
///
///  * [FormTest], which is the widget that aggregates the form fields.
///  * [TextField], which is a commonly used form field for entering text.
class FormField<T> extends StatefulWidget {
  /// Creates a single form field.
  ///
  /// The [builder] argument must not be null.
  const FormField({
    Key? key,
    required this.builder,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true,
    AutovalidateMode? autovalidateMode,
    this.restorationId,
  })  : assert(builder != null),
        autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled,
        super(key: key);

  /// An optional method to call with the final value when the form is saved via
  /// [FormTestState.save].
  final FormFieldSetter<T>? onSaved;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  ///
  /// The returned value is exposed by the [FormFieldState.errorText] property.
  /// The [TextFormField] uses this to override the [InputDecoration.errorText]
  /// value.
  ///
  /// Alternating between error and normal state can cause the height of the
  /// [TextFormField] to change if no other subtext decoration is set on the
  /// field. To create a field whose height is fixed regardless of whether or
  /// not an error is displayed, either wrap the  [TextFormField] in a fixed
  /// height parent like [SizedBox], or set the [InputDecoration.helperText]
  /// parameter to a space.
  final FormFieldValidator<T>? validator;

  /// Function that returns the widget representing this form field. It is
  /// passed the form field state as input, containing the current value and
  /// validation state of this field.
  final FormFieldBuilder<T> builder;

  /// An optional value to initialize the form field to, or null otherwise.
  final T? initialValue;

  /// Whether the form is able to receive user input.
  ///
  /// Defaults to true. If [autovalidateMode] is not [AutovalidateMode.disabled],
  /// the field will be auto validated. Likewise, if this field is false, the widget
  /// will not be validated regardless of [autovalidateMode].
  final bool enabled;

  /// Used to enable/disable this form field auto validation and update its
  /// error text.
  ///
  /// {@template flutter.widgets.FormField.autovalidateMode}
  /// If [AutovalidateMode.onUserInteraction], this FormField will only
  /// auto-validate after its content changes. If [AutovalidateMode.always], it
  /// will auto-validate even without user interaction. If
  /// [AutovalidateMode.disabled], auto-validation will be disabled.
  ///
  /// Defaults to [AutovalidateMode.disabled], cannot be null.
  /// {@endtemplate}
  final AutovalidateMode autovalidateMode;

  /// Restoration ID to save and restore the state of the form field.
  ///
  /// Setting the restoration ID to a non-null value results in whether or not
  /// the form field validation persists.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  @override
  FormFieldState<T> createState() => FormFieldState<T>();
}

/// The current state of a [FormField]. Passed to the [FormFieldBuilder] method
/// for use in constructing the form field's widget.
class FormFieldState<T> extends State<FormField<T>> with RestorationMixin {
  late T? _value = widget.initialValue;
  final RestorableStringN _errorText = RestorableStringN(null);
  final RestorableBool _hasInteractedByUser = RestorableBool(false);

  /// The current value of the form field.
  T? get value => _value;

  /// The current validation error returned by the [FormField.validator]
  /// callback, or null if no errors have been triggered. This only updates when
  /// [validate] is called.
  String? get errorText => _errorText.value;

  /// True if this field has any validation errors.
  bool get hasError => _errorText.value != null;

  /// True if the current value is valid.
  ///
  /// This will not set [errorText] or [hasError] and it will not update
  /// error display.
  ///
  /// See also:
  ///
  ///  * [validate], which may update [errorText] and [hasError].
  bool get isValid => widget.validator?.call(_value) == null;

  /// Calls the [FormField]'s onSaved method with the current value.
  void save() {
    print('FormField - save()');
    widget.onSaved?.call(value);
  }

  /// Resets the field to its initial value.
  void reset() {
    print('FormField - reset()');
    setState(() {
      _value = widget.initialValue;
      _hasInteractedByUser.value = false;
      _errorText.value = null;
    });
    FormTest.of(context)?._fieldDidChange();
  }

  /// Calls [FormField.validator] to set the [errorText]. Returns true if there
  /// were no errors.
  ///
  /// See also:
  ///
  ///  * [isValid], which passively gets the validity without setting
  ///    [errorText] or [hasError].
  bool validate() {
    print('FormField - validate()');

    setState(() {
      _validate();
    });
    return !hasError;
  }

  void _validate() {
    if (widget.validator != null) _errorText.value = widget.validator!(_value);
  }

  /// Updates this field's state to the new value. Useful for responding to
  /// child widget changes, e.g. [Slider]'s [Slider.onChanged] argument.
  ///
  /// Triggers the [FormTest.onChanged] callback and, if [FormTest.autovalidateMode] is
  /// [AutovalidateMode.always] or [AutovalidateMode.onUserInteraction],
  /// revalidates all the fields of the form.
  void didChange(T? value) {
    print('FormField - didChange() - value = $value');
    setState(() {
      _value = value;
      _hasInteractedByUser.value = true;
    });
    FormTest.of(context)?._fieldDidChange();
  }

  /// Sets the value associated with this form field.
  ///
  /// This method should only be called by subclasses that need to update
  /// the form field value due to state changes identified during the widget
  /// build phase, when calling `setState` is prohibited. In all other cases,
  /// the value should be set by a call to [didChange], which ensures that
  /// `setState` is called.
  @protected
  // ignore: use_setters_to_change_properties, (API predates enforcing the lint)
  void setValue(T? value) {
    print('FormField - setValue() - value = $value');

    _value = value;
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    print('FormField - restoreState()');

    registerForRestoration(_errorText, 'error_text');
    registerForRestoration(_hasInteractedByUser, 'has_interacted_by_user');
  }

  @override
  void deactivate() {
    print('FormField - deactivate()');
    FormTest.of(context)?._unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    print('FormField - build() - Enabled = ${widget.enabled}');
    if (widget.enabled) {
      switch (widget.autovalidateMode) {
        case AutovalidateMode.always:
          _validate();
          break;
        case AutovalidateMode.onUserInteraction:
          if (_hasInteractedByUser.value) {
            _validate();
          }
          break;
        case AutovalidateMode.disabled:
          break;
      }
    }
    FormTest.of(context)?._register(this);
    return widget.builder(this);
  }
}

/// Used to configure the auto validation of [FormField] and [FormTest] widgets.
enum AutovalidateMode {
  /// No auto validation will occur.
  disabled,

  /// Used to auto-validate [FormTest] and [FormField] even without user interaction.
  always,

  /// Used to auto-validate [FormTest] and [FormField] only after each user
  /// interaction.
  onUserInteraction,
}
