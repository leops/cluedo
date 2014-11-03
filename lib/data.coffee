exports.teams =
    moutarde: null
    olive: null
    pervenche: null
    rose: null
    violet: null
    orange: null

exports.pions =
    moutarde:
        x: 0
        y: 17
        color: "#FFDC00"
    olive:
        x: 13
        y: 0
        color: "#3D9970"
    pervenche:
        x: 22
        y: 6
        color: "#0074D9"
    rose:
        x: 0
        y: 7
        color: "#F01252"
    violet:
        x: 22
        y: 19
        color: "#B10DC9"
    orange:
        x: 8
        y: 0
        color: "#FF851B"

exports.suspects = suspects = [
    "Colonel Moutarde",
    "Reverend Olive",
    "Madame Pervenche",
    "Professeur Violet",
    "Mademoiselle Rose",
    "Madame Leblanc"
]

exports.weapons = weapons = [
    "Matraque",
    "Clé anglaise",
    "Pistolet",
    "Poignard",
    "Corde",
    "Chandelier"
]

exports.roomData = roomData = {
    "hall":
        name: "Hall"
        x: 45
        y: 87
        exits: [
            {x: 17, y: 10}
            {x: 17, y: 11}
        ]
    "veranda":
        name: "Veranda"
        x: 12
        y: 87
        exits: [
            {x: 5, y: 18}
        ]
    "salleAManger":
        name: "Salle à Manger"
        x: 14
        y: 52
        exits: [
            {x: 5, y: 16}
            {x: 7, y: 12}
        ]
    "cuisine":
        name: "Cuisine"
        x: 10
        y: 16
        exits: [
            {x: 3, y: 7}
        ]
    "grandSalon":
        name: "Grand Salon"
        x: 44
        y: 20
        exits: [
            {x: 5, y: 6}
            {x: 8, y: 8}
            {x: 8, y: 13}
            {x: 5, y: 15}
        ]
    "petitSalon":
        name: "Petit Salon"
        x: 80
        y: 14
        exits: [
            {x: 17, y: 5}
        ]
    "bureau":
        name: "Bureau"
        x: 80
        y: 43
        exits: [
            {x: 16, y: 9}
            {x: 21, y: 13}
        ]
    "bibliotheque":
        name: "Bibliotheque"
        x: 78
        y: 67
        exits: [
            {x: 15, y: 16}
            {x: 19, y: 13}
        ]
    "studio":
        name: "Studio"
        x: 77
        y: 93
        exits: [
            {x: 16, y: 20}
        ]
}

exports.rooms = rooms = []

for key, value of roomData
    rooms.push value.name

cardList = {}
for list in [suspects, weapons, rooms]
    for card in list
        cardList[card] = {
            owned: false
            seen: false
        }

exports.cardList = cardList
