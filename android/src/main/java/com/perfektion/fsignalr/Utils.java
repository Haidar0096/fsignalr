package com.perfektion.fsignalr;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

public class Utils {
    public static class NoOpVoidResult implements Messages.VoidResult {
        private NoOpVoidResult() {
        }

        public static final NoOpVoidResult INSTANCE = new NoOpVoidResult();

        @Override
        public void success() {
        }

        @Override
        public void error(@NonNull Throwable error) {
        }
    }

    /**
     * Posts a runnable to the main thread.
     * @param runnable The runnable to post.
     * @see Handler#post(Runnable)
     */
    public static void postOnMainThread(Runnable runnable) {
        new Handler(Looper.getMainLooper()).post(runnable);
    }
}
