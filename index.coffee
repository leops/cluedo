http = require 'http'
repl = require 'repl'
socket = require 'socket.io'
_ = require 'lodash'
async = require 'async'
utils = require './lib/utils'
data = require './lib/data'

app = require './lib/server'
server = http.Server app
io = socket server

players = io.of '/player'
plateau = io.of '/plateau'

started = false
teamNum = 0

teams = utils.clone data.teams
suspects = utils.clone data.suspects
weapons = utils.clone data.weapons
rooms = utils.clone data.rooms

solution =
    murderer: utils.pickArray suspects
    weapon: utils.pickArray weapons
    room: utils.pickArray rooms

cards = suspects.concat(weapons).concat(rooms)

#console.log solution

Array::shuffle = ->
    j = null
    x = null
    i = @length
    while i
        j = Math.floor Math.random() * i
        x = @[--i]
        @[i] = @[j]
        @[j] = x
    return @

teamID = ["moutarde", "olive", "pervenche", "rose", "violet", "orange"].shuffle()

getTeam = (socket) ->
    for key in teamID when not teams[key]
        teams[key] =
            socket: socket
            cards: utils.clone data.cardList
            pion: data.pions[key]
        teamNum++
        return key

turn  = (id) ->
    team = teams[id]

    nextTurn = ->
        next = teamID[teamID.indexOf(id) + 1]
        if not teams[next]?
            next = teamID[0]
        setImmediate turn, next

    if team.lost
        return nextTurn()

    plateau.emit 'turn', id
    team.socket.emit 'turn', null, (accuse) ->
        if accuse?
            console.log 'accuse', id, accuse, solution
            if accuse.suspect is solution.murderer and accuse.weapon is solution.weapon and accuse.room is solution.room
                plateau.emit 'won', {
                    team: id
                    res: solution
                }
                team.socket.emit 'end', true
            else
                team.socket.emit 'end', false
                async.each plateau.sockets, (socket, cb) ->
                    socket.emit 'lost', id, cb
                , ->
                    teams[id].lost = true
                    nextTurn()
        else
            # Jet de dé
            d1 = Math.floor(Math.random() * 6) + 1
            d2 = Math.floor(Math.random() * 6) + 1
            if team.pion.room?
                res = {}
                for exit in data.roomData[team.pion.room].exits
                    loc = utils.testCell exit.x, exit.y, (d1 + d2)
                    _.merge res, loc

                if team.pion.room is 'cuisine'
                    res.rooms.push '#studio'
                if team.pion.room is 'studio'
                    res.rooms.push '#cuisine'
                if team.pion.room is 'petitSalon'
                    res.rooms.push '#veranda'
                if team.pion.room is 'veranda'
                    res.rooms.push '#petitSalon'
            else
                res = utils.testCell team.pion.x, team.pion.y, (d1 + d2)
            plateau.emit 'roll', {d1: d1, d2: d2}
            team.socket.emit 'roll', res, (req) ->
                # Choix de la case
                res = {
                    id: id
                }
                if req.x? and req.y?
                    res.x = req.x
                    res.y = req.y
                else if req.room?
                    team.pion.room = req.room
                    room = data.roomData[req.room]
                    res.x = room.x / 4
                    res.y = room.y / 4

                plateau.emit 'move', res

                team.pion.x = res.x
                team.pion.y = res.y

                if req.room?
                    # Proposition
                    team.socket.emit 'proposition', req.room, (prop) ->
                        plateau.emit 'prop', {
                            team: id
                            info: prop
                        }
                        prop.room = data.roomData[prop.room].name
                        index = teamID.indexOf id
                        teamList = teamID.slice(index + 1, teamID.length).concat(teamID.slice(0, index))
                        console.log 'prop', id, prop
                        async.eachSeries teamList, (locId, cb) ->
                            if locId is id
                                cb null
                            else
                                locT = teams[locId]
                                if locT?
                                    locT.socket.emit 'infirmate', prop, (card) ->
                                        if not card?
                                            cb null
                                        else
                                            team.socket.emit 'peek', {
                                                from: locId
                                                card: card
                                            }
                                            cb card
                                else
                                    cb null
                        , ->
                            plateau.emit 'doneProp'
                            nextTurn()
                else
                    setTimeout nextTurn, 1500

plateau.on 'connection', (socket) ->
    socket.on 'start', ->
        if teamNum >= 3
            started = true
            cardNum = (cards.length - 1) / teamNum

            #console.log teams
            for key, team of teams
                if team?
                    for i in [0 .. cardNum]
                        card = utils.pickArray cards
                        team.cards[card].owned = true
                    team.socket.emit 'cards', team.cards
                    #console.log 'Cards for %s:', key, team.cards
                else
                    delete teams[key]
            #console.log teams
            turn teamID[0]

    for key, value of teams when value?
        socket.emit 'add', {key: key, value: value.pion}

players.on 'connection', (socket) ->
    unless started
        team = getTeam socket
        plateau.emit 'add', {key: team, value: teams[team].pion}
        socket.emit 'team', team
        console.log 'Team %s joined', team

        socket.on 'disconnect', ->
            teams[team] = null
            teamNum--;

server.listen 3000, ->
    console.log 'Listening on port 3000'

    repl.start
        prompt: '> '
        eval: (cmd, ctx, file, cb) ->
            try
                result = eval cmd
                cb null, result
            catch err
                cb err
