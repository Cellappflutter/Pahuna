package com.example.pahuaa;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
 @Override
 public void configureFlutterEngine(@NonNull final FlutterEngine flutterEngine) {
 GeneratedPluginRegistrant.registerWith(flutterEngine);
 }
}
