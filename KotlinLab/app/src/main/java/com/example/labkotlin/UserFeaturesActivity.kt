package com.example.labkotlin

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.example.labkotlin.databinding.ActivityUserFeaturesBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.GenericTypeIndicator
import com.google.firebase.database.ValueEventListener

class UserFeaturesActivity : AppCompatActivity() {
    private lateinit var binding: ActivityUserFeaturesBinding
    private lateinit var firebaseAuth: FirebaseAuth

    private lateinit var gameArrayList: ArrayList<Game>
    private lateinit var adapterGame: AdapterGame
    var features = ArrayList<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUserFeaturesBinding.inflate(layoutInflater)
        setContentView(binding.root)

        firebaseAuth = FirebaseAuth.getInstance()
        val firebaseUserUid = firebaseAuth.currentUser!!.uid
        val ref = FirebaseDatabase.getInstance().getReference("Users")

        binding.featuresButton.setOnClickListener {
            startActivity(Intent(this, UserMainActivity::class.java))
            finish()
        }

        binding.userInfoButton.setOnClickListener {
            detail()
        }

        binding.logoutButton.setOnClickListener {
            firebaseAuth.signOut()
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }

        ref.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                features = snapshot.child(firebaseUserUid).child("favs").getValue(object : GenericTypeIndicator<ArrayList<String>>() {})!!
                loadGames(features)
            }

            override fun onCancelled(error: DatabaseError) {
                Log.e("DatabaseError", "Error reading data: ", error.toException())
            }
        })
    }

    private fun detail() {
        val id = firebaseAuth.currentUser?.uid
        val intent = Intent(this@UserFeaturesActivity, ProfileActivity::class.java)
        intent.putExtra("id", id)
        this.startActivity(intent)
    }

    private fun loadGames(features: ArrayList<String>) {
        gameArrayList = ArrayList()

        val ref = FirebaseDatabase.getInstance().getReference("Games")
        ref.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                gameArrayList.clear()
                for (ds in snapshot.children) {
                    val model = ds.getValue(Game::class.java)!!
                    if (model.id in features) {
                        gameArrayList.add(model)
                    }
                }
                adapterGame = AdapterGame(this@UserFeaturesActivity, gameArrayList, features)
                binding.categoriesRv.adapter = adapterGame
            }

            override fun onCancelled(error: DatabaseError) {

            }
        })
    }
}