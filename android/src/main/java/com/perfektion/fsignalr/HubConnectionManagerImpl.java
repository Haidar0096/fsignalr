package com.perfektion.fsignalr;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.microsoft.signalr.HttpHubConnectionBuilder;
import com.microsoft.signalr.HubConnection;
import com.microsoft.signalr.HubConnectionBuilder;

import java.util.Calendar;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.reactivex.rxjava3.core.Single;

public class HubConnectionManagerImpl implements FsignalrPigeons.HubConnectionManager {
    private final HubConnection hubConnection;
    private final int id;

    private final FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    static private String TAG = "HubConnectionManagerImpl";

    public HubConnectionManagerImpl(
            int id,
            @NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding,
            @NonNull String baseUrl,
            @NonNull FsignalrPigeons.TransportType transportType,
            @Nullable Map<String, String> headers,
            @Nullable String accessToken,//todo: see if we can pass a function instead
            @NonNull Long handleShakeResponseTimeoutInMilliseconds,
            @NonNull Long keepAliveIntervalInMilliseconds,
            @NonNull Long serverTimeoutInMilliseconds
    ) {
        HttpHubConnectionBuilder hubConnectionBuilder = HubConnectionBuilder.create(baseUrl)
                .withTransport(FsignalrPluginUtils.mapTransportEnum(transportType))
                .withHandshakeResponseTimeout(handleShakeResponseTimeoutInMilliseconds)
                .withKeepAliveInterval(keepAliveIntervalInMilliseconds)
                .withServerTimeout(serverTimeoutInMilliseconds)
                .withHeaders(headers);
        if (accessToken != null) {
            hubConnectionBuilder = hubConnectionBuilder.withAccessTokenProvider(Single.just(accessToken));
        }
        this.hubConnection = hubConnectionBuilder.build();

        this.id = id;

        this.flutterPluginBinding = flutterPluginBinding;

        FsignalrPigeons.HubConnectionManager.setUp(
                flutterPluginBinding.getBinaryMessenger(),
                "com.perfektion.fsignalr.HubConnectionManager_" + id,
                this
        );

        Log.d(TAG,
                "Hub connection created"
                        + ", id: "
                        + id
                        + ", baseUrl: "
                        + baseUrl
                        + ", transportType: "
                        + transportType
        );
    }

    @Override
    public void startHubConnection(@NonNull FsignalrPigeons.VoidResult result) {
        try {
            hubConnection.start().blockingAwait();
            hubConnection
                    .invoke("SendMessage",
                            "Android_" + id,
                            "Hello from Android, I was sent at "
                                    + Calendar.getInstance().getTime()
                    )
                    .blockingAwait();
            result.success();
            Log.d(TAG, "Hub connection started, id: " + id);
        } catch (Exception e) {
            Log.e(TAG, "Hub connection start failed, id: " + id, e);
            result.error(e);
        }
    }

    @Override
    public void stopHubConnection(@NonNull FsignalrPigeons.VoidResult result) {
        try {
            hubConnection.stop().blockingAwait();
            result.success();
            Log.d(TAG, "Hub connection stopped, id: " + id);
        } catch (Exception e) {
            result.error(e);
            Log.e(TAG, "Hub connection stop failed, id: " + id, e);
        }
    }

    @Override
    public void dispose(@NonNull FsignalrPigeons.VoidResult result) {
        try {
            hubConnection.close();
            FsignalrPigeons.HubConnectionManager.setUp(
                    flutterPluginBinding.getBinaryMessenger(),
                    "com.perfektion.fsignalr.HubConnectionManager_" + id,
                    null
            );
            result.success();
            Log.d(TAG, "Hub connection disposed, id: " + id);
        } catch (Exception e) {
            result.error(e);
            Log.e(TAG, "Hub connection dispose failed, id: " + id, e);
        }
    }
}
