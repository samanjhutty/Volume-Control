package com.threemusketeers.volumecontrol.fragments

import android.annotation.SuppressLint
import android.app.TimePickerDialog
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.databinding.DataBindingUtil
import com.threemusketeers.volumecontrol.R
import com.threemusketeers.volumecontrol.databinding.FragmentAddScenarioBinding
import java.util.*

class AddScenarioFragment : Fragment() {
    private lateinit var binding:FragmentAddScenarioBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding =
            DataBindingUtil.inflate(inflater, R.layout.fragment_add_scenario, container, false)

        binding.tvCancel.setOnClickListener {
            requireActivity().supportFragmentManager.beginTransaction().apply {

                remove(AddScenarioFragment())
                replace(R.id.layoutContainer, ScenarioFragment())
                setCustomAnimations(R.anim.slide_in, R.anim.slide_out)
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

        return binding.root
    }
}