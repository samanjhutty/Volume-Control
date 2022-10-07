package com.threemusketeers.volumecontrol.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import com.threemusketeers.volumecontrol.R
import com.threemusketeers.volumecontrol.databinding.FragmentAddScenarioBinding

class AddScenarioFragment : Fragment() {
    private lateinit var binding:FragmentAddScenarioBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding=DataBindingUtil.inflate(inflater, R.layout.fragment_add_scenario, container, false)

        binding.tvCancel.setOnClickListener {
            requireActivity().supportFragmentManager.beginTransaction().apply {

                remove(AddScenarioFragment())
                replace(R.id.layoutContainer, ScenarioFragment())
            }.commit()
        }

        return binding.root
    }

}