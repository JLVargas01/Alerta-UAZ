package com.example.alerta_uaz

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.os.Handler
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger

class ShakeDetectorService : Service(), SensorEventListener {

    // Gestiona los sensores del dispositivo.
    private lateinit var sensorManager: SensorManager
    // Sensor de acelerómetro.
    private var accelerometer: Sensor? = null
    private lateinit var channel: MethodChannel
    // Umbral de fuerza G para considerar que ha ocurrido una agitación.
    private val shakeThreshold = 45.0

    // Bandera para detectar si una agitación ha sido ya detectada.
    private var shakeDetected = false

    // Handler para manejar el temporizador y las tareas en la cola de mensajes.
    private val handler = Handler()

    // Temporizador para evaluar agitación continua.
   private val continuousShakeTimeout = 5000L

   override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val messenger = intent.getParcelableExtra<BinaryMessenger>("messenger")
        if (messenger != null) {
            channel = MethodChannel(messenger, "com.example.alerta_uaz/shake")
            setupMethodChannel()
        }
        return START_STICKY
    }


    private fun setupMethodChannel() {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "updateShakeSensitivity" -> {
                    val sensitivity = call.argument<Double>("sensitivity") ?: 0.0
                    updateShakeSensitivity(sensitivity)
                    result.success(null)
                }
                "updateContinuousShakeTime" -> {
                    val time = call.argument<Long>("duration") ?: 0L
                    updateContinuousShakeTime(time)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

   override fun onCreate(){
    super.onCreate()

    // Configura el sensor de acelerómetro.
    sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
    accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL)
   }

   override fun onBind(intent: Intent?): IBinder? = null

    // Se llama cada vez que hay nuevos datos del sensor.
    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            val x = it.values[0]
            val y = it.values[1]
            val z = it.values[2]
            val gForce = Math.sqrt((x * x + y * y + z * z).toDouble())
    
            // Verifica si la agitación supera el umbral y si no se ha detectado recientemente.
            if (gForce > shakeThreshold && !shakeDetected) {
                shakeDetected = true  // Marca que se ha detectado una agitación.

                // Programa la verificación de agitación continua.
                handler.postDelayed({
                    channel.invokeMethod("onShake", null)  // Notifica a Flutter sobre la agitación.
                    shakeDetected = false
                }, continuousShakeTimeout)
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
    }

    // Método que permite actualizar la sensibilidad de la detección de agitación.
    fun updateShakeSensitivity(newThreshold: Double) {
        shakeThreshold = newThreshold
    }

    // Método que permite cambiar la duración de la agitación continua.
    fun updateContinuousShakeTime(newTime: Long) {
        continuousShakeTime = newTime
    }

    // Limpieza cuando el servicio es destruido.
    override fun onDestroy() {
        sensorManager.unregisterListener(this)  // Deja de escuchar al sensor.
        flutterEngine.destroy()  // Destruye el motor Flutter.
        super.onDestroy()
    }

}