package com.amoeba.gvmarket

import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.security.MessageDigest

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        printKeyHash()
    }

    private fun printKeyHash() {
        try {
            val info = packageManager.getPackageInfo(
                "com.amoeba.gvmarket",
                PackageManager.GET_SIGNING_CERTIFICATES
            )

            val signatures = info.signingInfo?.apkContentsSigners
            signatures?.forEach { signature ->
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val keyHash = Base64.encodeToString(md.digest(), Base64.DEFAULT)
                Log.d("KeyHash:", keyHash)
            }

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
