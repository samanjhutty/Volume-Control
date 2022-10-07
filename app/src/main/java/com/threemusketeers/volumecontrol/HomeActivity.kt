package com.threemusketeers.volumecontrol

import android.graphics.drawable.ColorDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.threemusketeers.volumecontrol.fragments.ScenarioFragment

class HomeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)

        supportActionBar?.apply {
            title="Volume Control"
            setBackgroundDrawable(ColorDrawable(resources.getColor(R.color.app_primary)))
            elevation=0.toFloat()
        }
        supportFragmentManager.beginTransaction().add(R.id.layoutContainer, ScenarioFragment()).commit()

    }
}