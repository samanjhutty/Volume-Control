package com.threemusketeers.volumecontrol.adapter

import androidx.recyclerview.widget.RecyclerView
import android.view.LayoutInflater
import android.view.ViewGroup

import com.threemusketeers.volumecontrol.placeholder.PlaceholderContent.PlaceholderItem
import com.threemusketeers.volumecontrol.databinding.FragmentScenarioBinding

class RecyclerViewAdapterScenario(
    private val values: List<PlaceholderItem>
) : RecyclerView.Adapter<RecyclerViewAdapterScenario.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {

        return ViewHolder(
            FragmentScenarioBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
        )

    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = values[position]
    }

    override fun getItemCount(): Int = values.size

    inner class ViewHolder(binding: FragmentScenarioBinding) :
        RecyclerView.ViewHolder(binding.root) {

    }

}