package com.perfektion.fsignalr;

import androidx.annotation.NonNull;

import com.microsoft.signalr.HttpHubConnectionBuilder;
import com.microsoft.signalr.HubConnection;
import com.microsoft.signalr.HubConnectionBuilder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.reactivex.rxjava3.core.Single;

public class HubConnectionManagerImpl implements HubConnectionManager {
    private final HubConnection hubConnection;

    private final Long id;

    private final Logger logger = LoggerFactory.getLogger(HubConnectionManager.class);

    /**
     * @noinspection FieldCanBeLocal, unused
     */
    private final FlutterPlugin.FlutterPluginBinding flutterPluginBinding;


    public HubConnectionManagerImpl(
            Messages.CreateHubConnectionManagerMessage msg,
            FlutterPlugin.FlutterPluginBinding flutterPluginBinding,
            long hubConnectionId
    ) {
        // log the current thread to console TODO: remove this line
        logger.info("HubConnectionManagerImpl constructor running on thread: " + Thread.currentThread().getName() + ", id: " + hubConnectionId);

        HttpHubConnectionBuilder hubConnectionBuilder = HubConnectionBuilder.create(msg.getBaseUrl())
                .withTransport(FsignalrPluginUtils.mapToTransportEnum(msg.getTransportType()))
                .withHandshakeResponseTimeout(msg.getHandShakeResponseTimeoutInMilliseconds())
                .withKeepAliveInterval(msg.getKeepAliveIntervalInMilliseconds())
                .withServerTimeout(msg.getServerTimeoutInMilliseconds())
                .withHeaders(msg.getHeaders());
        if (msg.getAccessToken() != null) {
            hubConnectionBuilder = hubConnectionBuilder.withAccessTokenProvider(Single.just(msg.getAccessToken()));
        }
        this.hubConnection = hubConnectionBuilder.build();

        this.id = hubConnectionId;

        this.flutterPluginBinding = flutterPluginBinding;


        logger.info(
                "Hub connection created" +
                        ", id: " + id
                        + ", baseUrl: "
                        + msg.getBaseUrl()
                        + ", transportType: "
                        + msg.getTransportType()
        );
    }

    @Override
    public void startHubConnection(@NonNull Messages.VoidResult result) {
        try {
            // log the current thread to console TODO: remove this line
            logger.info("startHubConnection running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            hubConnection.start().blockingAwait();
            logger.info("Hub connection started, id: " + id);

            result.success();
        } catch (Exception e) {
            logger.error("Hub connection start failed, id: " + id, e);
            result.error(e);
        }
    }

    @Override
    public void stopHubConnection(@NonNull Messages.VoidResult result) {
        try {
            // log the current thread to console TODO: remove this line
            logger.info("stopHubConnection running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            hubConnection.stop().blockingAwait();
            logger.info("Hub connection stopped, id: " + id);

            result.success();
        } catch (Exception e) {
            logger.error("Hub connection stop failed, id: " + id, e);
            result.error(e);
        }
    }

    @Override
    public void dispose(@NonNull Messages.VoidResult result) {
        try {
            // log the current thread to console TODO: remove this line
            logger.info("dispose running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            hubConnection.close();
            logger.info("Hub connection disposed, id: " + id);

            result.success();
        } catch (Exception e) {
            logger.error("Hub connection dispose failed, id: " + id, e);
            result.error(e);
        }
    }
}
