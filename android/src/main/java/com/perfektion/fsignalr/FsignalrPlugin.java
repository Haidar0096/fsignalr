package com.perfektion.fsignalr;

import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.microsoft.signalr.HttpHubConnectionBuilder;
import com.microsoft.signalr.HubConnection;
import com.microsoft.signalr.HubConnectionBuilder;
import com.perfektion.fsignalr.FsignalrPigeons.FsignalrApi;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.reactivex.rxjava3.core.Single;

/**
 * FsignalrPlugin
 */
public class FsignalrPlugin implements FlutterPlugin, FsignalrApi {
    private HubConnection hubConnection;

    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        FsignalrApi.setUp(flutterPluginBinding.getBinaryMessenger(), this);
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        FsignalrApi.setUp(binding.getBinaryMessenger(), null);
        this.flutterPluginBinding = null;
    }

    @Override
    public void createHubConnection(@NonNull String baseUrl,
                                    @NonNull FsignalrPigeons.TransportType transportType,
                                    @Nullable Map<String, String> headers,
                                    @Nullable String accessTokenProviderResult,//todo: see if we can pass a function instead
                                    @NonNull Long handleShakeResponseTimeoutInMilliseconds,
                                    @NonNull Long keepAliveIntervalInMilliseconds,
                                    @NonNull Long serverTimeoutInMilliseconds,
                                    @NonNull FsignalrPigeons.VoidResult result
    ) {
        try {
            HttpHubConnectionBuilder hubConnectionBuilder = HubConnectionBuilder.create(baseUrl)
                    .withTransport(FsignalrPluginUtils.mapTransportEnum(transportType))
                    .withHandshakeResponseTimeout(handleShakeResponseTimeoutInMilliseconds)
                    .withKeepAliveInterval(keepAliveIntervalInMilliseconds)
                    .withServerTimeout(serverTimeoutInMilliseconds)
                    .withHeaders(headers);
            if (accessTokenProviderResult != null) {
                hubConnectionBuilder = hubConnectionBuilder.withAccessTokenProvider(Single.just(accessTokenProviderResult));
            }
            hubConnection = hubConnectionBuilder.build();
            result.success();
            Log.d("FsignalrPlugin",
                    "Hub connection created, baseUrl: "
                            + baseUrl
                            + ", transportType: "
                            + transportType
            );
            if (flutterPluginBinding != null) {
                Toast.makeText(flutterPluginBinding.getApplicationContext(), "Hub connection created", Toast.LENGTH_LONG).show();
            }
        } catch (Exception e) {
            result.error(e);
        }
    }
}
