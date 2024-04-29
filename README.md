# fsignalr

Signalr client for Flutter.

## Usage

TODO: Add usage example

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
- See the TODO list for knowing what is not implemented yet

# TODO

- [ ] Support creating a Hub Connection with a custom HubProtocol
