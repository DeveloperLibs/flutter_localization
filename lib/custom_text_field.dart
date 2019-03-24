import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class CustomTextField {

  final double outPrefixSvgWidth;
  final double outPrefixSvgHeight;
  final int outPrefixSvgColor;
  EdgeInsets margin;
  final TextEditingController inputBoxController;
  final bool isPassword;
  final FocusNode focusNod;
  final TextInputType keyBoardType;
  final TextAlign textAlign;
  final Widget prefix;
  final Widget suffix;
  final int textColor;
  final String textFont;
  final double textSize;
  final bool clickable;
  final int maxLength;

  CustomTextField(
      {
      this.outPrefixSvgWidth = 22.0,
      this.outPrefixSvgHeight = 22.0,
      this.outPrefixSvgColor,
      this.margin,
      this.inputBoxController,
      this.isPassword = false,
      this.focusNod,
      this.keyBoardType = TextInputType.text,
      this.prefix ,
      this.suffix ,
      this.textColor = 0xFF757575,
      this.textFont = "",
      this.textSize = 12.0,
      this.clickable = true,
      this.maxLength = 0,
      this.textAlign = TextAlign.left});

  Widget textFieldWithOutPrefix(String hint, String errorMsg) {
    var loginBtn = new Container(
      margin: margin,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          textField(hint, errorMsg),
        ],
      ),
    );

    return loginBtn;
  }

  Widget textField(String hint, String errorMsg) {
    FocusNode focusNode =
        focusNod != null ? focusNod : new FocusNode();

    var list = maxLength == 0 ? null:[
      LengthLimitingTextInputFormatter(maxLength),
    ];
    var loginBtn = new EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: new Expanded(
          child: new TextFormField(
            obscureText: isPassword,
            controller: inputBoxController,
            focusNode: focusNode,
            keyboardType: keyBoardType,
            enabled: clickable,
            textAlign: textAlign,
            inputFormatters: list,
            decoration: InputDecoration(
              labelText: hint,
              hintText: hint,
              prefixIcon: prefix,
              suffixIcon: suffix,
            ),
            validator: (val) => val.isEmpty ? errorMsg : null,
            onSaved: (val) => val,
          ),
          flex: 6,
        ));

    return loginBtn;
  }
}

class EnsureVisibleWhenFocused extends StatefulWidget {
  const EnsureVisibleWhenFocused({
    Key key,
    @required this.child,
    @required this.focusNode,
    this.curve: Curves.ease,
    this.duration: const Duration(milliseconds: 100),
  }) : super(key: key);

  /// The node we will monitor to determine if the child is focused
  final FocusNode focusNode;

  /// The child widget that we are wrapping
  final Widget child;

  /// The curve we will use to scroll ourselves into view.
  ///
  /// Defaults to Curves.ease.
  final Curve curve;

  /// The duration we will use to scroll ourselves into view
  ///
  /// Defaults to 100 milliseconds.
  final Duration duration;

  @override
  _EnsureVisibleWhenFocusedState createState() =>
      new _EnsureVisibleWhenFocusedState();
}

///
/// We implement the WidgetsBindingObserver to be notified of any change to the window metrics
///
class _EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.focusNode.removeListener(_ensureVisible);
    super.dispose();
  }

  ///
  /// This routine is invoked when the window metrics have changed.
  /// This happens when the keyboard is open or dismissed, among others.
  /// It is the opportunity to check if the field has the focus
  /// and to ensure it is fully visible in the viewport when
  /// the keyboard is displayed
  ///
  @override
  void didChangeMetrics() {
    if (widget.focusNode.hasFocus) {
      _ensureVisible();
    }
  }

  ///
  /// This routine waits for the keyboard to come into view.
  /// In order to prevent some issues if the Widget is dismissed in the
  /// middle of the loop, we need to check the "mounted" property
  ///
  /// This method was suggested by Peter Yuen (see discussion).
  ///
  Future<Null> _keyboardToggled() async {
    if (mounted) {
      EdgeInsets edgeInsets = MediaQuery.of(context).viewInsets;
      while (mounted && MediaQuery.of(context).viewInsets == edgeInsets) {
        await new Future.delayed(const Duration(milliseconds: 10));
      }
    }

    return;
  }

  Future<Null> _ensureVisible() async {
    // Wait for the keyboard to come into view
    await Future.any([
      new Future.delayed(const Duration(milliseconds: 300)),
      _keyboardToggled()
    ]);

    // No need to go any further if the node has not the focus
    if (!widget.focusNode.hasFocus) {
      return;
    }

    // Find the object which has the focus
    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    // Get the Scrollable state (in order to retrieve its offset)
    ScrollableState scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    // Get its offset
    ScrollPosition position = scrollableState.position;
    double alignment;

    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0.0;
    } else if (position.pixels < viewport.getOffsetToReveal(object, 1.0).offset) {
      // Move up to the bottom of the viewport
      alignment = 1.0;
    } else {
      // No scrolling is necessary to reveal the child
      return;
    }

    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
