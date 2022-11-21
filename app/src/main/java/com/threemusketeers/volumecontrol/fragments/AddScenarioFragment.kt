package com.threemusketeers.volumecontrol.fragments

import android.app.TimePickerDialog
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.content.res.ResourcesCompat
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
    ): View {
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
                { _, hourOfDay, minute ->

                    binding.tvStartTime.text = getString(R.string.hours_minutes,hourOfDay,minute)
                }, hour, minute, true)
            timePickerDialog.show()
        }
        binding.tvEndTime.setOnClickListener {
            val timePickerDialog = TimePickerDialog(
                requireContext(),
                { _, hourOfDay, minute ->

                    binding.tvEndTime.text = getString(R.string.hours_minutes,hourOfDay,minute)
                }, hour, minute, true)
            timePickerDialog.show()
        }


        val soundMode=resources.getStringArray(R.array.sound_mode)
        binding.spinnerMode.adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_dropdown_item, soundMode)
        binding.spinnerMode.onItemSelectedListener =object :
            AdapterView.OnItemSelectedListener {
                override fun onItemSelected(
                    parent: AdapterView<*>,
                    view: View, position: Int, id: Long
                ) {
                    Toast.makeText(requireContext(), soundMode[position], Toast.LENGTH_SHORT).show()
                }

                override fun onNothingSelected(parent: AdapterView<*>) {
                    // write code to perform some action
                }
            }

        return binding.root
    }
}