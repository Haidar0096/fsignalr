package com.perfektion.fsignalr;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;

public interface HubConnectionManager {
    void startHubConnection(@NonNull Messages.VoidResult result);

    void stopHubConnection(@NonNull Messages.VoidResult result);

    void invoke(@NonNull String methodName, @Nullable List<String> args, @NonNull Messages.VoidResult result);

    void setBaseUrl(@NonNull String baseUrl, @NonNull Messages.VoidResult result);

    void dispose(@NonNull Messages.VoidResult result);
}
