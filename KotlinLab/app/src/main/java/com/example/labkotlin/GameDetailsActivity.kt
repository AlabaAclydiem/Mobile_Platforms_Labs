package com.example.labkotlin

import AdapterGallery
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.example.labkotlin.databinding.ActivityGameDetailsBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.GenericTypeIndicator
import com.google.firebase.database.ValueEventListener

class GameDetailsActivity : AppCompatActivity() {

    private lateinit var binding: ActivityGameDetailsBinding
    private lateinit var firebaseAuth: FirebaseAuth
    private lateinit var adapterGalery: AdapterGallery

    private lateinit var id: String;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityGameDetailsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        id = intent.getStringExtra("id")!!

        firebaseAuth = FirebaseAuth.getInstance()

        detail()

        binding.featureBtn.setOnClickListener {
            val firebaseUserUid = firebaseAuth.currentUser!!.uid
            val ref = FirebaseDatabase.getInstance().getReference("Users")
            var features = ArrayList<String>()
            ref.addListenerForSingleValueEvent(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    features = snapshot.child(firebaseUserUid).child("favs").getValue(object : GenericTypeIndicator<ArrayList<String>>() {})!!
                    if (id in features) {
                        features.remove(id)
                        binding.featureBtn.text = "Add To Features"
                    } else {
                        features.add(id)
                        binding.featureBtn.text = "Remove From Features"
                    }
                    ref.child(firebaseUserUid).child("favs").setValue(features)
                }

                override fun onCancelled(error: DatabaseError) {
                    TODO("Not yet implemented")
                }
            })
        }

        binding.backButton.setOnClickListener {
            onBackPressed()
        }
    }

    private fun detail() {
        val f = intent.getStringExtra("f")
        val ref = FirebaseDatabase.getInstance().getReference("Games")
        ref.child(id)
            .addValueEventListener(object: ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    val title =  snapshot.child( "title").value
                    val description = snapshot.child( "description").value
                    val imageUrls: List<String> = snapshot.child( "images").value as List<String>

                    binding.title.text = title.toString()
                    binding.description.text = description.toString()

                    val viewPager = binding.imagesViewer
                    adapterGalery = AdapterGallery(imageUrls)
                    viewPager.adapter = adapterGalery

                    if (f == "true") {
                        binding.featureBtn.text = "Remove From Features"
                    } else {
                        binding.featureBtn.text = "Add To Features"
                    }

                }

                override fun onCancelled(error: DatabaseError) {
                }
            })

    }
}