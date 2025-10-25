package com.swarmspace.apk

import android.app.Activity
import android.graphics.Typeface
import android.os.Bundle
import android.widget.LinearLayout
import android.widget.TextView

/**
 * Launcher activity that renders the core call-to-action for the Gradle-free build.
 * The UI intentionally avoids XML resources to keep the build pipeline lightweight.
 */
class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val container = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(48, 96, 48, 96)
        }

        val title = TextView(this).apply {
            text = "Swarm Space Mobile"
            textSize = 24f
            setTypeface(typeface, Typeface.BOLD)
        }

        val message = TextView(this).apply {
            text = "Gradle-free build pipeline ready for extension."
            textSize = 16f
        }

        container.addView(title)
        container.addView(message)
        setContentView(container)
    }
}
