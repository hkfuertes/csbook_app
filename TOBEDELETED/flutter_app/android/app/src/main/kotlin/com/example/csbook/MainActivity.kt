package net.mfuertes.csbook

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.KeyEvent
//import android.widget.Toast

class MainActivity: FlutterActivity() {
    private val CHANNEL = "csbook.mfuertes.net/keyboard"
    var channel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
      }
    
      //Check lib/src/helpers/AndroidKeyCode.dart for keycodes
      //Page{Up|Down}, HeadSetVolume{Up|Down}, HeadSetHook, Enter
    val listenedKeys = listOf(92,93,24,25,79,66)

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if(listenedKeys.any { it==keyCode }){
            channel?.invokeMethod("onKeyDown", listOf(keyCode))
            //Toast.makeText(this, keyCode.toString(), Toast.LENGTH_SHORT).show()
            return true
        }
        return super.onKeyDown(keyCode, event)
    }
}
