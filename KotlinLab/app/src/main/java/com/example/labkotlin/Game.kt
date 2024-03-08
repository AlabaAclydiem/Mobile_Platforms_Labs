package com.example.labkotlin

class Game {
    var id: String = "0"
    var title: String = ""
    var description: String = ""
    var images: List<String> = emptyList()

    constructor()

    constructor(id: String, title: String, description: String, images: List<String>) {
        this.id = id
        this.title = title
        this.description = description
        this.images = images
    }
}