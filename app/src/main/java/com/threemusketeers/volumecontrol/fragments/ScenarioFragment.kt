package com.threemusketeers.volumecontrol.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import com.threemusketeers.volumecontrol.R
import com.threemusketeers.volumecontrol.databinding.FragmentScenarioListBinding

/**
 * A fragment representing a list of Items.
 */
class ScenarioFragment : Fragment() {
    private lateinit var binding:FragmentScenarioListBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(inflater,R.layout.fragment_scenario_list, container, false)



        return binding.root
    }

}