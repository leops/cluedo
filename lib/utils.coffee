exports.pickArray = (array) ->
    id = Math.floor Math.random() * array.length
    val = array[id]
    array.splice id, 1
    return val

exports.getIP = ->
    os = require 'os'
    ifaces = os.networkInterfaces()
    ip = null
    for dev of ifaces
        ifaces[dev].forEach (details) ->
            if details.family is 'IPv4' and details.address.slice(0, 7) is '192.168'
                ip = details.address
    return ip

exports.clone = (obj) -> JSON.parse JSON.stringify obj

exports.showCell = showCell = (i, j) ->
    isBound = (0 <= i <= 24) and (0 <= j <= 23)

    isRoom = ((1 <= i <= 5 and 0 <= j <= 5) or (i == 6 and 1 <= j <= 5)) or # cuisine
    ((i == 1 and 10 <= j <= 13) or (2 <= i <= 7 and 8 <= j <= 15)) or # grand salon
    ((1 <= i <= 4 and 18 <= j <= 23) or (i == 5 and 19 <= j <= 22)) or # petit salon
    (8 <= i <= 12 and 18 <= j <= 23) or # bureau
    ((14 <= i <= 18 and 18 <= j <= 22) or (j == 17 and 15 <= i <= 17) or (j == 23 and 15 <= i <= 17)) or # bibliotheque
    ((j == 17 and 21 <= i <= 23) or (21 <= i <= 24 and 18 <= j <= 24)) or # studio
    (18 <= i <= 24 and 9 <= j <= 14) or # hall
    ((19 <= i <= 24 and 0 <= j <= 5) or (19 <= i <= 23 and j == 6)) or # veranda
    ((10 <= i <= 15 and 0 <= j <= 7) or (i == 9 and 0 <= j <= 4)) or # salle a manger
    (10 <= i <= 16 and 10 <= j <= 14) # cave

    isHidden = (i == 0 and not (j == 9 or j == 14)) or
    (i == 1 and (j == 6 or j == 17)) or
    (j == 23 and (i == 5 or i == 7 or i == 13 or i == 14 or i == 18 or i == 20)) or
    (i == 24 and (j == 6 or j == 8 or j == 15 or j == 17)) or
    (j == 1 and (i == 6 or i == 8 or i == 16 or i == 18))

    return isBound and not (isRoom or isHidden)

exports.roomEntry = roomEntry = (i, j) ->
    if i is 3 and j is 7
        return '#cuisine'
    else if (j is 5 and (i is 6 or i is 15)) or (j is 8 and (i is 8 or i is 13))
        return '#grandSalon'
    else if i is 17 and j is 5
        return '#petitSalon'
    else if (i is 16 and j is 9) or (i is 21 and j is 13)
        return '#bureau'
    else if (i is 15 and j is 16) or (i is 19 and j is 13)
        return '#bibliotheque'
    else if (i is 16 and j is 20)
        return '#studio'
    else if (i is 14 and j is 20) or (j is 17 and 10 <= i <= 11)
        return '#hall'
    else if (j is 18 and i is 5)
        return '#veranda'
    else if (i is 5 and j is 16) or (i is 7 and j is 12)
        return '#salleAManger'
    else
        return null

exports.testCell = (x, y, max) ->
    cells = {}
    rooms = []
    doTest = (x, y, max, level = 0) ->
        if level is max
            if not cells[x]?
                cells[x] = {}
            cells[x][y] = true
        if level < max
            room = roomEntry x, y
            if room?
                rooms.push room
        if level <= max
            for p in [{x: x-1, y: y}, {x: x+1, y: y}, {x: x, y: y-1}, {x: x, y: y+1}]
                valid = showCell p.y, p.x + 1
                if valid
                    doTest p.x, p.y, max, level + 1
    doTest x, y, max
    return {
        cells: cells
        rooms: rooms
    }
