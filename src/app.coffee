window.onbeforeunload = -> "Il est impossible de revenir dans une partie en cours"
angular.module('ClueApp', [])
.filter('length', -> (obj) ->
    keys = Object.keys obj
    if obj.length?
        return obj.length
    else if not Number.isNaN Number(obj)
        return Number(obj).toString().length
    else if keys?
        return keys.length
    else
        return -1
)
.factory('socket', ($rootScope) ->
    events = []
    return {
        socket: null
        init: (nsp) ->
            @socket = io nsp,
                reconnection: false
            for event in events
                @on.apply(@socket, event)
        on: (eventName, callback) ->
            if @socket?
                @socket.on eventName, ->
                    args = arguments
                    $rootScope.$apply ->
                        callback.apply @socket, args
            else
                events.push arguments
        emit: (eventName, data, callback) ->
            if @socket?
                @socket.emit eventName, data, ->
                    args = arguments
                    $rootScope.$apply ->
                        if callback?
                            callback.apply @socket, args
    }
)
