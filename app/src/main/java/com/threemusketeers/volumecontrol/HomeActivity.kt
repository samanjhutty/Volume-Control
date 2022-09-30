package com.threemusketeers.volumecontrol

import android.graphics.drawable.ColorDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlin.math.sign

class HomeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)
        supportActionBar?.title="Volume Control"
        supportActionBar?.setBackgroundDrawable(ColorDrawable(resources.getColor(R.color.app_primary)))
        supportFragmentManager.beginTransaction().replace(R.id.my_container,ScenarioFragment()).commit()
    }
}