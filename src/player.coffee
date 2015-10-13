angular.module('ClueApp')
.controller('PlayerCtrl', ($scope, socket) ->
    socket.init 'player'
    $scope.team = "en cours d'attribution"
    data = window.clueData
    $scope.view = 'list'
    $scope.propSuspect = null
    $scope.propWeapon = null
    $scope.propRoom = null
    $scope.solution = null
    $scope.modal = null

    $scope.accuse = ->
        console.log 'accuse'
        $scope.canRoll = false
        $scope.view = 'propose'
        $scope.room = false

    socket.on 'team', (id) ->
        console.log 'Team %s', id
        $scope.team = id

    socket.on 'cards', (cards) ->
        console.log 'cards', cards
        $scope.cat = ['suspects', 'weapons', 'rooms']
        $scope.data = cards
        $scope.cards = {}
        for c in $scope.cat
            $scope.cards[c] = []
            list = data[c]
            for name in list
                $scope.cards[c].push name

    socket.on 'turn', (data, cb) ->
        $scope.canRoll = true

        $scope.roll = ->
            cb null
            $scope.canRoll = false

        $scope.sendAccuse = ->
            $scope.view = 'list'
            cb
                suspect: $scope.propSuspect
                weapon: $scope.propWeapon
                room: $scope.propRoom

    socket.on 'end', (res) ->
        $scope.solution = res

    socket.on 'roll', (data, cb) ->
        console.log data
        for x, row of data.cells
            for y, cell of row
                jQuery("[x=#{x * 4}][y=#{y * 4}]").attr('data-final', true)
        data.rooms.forEach (room) ->
            jQuery(room + ' polygon').attr('data-final', true)

        selector = jQuery '[data-final=true]'
        handler = (e) ->
            e.preventDefault()

            elem = jQuery e.target
            data = {}
            if elem.is 'rect'
                data =
                    x: Number(elem.attr('x')) / 4
                    y: Number(elem.attr('y')) / 4
            else
                data =
                    room: elem.parent().attr('id')
            cb data
            $scope.$apply ->
                if data.room?
                    $scope.view = 'propose'
                else
                    $scope.view = 'list'

            selector.attr('data-final', false).off 'click', handler
        selector.one 'click', handler

        setTimeout ->
            $scope.$apply ->
                $scope.view = 'move'
        , 3000

    socket.on 'proposition', (room, cb) ->
        $scope.room = room
        $scope.view = 'propose'
        $scope.validateProp = ->
            console.log $scope.data, $scope.propSuspect, $scope.propWeapon
            $scope.data[$scope.propSuspect].proposed = true
            $scope.data[$scope.propWeapon].proposed = true
            val =
                suspect: $scope.propSuspect
                weapon: $scope.propWeapon
                room: room
            cb val
            console.log val
            $scope.view = 'list'

    socket.on 'infirmate', (prop, cb) ->
        $scope.view = 'refute'
        refute = []
        cards = $scope.data
        if cards[prop.suspect]?.owned
            refute.push prop.suspect
        if cards[prop.weapon]?.owned
            refute.push prop.weapon
        if cards[prop.room]?.owned
            refute.push prop.room
        $scope.refute = refute
        $scope.doRefute = (card) ->
            $scope.view = 'list'
            cb card

    socket.on 'peek', (data) ->
        $scope.peekTeam = data.from
        $scope.peekCard = data.card
        $scope.modal = 'peek'
        console.log 'peek', $scope.data[data.card], data, $scope.data
        $scope.data[data.card].seen = true

    socket.on 'noPeek', ->
        $scope.modal = 'noPeek'
)
