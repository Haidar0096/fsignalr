package com.perfektion.fsignalr;

public class FsignalrPluginUtils {
    public static String getHubConnectionManagerDoesNotExistMessage(long hubConnectionManagerId) {
        return "HubConnectionManager with id " + hubConnectionManagerId + " does not exist";
    }
}
