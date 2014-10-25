angular.module('ClueApp')
.controller('PlateauCtrl', ($scope, socket) ->
    socket.init '/plateau'

    $scope.modal = 'start'
    $scope.pions = {}

    socket.on 'prop', (prop) ->
        $scope.currProp = prop
        $scope.modal = 'prop'

    socket.on 'doneProp', ->
        $scope.modal = null

    socket.on 'won', (data)->
        $scope.winner = data
        $scope.modal = 'won'

    socket.on 'lost', (team, cb) ->
        $scope.loser = team
        $scope.modal = 'lost'
        $scope.dismissLost = cb

    socket.on 'turn', (team) ->
        $scope.currPlayer = team
        $scope.modal = 'turn'

    socket.on 'add', (data) ->
        console.log 'add', data
        $scope.pions[data.key] = data.value

    socket.on 'roll', (res) ->
        $scope.modal = 'dice'
        $scope.d1 = res.d1
        $scope.d2 = res.d2

    socket.on 'move', (data) ->
        console.log 'move', data
        $scope.modal = null
        currX = $scope.pions[data.id].x
        currY = $scope.pions[data.id].y
        diffX = data.x - currX
        diffY = data.y - currY
        time = 1000
        start = performance.now()
        func = ->
            now = (performance.now() - start)
            $scope.$apply ->
                if now <= time
                        if currX isnt data.x
                            newX = currX + (diffX * (now / time))
                            $scope.pions[data.id].x = newX
                        if currY isnt data.y
                            newY = currY + (diffY * (now / time))
                            $scope.pions[data.id].y = newY
                        requestAnimationFrame func
                else
                    if currX isnt data.x
                        $scope.pions[data.id].x = data.x
                    if currY isnt data.y
                        $scope.pions[data.id].y = data.y
        requestAnimationFrame func

    $scope.onStart = ->
        socket.emit 'start'
        $scope.modal = null
)
