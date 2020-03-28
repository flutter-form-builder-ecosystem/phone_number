package com.julienvignali.phone_number_example;

import android.os.Bundle;
import com.julienvignali.phone_number.PhoneNumberPlugin;
import dev.flutter.plugins.e2e.E2EPlugin;
import io.flutter.app.FlutterActivity;

public class EmbeddingV1Activity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    PhoneNumberPlugin
        .registerWith(registrarFor("com.julienvignali.phone_number.PhoneNumberPlugin"));
    E2EPlugin.registerWith(registrarFor("dev.flutter.plugins.e2e.E2EPlugin"));
  }
}
