package com.julienvignali.phone_number;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class PhoneNumberPlugin implements FlutterPlugin {

  private MethodChannel channel;

  public static void registerWith(Registrar registrar) {
    PhoneNumberPlugin plugin = new PhoneNumberPlugin();
    plugin.startListening(registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    startListening(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    stopListening();
  }

  private void startListening(BinaryMessenger messenger) {
    channel = new MethodChannel(messenger, "com.julienvignali/phone_number");
    channel.setMethodCallHandler(new MethodCallHandlerImpl());
  }

  private void stopListening() {
    channel.setMethodCallHandler(null);
  }
}
