package com.threemusketeers.volumecontrol.fragments

import android.app.TimePickerDialog
import android.graphics.drawable.StateListDrawable
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

        daysBg(binding.tvDayMon)
        daysBg(binding.tvDayTue)
        daysBg(binding.tvDayWed)
        daysBg(binding.tvDayThu)
        daysBg(binding.tvDayFri)
        daysBg(binding.tvDaySat)
        daysBg(binding.tvDaySun)

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
    @RequiresApi(Build.VERSION_CODES.M)
    private fun daysBg(day_id:TextView) {

        day_id.setOnClickListener {
            if (day_id.isSelected) {
                day_id.setTextColor(ResourcesCompat.getColor(resources, R.color.text_color, null))
                arraylist.remove(day_id.text)
                Toast.makeText(requireContext(), "selected clicked", Toast.LENGTH_SHORT).show()
            }
            else if (!day_id.isSelected){
                day_id.setTextColor(ResourcesCompat.getColor(resources, R.color.white_light, null))
                arraylist.add(day_id.text.toString())
                Toast.makeText(requireContext(), "unselected clicked", Toast.LENGTH_SHORT).show()
//                 val statelistdrawble=StateListDrawable()
//                statelistdrawble.state = R.attr.state

            }
                else{
                    Toast.makeText(requireContext(), "Click not Working", Toast.LENGTH_SHORT).show()
                }
            }
            for (i in arraylist)
                when (i.length) {
                    0 -> binding.tvGetDays.text = resources.getString(R.string.never)
                    1 -> binding.tvGetDays.text = i
                    else -> binding.tvGetDays.text = getString(R.string.array_list_with_space_string,i)
                }

    }
}