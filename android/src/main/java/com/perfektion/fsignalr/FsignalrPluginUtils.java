package com.perfektion.fsignalr;

import com.microsoft.signalr.HubMessage;
import com.microsoft.signalr.HubProtocol;
import com.microsoft.signalr.InvocationBinder;
import com.microsoft.signalr.TransportEnum;

import java.nio.ByteBuffer;
import java.util.List;

public class FsignalrPluginUtils {
    public static TransportEnum mapTransportEnum(FsignalrPigeons.TransportType transportType) {
        // Currently only websockets and long polling are supported,see
        // https://learn.microsoft.com/en-us/aspnet/core/signalr/java-client?view=aspnetcore-8.0#known-limitations
        switch (transportType) {
            case ALL:
                return TransportEnum.ALL;
            case WEB_SOCKETS:
                return TransportEnum.WEBSOCKETS;
            case LONG_POLLING:
                return TransportEnum.LONG_POLLING;
            default:
                throw new IllegalArgumentException("Unsupported transport type: " + transportType);
        }
    }
}
