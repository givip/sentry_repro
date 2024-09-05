import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Widget that executes an expensive operation
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  static const delayInSeconds = 2;

  @override
  void initState() {
    super.initState();
    _doComplexOperation();
  }

  /// Attach child spans to the routing transaction
  /// or the transaction will not be sent to Sentry.
  Future<void> _doComplexOperation() async {
    await Future.delayed(const Duration(seconds: delayInSeconds));
    SentryFlutter.reportFullyDisplayed();
  }

  @override
  Widget build(BuildContext context) {
    return SentryDisplayWidget(
      child: Container(
        color: Colors.amber,
      ),
    );
    // return Container(
    //   color: Colors.amber,
    // );
  }
}

class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return SentryDisplayWidget(
      child: Container(
        color: Colors.blue,
      ),
    );
    // return Container(
    //   color: Colors.blue,
    // );
  }
}
