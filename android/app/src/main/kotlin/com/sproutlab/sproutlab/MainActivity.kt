package com.sproutlab.sproutlab

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.content.Intent
import android.media.AudioAttributes
import java.util.Locale

class MainActivity : FlutterActivity() {
    private var speech: TextToSpeech? = null
    private var ready = false
    private var pending: MethodChannel.Result? = null
    private var pendingId: String? = null
    private var generation = 0

    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        speech = TextToSpeech(this) { status -> ready = status == TextToSpeech.SUCCESS }
        speech?.setAudioAttributes(AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ASSISTANCE_ACCESSIBILITY)
            .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build())
        speech?.setOnUtteranceProgressListener(object : UtteranceProgressListener() {
            override fun onStart(id: String?) {}
            override fun onDone(id: String?) { finish(id, null) }
            override fun onError(id: String?) { finish(id, "Speech playback failed") }
        })
        MethodChannel(engine.dartExecutor.binaryMessenger, "sproutlab/speech")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "musicLevel" -> result.success(getSharedPreferences("comfort", MODE_PRIVATE).getFloat("musicLevel", 0.7f).toDouble())
                    "setMusicLevel" -> {
                        val level = (call.argument<Double>("level") ?: 0.7).coerceIn(0.0, 1.0)
                        getSharedPreferences("comfort", MODE_PRIVATE).edit().putFloat("musicLevel", level.toFloat()).apply()
                        result.success(null)
                    }
                    "speak" -> {
                        cancel()
                        val tts = speech
                        if (!ready || tts == null) {
                            result.error("not_ready", "Device speech is not ready. Try again.", null)
                        } else {
                            val locale = Locale.forLanguageTag(call.argument<String>("language") ?: "hi-IN")
                            val voice = tts.voices?.filter {
                                it.locale.language == locale.language && !it.isNetworkConnectionRequired
                            }?.sortedByDescending { it.quality }?.firstOrNull()
                            if (voice == null) {
                                result.error("missing_voice", "Install an offline ${locale.displayLanguage} voice in device speech settings.", null)
                            } else {
                                tts.voice = voice
                                tts.setSpeechRate(0.75f)
                                val id = "sproutlab-${++generation}"
                                pending = result
                                pendingId = id
                                val code = tts.speak(call.argument<String>("text") ?: "", TextToSpeech.QUEUE_FLUSH, null, id)
                                if (code == TextToSpeech.ERROR) finish(id, "Speech playback failed")
                            }
                        }
                    }
                    "stop" -> { cancel(); result.success(null) }
                    "settings" -> {
                        try {
                            startActivity(Intent("com.android.settings.TTS_SETTINGS"))
                            result.success(null)
                        } catch (_: Exception) { result.error("settings", "Open device Settings to install a speech voice.", null) }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun finish(id: String?, error: String?) {
        runOnUiThread {
            if (id != pendingId) return@runOnUiThread
            val result = pending
            pending = null
            pendingId = null
            if (error == null) result?.success(null) else result?.error("speech", error, null)
        }
    }
    private fun cancel() {
        speech?.stop()
        pending?.error("cancelled", "Speech stopped", null)
        pending = null
        pendingId = null
    }
    override fun onStop() { cancel(); super.onStop() }
    override fun onDestroy() { cancel(); speech?.shutdown(); speech = null; super.onDestroy() }
}
