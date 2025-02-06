package com.perfektion.fsignalr;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;

public interface HubConnectionManager {
    void startHubConnection(@NonNull Messages.Result<String> result);

    void stopHubConnection(@NonNull Messages.VoidResult result);

    void getConnectionId(@NonNull Messages.NullableResult<String> result);

    void getConnectionState(@NonNull Messages.Result<Messages.HubConnectionStateMessage> result);

    void invoke(@NonNull String methodName, @Nullable List<String> args, @NonNull Messages.VoidResult result);

    void setBaseUrl(@NonNull String baseUrl, @NonNull Messages.VoidResult result);

    void dispose(@NonNull Messages.VoidResult result);
}
