package com.threemusketeers.volumecontrol

import android.graphics.drawable.ColorDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.core.content.res.ResourcesCompat
import com.threemusketeers.volumecontrol.fragments.ScenarioFragment

class HomeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)

        supportActionBar?.apply {
            title=resources.getString(R.string.app_name)
            setBackgroundDrawable(ColorDrawable(ResourcesCompat.getColor(resources,R.color.app_primary,null)))
            elevation=0.toFloat()
        }
        supportFragmentManager.beginTransaction().setCustomAnimations(R.anim.slide_in,R.anim.slide_out,
            R.anim.fade_in,R.anim.slide_out).add(R.id.layoutContainer, ScenarioFragment()).commit()

    }
}