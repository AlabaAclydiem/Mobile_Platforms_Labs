package com.example.labkotlin

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.example.labkotlin.databinding.ActivityUserMainBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.GenericTypeIndicator
import com.google.firebase.database.ValueEventListener

class UserMainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityUserMainBinding
    private lateinit var firebaseAuth: FirebaseAuth

    private lateinit var gameArrayList: ArrayList<Game>
    private lateinit var adapterGame: AdapterGame
    var features = ArrayList<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUserMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        firebaseAuth = FirebaseAuth.getInstance()
        val firebaseUserUid = firebaseAuth.currentUser!!.uid
        val ref = FirebaseDatabase.getInstance().getReference("Users")

        ref.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                features = snapshot.child(firebaseUserUid).child("favs").getValue(object : GenericTypeIndicator<ArrayList<String>>() {})!!
                loadGames()
            }

            override fun onCancelled(error: DatabaseError) {
                Log.e("DatabaseError", "Error reading data: ", error.toException())
            }
        })

        binding.featuresButton.setOnClickListener {
            startActivity(Intent(this, UserFeaturesActivity::class.java))
        }

        binding.userInfoButton.setOnClickListener {
            detail()
        }

        binding.logoutButton.setOnClickListener {
            firebaseAuth.signOut()
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }
    }

    private fun detail() {
        val id = firebaseAuth.currentUser?.uid
        val intent = Intent(this@UserMainActivity, ProfileActivity::class.java)
        intent.putExtra("id", id)
        this.startActivity(intent)
    }

    private fun loadGames() {
        gameArrayList = ArrayList()

        val ref = FirebaseDatabase.getInstance().getReference("Games")
        ref.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                gameArrayList.clear()
                for (ds in snapshot.children) {
                    val model = ds.getValue(Game::class.java)
                    gameArrayList.add(model!!)
                }
                adapterGame = AdapterGame(this@UserMainActivity, gameArrayList, features)
                binding.categoriesRv.adapter = adapterGame
            }

            override fun onCancelled(error: DatabaseError) {
                TODO("Not yet implemented")
            }
        })
    }
}