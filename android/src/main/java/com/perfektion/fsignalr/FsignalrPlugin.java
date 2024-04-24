package com.perfektion.fsignalr;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * FsignalrPlugin
 */
public class FsignalrPlugin implements FlutterPlugin, FsignalrPigeons.HubConnectionManagerManager {
    private final Map<Integer, FsignalrPigeons.HubConnectionManager> hubConnectionManagers = new HashMap<>();
    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        FsignalrPigeons.HubConnectionManagerManager.setUp(flutterPluginBinding.getBinaryMessenger(), this);
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        FsignalrPigeons.HubConnectionManagerManager.setUp(binding.getBinaryMessenger(), null);
        this.flutterPluginBinding = null;
    }


    @Override
    public void createHubConnectionManager(
            @NonNull Long id,
            @NonNull String baseUrl,
            @NonNull FsignalrPigeons.TransportType transportType,
            @Nullable Map<String, String> headers,
            @Nullable String accessToken,
            @NonNull Long handleShakeResponseTimeoutInMilliseconds,
            @NonNull Long keepAliveIntervalInMilliseconds,
            @NonNull Long serverTimeoutInMilliseconds,
            @NonNull FsignalrPigeons.VoidResult result
    ) {
        if (hubConnectionManagers.containsKey(id.intValue())) {
            result.error(new Throwable("HubConnectionManager with id " + id + " already exists"));
            return;
        }
        FsignalrPigeons.HubConnectionManager hubConnectionManager = new HubConnectionManagerImpl(
                id.intValue(),
                flutterPluginBinding,
                baseUrl,
                transportType,
                headers,
                accessToken,
                handleShakeResponseTimeoutInMilliseconds,
                keepAliveIntervalInMilliseconds,
                serverTimeoutInMilliseconds
        );
        hubConnectionManagers.put(id.intValue(), hubConnectionManager);
        result.success();
    }

    @Override
    public void removeHubConnectionManager(@NonNull Long id, @NonNull FsignalrPigeons.VoidResult result) {
        if (!hubConnectionManagers.containsKey(id.intValue())) {
            result.error(new Throwable("HubConnectionManager with id " + id + " does not exist"));
            return;
        }
        hubConnectionManagers.remove(id.intValue());
        result.success();
    }
}
