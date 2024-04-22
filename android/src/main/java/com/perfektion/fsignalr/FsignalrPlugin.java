package com.perfektion.fsignalr;

import androidx.annotation.NonNull;

import com.perfektion.fsignalr.FsignalrPigeons.FsignalrApi;
import com.perfektion.fsignalr.FsignalrPigeons.PlatformVersionResult;

import java.util.Calendar;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * FsignalrPlugin
 */
public class FsignalrPlugin implements FlutterPlugin, FsignalrApi {
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        FsignalrApi.setUp(flutterPluginBinding.getBinaryMessenger(), this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        FsignalrApi.setUp(binding.getBinaryMessenger(), null);
    }

    @Override
    public void getPlatformVersion(@NonNull FsignalrPigeons.NullableResult<PlatformVersionResult> result) {
        final String platformVersionString = "Android " + android.os.Build.VERSION.RELEASE + " detected at " + Calendar.getInstance().getTime();
        final PlatformVersionResult successResult = new PlatformVersionResult
                .Builder()
                .setPlatformVersion(platformVersionString)
                .build();
        result.success(successResult);
    }
}
