# fsignalr

Signalr client for Flutter.

## Usage

```dart
import 'package:fsignalr/fsignalr.dart';

enum HandledMethods {
  noArgsEchoMethod._('NoArgsEchoMethod', 0),
  oneArgEchoMethod._('OneArgEchoMethod', 1),
  twoArgsEchoMethod._('TwoArgsEchoMethod', 2);

  final String methodName;
  final int argsCount;

  const HandledMethods._(this.methodName, this.argsCount);
}


Future<void> setUpConnection() async {
  try {
    // Create the hub connection manager
    final manager = await HubConnectionManager.createHubConnection(
      baseUrl: 'https://myserver.com/hub',
      transportType: TransportType.all,
      headers: {'myHeaderKey': 'myHeaderValue'},
      accessToken: 'myToken',
      handShakeResponseTimeout: const Duration(seconds: 10),
      keepAliveInterval: const Duration(seconds: 20),
      serverTimeout: const Duration(seconds: 30),
      handledHubMethods: [
        (
        methodName: HandledMethods.noArgsEchoMethod.methodName,
        argCount: HandledMethods.noArgsEchoMethod.argsCount,
        ),
        (
        methodName: HandledMethods.oneArgEchoMethod.methodName,
        argCount: HandledMethods.oneArgEchoMethod.argsCount,
        ),
        (
        methodName: HandledMethods.twoArgsEchoMethod.methodName,
        argCount: HandledMethods.twoArgsEchoMethod.argsCount,
        )
      ],
    );

    // Start the connection
    await manager.startConnection();

    // Listen to the connection state
    manager.onHubConnectionStateChangedCallback = (state) {
      print('Connection state changed to: $state');
    };

    // listen to received messages from the server
    manager.onMessageReceivedCallback = (methodName, args) {
      if (methodName == HandledMethods.noArgsEchoMethod.methodName) {
        print('NoArgsEchoMethod received, args: $args');
      } else if (methodName == HandledMethods.oneArgEchoMethod.methodName) {
        print('OneArgEchoMethod received, args: $args');
      } else if (methodName == HandledMethods.twoArgsEchoMethod.methodName) {
        print('TwoArgsEchoMethod received, args: $args');
      }
    };

    // listen to connection-closed callback
    manager.onConnectionClosedCallback = (exception) {
      print('Connection closed, exception: $exception');
    };

    // invoke methods on the server
    await hubConnectionManager.invoke(
      methodName: 'MyServerMethodName',
      args: ['myFirstArg', 'mySecondArg'],
    );

    // dispose the hub connection manager when done
    await manager.dispose();
  }
  catch (e) {
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
