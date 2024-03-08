package com.example.labkotlin

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.labkotlin.databinding.RowGameBinding
import com.google.firebase.database.FirebaseDatabase

class AdapterGame(
    private val context: Context,
    private val gameArrayList: ArrayList<Game>,
    private val features: ArrayList<String>
) : RecyclerView.Adapter<AdapterGame.HolderGame>() {

    private lateinit var binding: RowGameBinding

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): HolderGame {
        binding = RowGameBinding.inflate(LayoutInflater.from(context), parent, false)
        return HolderGame(binding.root)
    }

    override fun getItemCount(): Int {
        return gameArrayList.size
    }

    override fun onBindViewHolder(holder: HolderGame, position: Int) {
        val model = gameArrayList[position]
        val id = model.id
        val name = model.title

        holder.gameTv.text = name
        holder.detailsBtn.setOnClickListener {
            toDetails(model)
        }
    }

    private fun toDetails(model: Game) {
        val id = model.id
        val ref = FirebaseDatabase.getInstance().getReference("Games")
        val intent = Intent(context, GameDetailsActivity::class.java)
        intent.putExtra("id", id)
        intent.putExtra("f", (id in features).toString())
        context.startActivity(intent)
    }

    inner class HolderGame(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var gameTv: TextView = binding.gameTv
        var detailsBtn: Button = binding.detailsBtn
    }
}