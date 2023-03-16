package com.hodoan.flutter_screen_shot

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Environment
import android.text.format.DateFormat
import android.util.Log
import android.view.View
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.renderer.FlutterRenderer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream
import java.util.*

/** FlutterScreenShotPlugin */
class FlutterScreenShotPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private lateinit var renderer: FlutterRenderer

    @Suppress("DEPRECATION")
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_screen_shot")
        renderer = flutterPluginBinding.flutterEngine.renderer
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "takeScreenShot" -> takeScreenShot(result)
            else -> result.notImplemented()
        }
    }

    private fun takeScreenShot(result: Result) {
        try {
            val window = activity?.window ?: return
            val view = activity!!.findViewById<View>( /*flutterViewId=*/FlutterActivity.FLUTTER_VIEW_ID)//window.decorView.rootView
            view.isDrawingCacheEnabled = true
//            val bitmap = renderer.bitmap
            val bitmap = Bitmap.createBitmap(
////                view.width, view.height, Bitmap.Config.ARGB_8888
                view.drawingCache
            )
            val canvas = Canvas(bitmap)
//            val bg = view.background
//            if (bg != null) {
//                bg.draw(canvas)
//            } else {
//                canvas.drawColor(Color.WHITE)
//            }
            view.draw(canvas)
            view.isDrawingCacheEnabled = false

//            val stream = ByteArrayOutputStream()
//            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
//            stream.flush()
//            stream.close()
//            val image = stream.toByteArray()
//            result.success(image.map { it })

            val date = Date()

            val format: CharSequence = DateFormat.format("yyyyMMddhhmmss", date)

            val dirpath = Environment.getExternalStorageDirectory().toString() + ""
            val path = "$dirpath/flutter_screen_shot-$format.jpeg"
            val imageurl = File(path)
            if(imageurl.createNewFile()) {
                val outputStream = FileOutputStream(imageurl)
                bitmap.compress(Bitmap.CompressFormat.JPEG, 50, outputStream)
                outputStream.flush()
                outputStream.close()
            }
        } catch (e: java.lang.Exception) {
            Log.e(FlutterScreenShotPlugin::class.simpleName, "takeScreenShot: $e")
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        activity = null
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
