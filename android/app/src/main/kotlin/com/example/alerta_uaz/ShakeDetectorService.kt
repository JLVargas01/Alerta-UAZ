package com.example.alerta_uaz


class ShakeDetectorService : Service(), SensorEventListener {

    // Gestiona los sensores del dispositivo.
    private lateinit var sensorManager:sensorManager
    // Sensor de acelerómetro.
    private var accelerometer: Sensor? = null
    private lateinit var channer: MethodChannel
    private lateinit var flutterEngine FlutterEngine

    // Umbral de fuerza G para considerar que ha ocurrido una agitación.
    private val shakeThreshold = 45.0

    // Bandera para detectar si una agitación ha sido ya detectada.
    private var shakeDetected = false

    // Handler para manejar el temporizador y las tareas en la cola de mensajes.
    private val handler = Handler()

    // Temporizador para evaluar agitación continua.
   private val continuousShakeTimeout = 5000L

   override fun onCreate(){
    super.onCreate()
    // Inicializa el motor Flutter para comunicación con la app Flutter.
    flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
    
    // Establece un canal de comunicación con Flutter.
    channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.alerta_uaz/shake")

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