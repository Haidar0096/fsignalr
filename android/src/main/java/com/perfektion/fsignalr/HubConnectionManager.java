package com.perfektion.fsignalr;

import androidx.annotation.NonNull;

public interface HubConnectionManager {
    void startHubConnection(@NonNull Messages.VoidResult result);

    void stopHubConnection(@NonNull Messages.VoidResult result);

    void dispose(@NonNull Messages.VoidResult result);
}
