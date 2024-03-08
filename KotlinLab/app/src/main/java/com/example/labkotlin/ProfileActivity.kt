package com.example.labkotlin

import android.app.ProgressDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.example.labkotlin.databinding.ActivityProfileBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener

class ProfileActivity : AppCompatActivity() {
    private lateinit var binding: ActivityProfileBinding
    private lateinit var progressDialog: ProgressDialog
    private lateinit var firebaseAuth: FirebaseAuth
    private var id = ""
    private var name: String? = null
    private var male: String? = null
    private var favGenre: String? = null
    private var favGame: String? = null
    private var favCountry: String? = null
    private  var favFood: String? = null
    private var surname: String? = null
    private var dateOfBirth: String? = null
    private var phoneNumber: String? = null
    private var address: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityProfileBinding.inflate(layoutInflater)
        setContentView(binding.root)
        firebaseAuth = FirebaseAuth.getInstance()

        progressDialog = ProgressDialog(this)
        id = intent.getStringExtra("id")!!

        detail()

        binding.backButton.setOnClickListener {
            onBackPressed()
        }

        binding.saveButton.setOnClickListener {
            save()
        }
    }

    private fun detail() {
        val ref = FirebaseDatabase.getInstance().getReference( "Users")
        ref.child(id)
            .addListenerForSingleValueEvent(object: ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    name = snapshot.child("name").value as? String
                    male = snapshot.child("male").value as? String
                    favGenre = snapshot.child("favGenre").value as? String
                    favGame = snapshot.child("favGame").value as? String
                    favCountry = snapshot.child("favCountry").value as? String
                    favFood = snapshot.child("favFood").value as? String
                    surname = snapshot.child("surname").value as? String
                    dateOfBirth = snapshot.child("dateOfBirth").value as? String
                    phoneNumber = snapshot.child("phoneNumber").value as? String
                    address = snapshot.child("address").value as? String

                    name?.let { binding.nameEditText.setText(it) }
                    male?.let { binding.maleEditText.setText(it) }
                    favGenre?.let { binding.favColorTextEdit.setText(it) }
                    favGame?.let { binding.favCityEditText.setText(it) }
                    favCountry?.let { binding.favCountryEditText.setText(it) }
                    favFood?.let { binding.favFoodEditText.setText(it) }
                    surname?.let { binding.surnameEditText.setText(it) }
                    dateOfBirth?.let { binding.dateOfBirthEditText.setText(it) }
                    phoneNumber?.let { binding.phoneNumberEditText.setText(it) }
                    address?.let { binding.addressEditText.setText(it) }
                }

                override fun onCancelled(error: DatabaseError) {
                }
            })

    }

    private fun save() {
        name = binding.nameEditText.text.toString().trim()
        male = binding.maleEditText.text.toString().trim()
        favGenre = binding.favColorTextEdit.text.toString().trim()
        favGame = binding.favCityEditText.text.toString().trim()
        favCountry = binding.favCountryEditText.text.toString().trim()
        favFood = binding.favFoodEditText.text.toString().trim()
        surname = binding.surnameEditText.text.toString().trim()
        dateOfBirth = binding.dateOfBirthEditText.text.toString().trim()
        phoneNumber = binding.phoneNumberEditText.text.toString().trim()
        address = binding.addressEditText.text.toString().trim()

        progressDialog.setMessage("Updating user info")
        progressDialog.show()

        val updates = hashMapOf<String, Any?>(
            "name" to name,
            "male" to male,
            "favGenre" to favGenre,
            "favGame" to favGame,
            "favCountry" to favCountry,
            "favFood" to favFood,
            "surname" to surname,
            "dateOfBirth" to dateOfBirth,
            "phoneNumber" to phoneNumber,
            "address" to address
        )

        val ref = FirebaseDatabase.getInstance().getReference("Users")
        ref.child(id)
            .updateChildren(updates)
            .addOnSuccessListener {
                progressDialog.dismiss()
                Toast.makeText(
                    this,
                    "Account updated",
                    Toast.LENGTH_SHORT
                ).show()
            }
            .addOnFailureListener { e ->
                progressDialog.dismiss()
                Toast.makeText(
                    this,
                    "Failed updating user info due to ${e.message}",
                    Toast.LENGTH_SHORT
                ).show()
            }
    }
}