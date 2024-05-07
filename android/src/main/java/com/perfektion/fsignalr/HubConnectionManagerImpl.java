package com.perfektion.fsignalr;

import static com.perfektion.fsignalr.HubConnectionManagerUtils.mapToHubConnectionStateMessage;
import static com.perfektion.fsignalr.HubConnectionManagerUtils.mapToTransportEnum;
import static com.perfektion.fsignalr.Messages.CreateHubConnectionManagerMessage;
import static com.perfektion.fsignalr.Messages.HandledHubMethodMessage;
import static com.perfektion.fsignalr.Messages.HubConnectionManagerFlutterApi;
import static com.perfektion.fsignalr.Messages.OnHubConnectionClosedMessage;
import static com.perfektion.fsignalr.Messages.OnHubConnectionStateChangedMessage;
import static com.perfektion.fsignalr.Messages.OnMessageReceivedMessage;
import static com.perfektion.fsignalr.Messages.VoidResult;
import static com.perfektion.fsignalr.Utils.NoOpVoidResult;
import static com.perfektion.fsignalr.Utils.postOnMainThread;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.microsoft.signalr.HttpHubConnectionBuilder;
import com.microsoft.signalr.HubConnection;
import com.microsoft.signalr.HubConnectionBuilder;
import com.microsoft.signalr.HubConnectionState;
import com.microsoft.signalr.Subscription;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.reactivex.rxjava3.core.Single;

public class HubConnectionManagerImpl implements HubConnectionManager {
    private final HubConnection hubConnection;


    /**
     * The unique identifier of the hub connection manager.
     */
    private final Long id;

    private final Logger logger = LoggerFactory.getLogger(HubConnectionManager.class);

    /**
     * @noinspection FieldCanBeLocal, unused
     */
    private final FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    private final HubConnectionManagerFlutterApi hubConnectionManagerFlutterApi;

    private final List<Subscription> flutterHubMethodsHandlersSubscriptions = new ArrayList<>();

    private static final int MAX_SUPPORTED_METHOD_HANDLER_ARGS = 2;


    public HubConnectionManagerImpl(
            CreateHubConnectionManagerMessage msg,
            FlutterPlugin.FlutterPluginBinding flutterPluginBinding,
            long hubConnectionManagerId
    ) {
        logger.info("`HubConnectionManagerImpl` constructor running on thread: " + Thread.currentThread().getName() + ", id: " + hubConnectionManagerId);

        HttpHubConnectionBuilder hubConnectionBuilder = HubConnectionBuilder.create(msg.getBaseUrl())
                .withTransport(mapToTransportEnum(msg.getTransportType()))
                .withHandshakeResponseTimeout(msg.getHandShakeResponseTimeoutInMilliseconds())
                .withKeepAliveInterval(msg.getKeepAliveIntervalInMilliseconds())
                .withServerTimeout(msg.getServerTimeoutInMilliseconds())
                .withHeaders(msg.getHeaders());
        if (msg.getAccessToken() != null) {
            hubConnectionBuilder = hubConnectionBuilder.withAccessTokenProvider(Single.just(msg.getAccessToken()));
        }
        this.hubConnection = hubConnectionBuilder.build();

        this.id = hubConnectionManagerId;

        this.flutterPluginBinding = flutterPluginBinding;

        this.hubConnectionManagerFlutterApi =
                new HubConnectionManagerFlutterApi(
                        flutterPluginBinding.getBinaryMessenger(),
                        id.toString()
                );

        registerOnClosedCallback();

        registerFlutterHubMethodHandlers(msg.getHandledHubMethods());

        logger.info(
                "Hub connection created" +
                        ", id: " + id
                        + ", baseUrl: "
                        + msg.getBaseUrl()
                        + ", transportType: "
                        + msg.getTransportType()
        );
    }

    private void registerOnClosedCallback() {
        hubConnection.onClosed(
                exception -> {
                    sendHubConnectionStateChangedFlutterMessage();
                    sendHubConnectionClosedMessage(exception);
                }
        );
    }

    private void sendHubConnectionStateChangedFlutterMessage() {
        sendHubConnectionStateChangedFlutterMessage(hubConnection.getConnectionState());
    }

    private void sendHubConnectionStateChangedFlutterMessage(@NonNull final HubConnectionState state) {
        sendHubConnectionStateChangedFlutterMessage_(state);
    }

    private void sendHubConnectionStateChangedFlutterMessage_(@NonNull final HubConnectionState state) {
        // post a message to flutter on the main thread, using Handler, in case we are not on the main thread
        postOnMainThread(
                () -> hubConnectionManagerFlutterApi.onHubConnectionStateChanged(
                        new OnHubConnectionStateChangedMessage
                                .Builder()
                                .setState(mapToHubConnectionStateMessage(state))
                                .build(),
                        NoOpVoidResult.INSTANCE
                )
        );
    }

    private void sendHubConnectionClosedMessage(Exception exception) {
        final String exceptionMessage = Optional.ofNullable(exception)
                .map(Throwable::getCause)
                .map(Throwable::getMessage)
                .orElse("Unknown exception");
        final OnHubConnectionClosedMessage onHubConnectionClosedMessage =
                new OnHubConnectionClosedMessage
                        .Builder()
                        .setExceptionMessage(exceptionMessage)
                        .build();
        postOnMainThread(
                () -> hubConnectionManagerFlutterApi.onConnectionClosed(
                        onHubConnectionClosedMessage,
                        NoOpVoidResult.INSTANCE
                )
        );
    }

    private void registerFlutterHubMethodHandlers(@Nullable List<HandledHubMethodMessage> handledHubMethods) {
        if (handledHubMethods == null) {
            return;
        }

        // make sure the max number of expected arguments is maxSupportedMethodHandlerArgs
        for (HandledHubMethodMessage handledHubMethod : handledHubMethods) {
            if (handledHubMethod.getArgCount() > MAX_SUPPORTED_METHOD_HANDLER_ARGS) {
                throw new IllegalArgumentException(
                        "The maximum number of arguments supported is " + MAX_SUPPORTED_METHOD_HANDLER_ARGS
                                + ", but "
                                + handledHubMethod.getArgCount()
                                + " arguments were provided for method "
                                + handledHubMethod.getMethodName()
                );
            }
        }

        for (HandledHubMethodMessage handledHubMethod : handledHubMethods) {
            if (handledHubMethod.getArgCount() == 0) {
                final Subscription noArgsSubscription = hubConnection.on(
                        handledHubMethod.getMethodName(),
                        () -> postOnMainThread(
                                () -> hubConnectionManagerFlutterApi.onMessageReceived(
                                        new OnMessageReceivedMessage
                                                .Builder()
                                                .setMethodName(handledHubMethod.getMethodName())
                                                .setArgs(null)
                                                .build(),
                                        NoOpVoidResult.INSTANCE
                                )
                        )
                );
                flutterHubMethodsHandlersSubscriptions.add(noArgsSubscription);
            } else if (handledHubMethod.getArgCount() == 1) {
                final Subscription oneArgSubscription = hubConnection.on(
                        handledHubMethod.getMethodName(),
                        (arg) -> postOnMainThread(
                                () -> hubConnectionManagerFlutterApi.onMessageReceived(
                                        new OnMessageReceivedMessage
                                                .Builder()
                                                .setMethodName(handledHubMethod.getMethodName())
                                                .setArgs(List.of(arg))
                                                .build(),
                                        NoOpVoidResult.INSTANCE
                                )
                        ),
                        String.class
                );
                flutterHubMethodsHandlersSubscriptions.add(oneArgSubscription);
            } else if (handledHubMethod.getArgCount() == 2) {
                final Subscription twoArgsSubscription = hubConnection.on(
                        handledHubMethod.getMethodName(),
                        (arg1, arg2) -> postOnMainThread(
                                () -> hubConnectionManagerFlutterApi.onMessageReceived(
                                        new OnMessageReceivedMessage
                                                .Builder()
                                                .setMethodName(handledHubMethod.getMethodName())
                                                .setArgs(List.of(arg1, arg2))
                                                .build(),
                                        NoOpVoidResult.INSTANCE
                                )
                        ),
                        String.class,
                        String.class
                );
                flutterHubMethodsHandlersSubscriptions.add(twoArgsSubscription);
            }
        }
    }

    @Override
    public void startHubConnection(@NonNull VoidResult result) {
        try {
            logger.info("`startHubConnection` running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            sendHubConnectionStateChangedFlutterMessage(HubConnectionState.CONNECTING);

            hubConnection.start().blockingAwait();
            logger.info("Hub connection started, id: " + id);

            sendHubConnectionStateChangedFlutterMessage();

            result.success();
        } catch (Exception e) {
            sendHubConnectionStateChangedFlutterMessage();
            logger.error("Hub connection start failed, id: " + id, e);
            result.error(e);
        }
    }

    @Override
    public void stopHubConnection(@NonNull VoidResult result) {
        try {
            logger.info("`stopHubConnection` running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            hubConnection.stop().blockingAwait();
            logger.info("Hub connection stopped, id: " + id);

            sendHubConnectionStateChangedFlutterMessage();

            result.success();
        } catch (Exception e) {
            sendHubConnectionStateChangedFlutterMessage();
            logger.error("Hub connection stop failed, id: " + id, e);
            result.error(e);
        }
    }

    @Override
    public void invoke(@NonNull String methodName, @Nullable List<String> args, @NonNull VoidResult result) {
        try {
            logger.info("`invoke` running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            // create the varargs object array
            if (args != null) {
                // pass the varargs string as varargs object array
                hubConnection.invoke(methodName, args.toArray()).blockingAwait();
            } else {
                // pass an empty varargs object array
                hubConnection.invoke(methodName).blockingAwait();
            }


            logger.info(
                    "Hub connection invoked, id: "
                            + id
                            + ", method: "
                            + methodName
            );
            result.success();
        } catch (Exception e) {
            logger.error("Hub connection invoke failed, id: " + id, e);
            result.error(e);
        }
    }

    @Override
    public void setBaseUrl(@NonNull String baseUrl, @NonNull VoidResult result) {
        try {
            logger.info("`setBaseUrl` running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            hubConnection.setBaseUrl(baseUrl);
            logger.info("Hub connection base url set, id: " + id);

            result.success();
        } catch (Exception e) {
            logger.error("Hub connection set base url failed, id: " + id, e);
            result.error(e);
        }
    }

    @Override
    public void dispose(@NonNull VoidResult result) {
        try {
            logger.info("`dispose` running on thread: " + Thread.currentThread().getName() + ", id: " + id);

            hubConnection.close();
            logger.info("Hub connection disposed, id: " + id);

            flutterHubMethodsHandlersSubscriptions.forEach(Subscription::unsubscribe);
            flutterHubMethodsHandlersSubscriptions.clear();

            result.success();
        } catch (Exception e) {
            logger.error("Hub connection dispose failed, id: " + id, e);
            result.error(e);
        }
    }
}
