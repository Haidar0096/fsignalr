# fsignalr

Signalr client for Flutter.

## Usage

```dart
import 'package:fsignalr/fsignalr.dart';

enum HandledMethodData {
  noArgsEchoMethod._('NoArgsEchoMethod', 0, noArgsMethodHandler),
  oneArgEchoMethod._('OneArgEchoMethod', 1, oneArgMethodHandler),
  twoArgsEchoMethod._('TwoArgsEchoMethod', 2, twoArgsMethodHandler);

  final String methodName;
  final int argsCount;
  final void Function(String methodName, List<String?>? args)? handler;

  const HandledMethodData._(this.methodName,
      this.argsCount,
      this.handler,);
}

void noArgsMethodHandler(String methodName, List<String?>? args) {
  print('NoArgsEchoMethod received, args: $args');
}

void oneArgMethodHandler(String methodName, List<String?>? args) {
  print('OneArgEchoMethod received, args: $args');
}

void twoArgsMethodHandler(String methodName, List<String?>? args) {
  print('TwoArgsEchoMethod received, args: $args');
}

Future<void> setUpConnection() async {
  try {
    // Create the hub connection manager
    final HubConnectionManager manager = HubConnectionManager();

    // Initialize the hub connection manager, this must be done
    // before calling any other method on the manager
    await manager.init(
      baseUrl: 'https://myserver.com/hub',
      transportType: TransportType.all,
      headers: {'myHeaderKey': 'myHeaderValue'},
      accessToken: 'myToken',
      handShakeResponseTimeout: const Duration(seconds: 10),
      keepAliveInterval: const Duration(seconds: 20),
      serverTimeout: const Duration(seconds: 30),
      handledHubMethods: HandledMethodData.values
          .map(
            (handledMethodData) =>
        (
        methodName: handledMethodData.methodName,
        argCount: handledMethodData.argsCount,
        ),
      )
          .toList(),
    );

    // Listen to the connection state
    manager.onHubConnectionStateChangedCallback = (state) {
      print('Connection state changed to: $state');
    };

    // listen to received messages from the server
    manager.onMessageReceivedCallback = (methodName, args) {
      for (final handledMethodData in HandledMethodData.values) {
        if (methodName == handledMethodData.methodName) {
          handledMethodData.handler?.call(methodName, args);
          break;
        }
      }
    };

    // listen to connection-closed callback
    manager.onConnectionClosedCallback = (exception) {
      print('Connection closed, exception: $exception');
    };

    // Start the connection
    await manager.startConnection();

    // invoke methods on the server
    await manager.invoke(
      methodName: 'MyServerMethodName',
      args: ['myFirstArg', 'mySecondArg'],
    );

    // stop the connection
    await manager.stopConnection();

    // start the connection again, if you want :)
    await manager.startConnection();

    // dispose the hub connection manager when done (also stops the connection)
    await manager.dispose();
  } catch (e) {
    print('Error has occurred: $e');
  }
}
```

# Acknowledgements

- For android implementation, uses the
  official [SignalR client for Java](https://github.com/dotnet/aspnetcore/tree/main/src/SignalR/clients/java/signalr)
  by Microsoft.

# Limitations

- Currently only works on android
- Currently only supports websocket transport and long polling as per
  the [official documentation](https://learn.microsoft.com/en-us/aspnet/core/signalr/java-client?view=aspnetcore-8.0#known-limitations)
- Min Android sdk supported is
  20 [reason](https://learn.microsoft.com/en-us/aspnet/core/signalr/java-client?view=aspnetcore-8.0#android-development-notes)
