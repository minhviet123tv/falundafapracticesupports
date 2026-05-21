package com.example.new_audio;

import android.os.Bundle;
import androidx.core.view.WindowCompat;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Edge-to-edge (Android 15 / SDK 35). FlutterActivity không dùng EdgeToEdge.enable().
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);
        super.onCreate(savedInstanceState);
    }
}
