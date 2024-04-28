package com.example.alerta_uaz

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle

class MainActivity: FlutterActivity(){
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = Intent(this, ShakeDetectorService::class.java)
        startService(intent)
    }
}
