package com.threemusketeers.volumecontrol.fragments

import android.app.TimePickerDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.threemusketeers.volumecontrol.R
import com.threemusketeers.volumecontrol.databinding.FragmentAddScenarioBinding
import java.util.*

class AddScenarioFragment : Fragment() {
    private lateinit var binding:FragmentAddScenarioBinding

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





        return binding.root
    }
}