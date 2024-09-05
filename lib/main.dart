import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'test_class.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://7a2d6972ddf232a3e7cd423f48e02e39@o691554.ingest.us.sentry.io/4507826166890496';
      options.environment = 'test';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
      options.beforeSend = (event, b) {
        print('beforeSend ${event.toJson()}');
        return event;
      };
      options.beforeSendTransaction = (transaction) {
        print('beforeSendTransaction ${transaction.transaction}:\n');
        transaction.measurements.forEach((key, value) {
          print('key: $key, value: ${value.toJson()}');
        });
        return transaction;
      };

      // https://docs.sentry.io/platforms/flutter/integrations/routing-instrumentation/#time-to-full-display
      options.enableTimeToFullDisplayTracing = true;
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      navigatorObservers: [SentryNavigatorObserver()],
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: 'MyWidget2'),
                      builder: (context) => const MyWidget2(),
                    ),
                  );
                },
                child: const Text('button'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'MyWidget'),
              builder: (context) => const MyWidget(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
