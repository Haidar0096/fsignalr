package com.perfektion.fsignalr;

import static com.perfektion.fsignalr.FsignalrPluginUtils.getHubConnectionManagerDoesNotExistMessage;

import androidx.annotation.NonNull;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * FsignalrPlugin
 */
public class FsignalrPlugin implements FlutterPlugin, Messages.HubConnectionManagerNativeApi {
    private static long nextHubConnectionManagerCreationId = 1;

    private final Map<Long, HubConnectionManager> hubConnectionManagers = new HashMap<>();

    private final Logger logger = LoggerFactory.getLogger(FsignalrPlugin.class);

    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Messages.HubConnectionManagerNativeApi.setUp(flutterPluginBinding.getBinaryMessenger(), this);
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Messages.HubConnectionManagerNativeApi.setUp(binding.getBinaryMessenger(), null);
        this.flutterPluginBinding = null;
    }

    @Override
    public void createHubConnectionManager(
            @NonNull Messages.CreateHubConnectionManagerMessage msg,
            @NonNull Messages.Result<Messages.HubConnectionManagerIdMessage> result
    ) {
        try {
            final long newHubConnectionManagerId = nextHubConnectionManagerCreationId++;
            HubConnectionManager hubConnectionManager = new HubConnectionManagerImpl(
                    msg,
                    flutterPluginBinding,
                    newHubConnectionManagerId
            );
            hubConnectionManagers.put(newHubConnectionManagerId, hubConnectionManager);
            logger.info(// TODO: remove this line
                    "Created hub connection manager with id: "
                            + newHubConnectionManagerId
                            + ", managers count is now: "
                            + hubConnectionManagers.size()
            );
            final Messages.HubConnectionManagerIdMessage successResult =
                    new Messages.HubConnectionManagerIdMessage
                            .Builder()
                            .setHubConnectionManagerId(newHubConnectionManagerId)
                            .build();
            result.success(successResult);
        } catch (Exception e) {
            logger.error("Error creating hub connection manager", e);
            result.error(e);
        }
    }

    @Override
    public void startHubConnection(@NonNull Messages.HubConnectionManagerIdMessage msg, @NonNull Messages.VoidResult result) {
        final Long id = msg.getHubConnectionManagerId();
        HubConnectionManager hubConnectionManager = hubConnectionManagers.get(id);
        if (hubConnectionManager == null) {
            result.error(new Throwable(getHubConnectionManagerDoesNotExistMessage(id)));
            return;
        }

        hubConnectionManager.startHubConnection(result);
    }

    @Override
    public void stopHubConnection(@NonNull Messages.HubConnectionManagerIdMessage msg, @NonNull Messages.VoidResult result) {
        final Long id = msg.getHubConnectionManagerId();
        HubConnectionManager hubConnectionManager = hubConnectionManagers.get(id);
        if (hubConnectionManager == null) {
            result.error(new Throwable(getHubConnectionManagerDoesNotExistMessage(id)));
            return;
        }

        hubConnectionManager.stopHubConnection(result);
    }

    @Override
    public void invoke(@NonNull Messages.InvokeHubMethodMessage msg, @NonNull Messages.VoidResult result) {
        final Long id = msg.getHubConnectionManagerIdMessage().getHubConnectionManagerId();
        HubConnectionManager hubConnectionManager = hubConnectionManagers.get(id);
        if (hubConnectionManager == null) {
            result.error(new Throwable(getHubConnectionManagerDoesNotExistMessage(id)));
            return;
        }

        hubConnectionManager.invoke(msg.getMethodName(), msg.getArgs(), result);
    }

    @Override
    public void setBaseUrl(@NonNull Messages.SetBaseUrlMessage msg, @NonNull Messages.VoidResult result) {
        final Long id = msg.getHubConnectionManagerIdMessage().getHubConnectionManagerId();
        HubConnectionManager hubConnectionManager = hubConnectionManagers.get(id);
        if (hubConnectionManager == null) {
            result.error(new Throwable(getHubConnectionManagerDoesNotExistMessage(id)));
            return;
        }

        hubConnectionManager.setBaseUrl(msg.getBaseUrl(), result);
    }

    @Override
    public void disposeHubConnectionManager(@NonNull Messages.HubConnectionManagerIdMessage msg, @NonNull Messages.VoidResult result) {
        final Long id = msg.getHubConnectionManagerId();
        HubConnectionManager hubConnectionManager = hubConnectionManagers.get(id);
        if (hubConnectionManager == null) {
            result.error(new Throwable(getHubConnectionManagerDoesNotExistMessage(id)));
            return;
        }

        hubConnectionManager.dispose(result);
        hubConnectionManagers.remove(id);
    }
}
