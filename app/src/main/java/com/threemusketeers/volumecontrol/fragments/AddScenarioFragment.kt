package com.threemusketeers.volumecontrol.fragments

import android.app.TimePickerDialog
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.annotation.RequiresApi
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.threemusketeers.volumecontrol.R
import com.threemusketeers.volumecontrol.databinding.FragmentAddScenarioBinding
import java.util.*


class AddScenarioFragment : Fragment() {
    private lateinit var binding:FragmentAddScenarioBinding
    private val arraylist = ArrayList<String>()

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_add_scenario, container, false)

        binding.tvCancel.setOnClickListener {
            requireActivity().supportFragmentManager.beginTransaction().apply {
                setCustomAnimations(R.anim.slide_out,
                    R.anim.fade_in,
                    R.anim.fade_out,
                    R.anim.slide_in)
                remove(AddScenarioFragment())
                replace(R.id.layoutContainer, ScenarioFragment())
            }.commit()
        }

        val calender = Calendar.getInstance()
        val hour = calender.get(Calendar.HOUR_OF_DAY)
        val minute = calender.get(Calendar.MINUTE)

        binding.tvStartTime.setOnClickListener {
            val timePickerDialog = TimePickerDialog(
                requireContext(),
                { view, hourOfDay, minute ->

                    binding.tvStartTime.text = "$hourOfDay:$minute"
                }, hour, minute, true)
            timePickerDialog.show()
        }
        binding.tvEndTime.setOnClickListener {
            val timePickerDialog = TimePickerDialog(
                requireContext(),
                { view, hourOfDay, minute ->

                    binding.tvEndTime.text = "$hourOfDay:$minute"
                }, hour, minute, true)
            timePickerDialog.show()
        }


//        daysBg(binding.tvDayMon)
//        daysBg(binding.tvDayTue)
//        daysBg(binding.tvDayWed)
//        daysBg(binding.tvDayThu)
//        daysBg(binding.tvDayFri)
//        daysBg(binding.tvDaySat)
//        daysBg(binding.tvDaySun)


        return binding.root
    }
    @RequiresApi(Build.VERSION_CODES.M)
    private fun daysBg(day_id:TextView) {

        day_id.setOnClickListener {
            val buttonColor = day_id.background as ColorDrawable
            val color = buttonColor.color
            if (color == resources.getColor(android.R.color.transparent)) {
                day_id.setBackgroundTintList(resources.getColorStateList(R.color.app_primary));
                day_id.setTextColor(resources.getColor(R.color.white_light))
                arraylist.add(day_id.text.toString())
                for (i in arraylist)
                    binding.tvGetDays.text = "$i "
                for (i in arraylist)
                when (i.length) {
                        0 -> binding.tvGetDays.text = resources.getString(R.string.never)
                        1 -> binding.tvGetDays.text = i
                        else -> binding.tvGetDays.text = "$i "
                    }
            }

            else if(color == resources.getColor(R.color.app_primary)){
                day_id.setBackgroundTintList(resources.getColorStateList(android.R.color.transparent));
                day_id.setTextColor(resources.getColor(R.color.text_color))
                arraylist.remove(day_id.text.toString())
                for (i in arraylist)
                    when (i.length) {
                        0 -> binding.tvGetDays.text = resources.getString(R.string.never)
                        1 -> binding.tvGetDays.text = i
                        else -> binding.tvGetDays.text = "$i "
                    }
            }

        }
//        for (i in arraylist)
//        return i
    }
}