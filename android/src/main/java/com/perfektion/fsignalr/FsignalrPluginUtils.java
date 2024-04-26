package com.perfektion.fsignalr;

import com.microsoft.signalr.TransportEnum;

public class FsignalrPluginUtils {
    public static TransportEnum mapToTransportEnum(Messages.TransportTypeMessage transportTypeMessage) {
        // Currently only websockets and long polling are supported,see
        // https://learn.microsoft.com/en-us/aspnet/core/signalr/java-client?view=aspnetcore-8.0#known-limitations
        return switch (transportTypeMessage) {
            case ALL -> TransportEnum.ALL;
            case WEB_SOCKETS -> TransportEnum.WEBSOCKETS;
            case LONG_POLLING -> TransportEnum.LONG_POLLING;
        };
    }

    public static String getHubConnectionDoesNotExistMessage(long hubConnectionManagerId) {
        return "HubConnectionManager with id " + hubConnectionManagerId + " does not exist";
    }
}
