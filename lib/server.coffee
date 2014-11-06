express = require 'express'
QRCode = require 'qrcode-js'
app = express()
data = require './data'
utils = require './utils'

app.set 'view engine', 'jade'

app.locals.showCell = utils.showCell

app.use express.static('assets')

app.get '/', (req, res) ->
    res.render 'index'

app.get '/plateau', (req, res) ->
    res.locals.addrCode = QRCode.toDataURL 'http://' + req.headers.host + '/', 4
    res.render 'plateau'

app.get '/data', (req, res) ->
    res.type 'application/javascript'
    res.end 'window.clueData = ' + JSON.stringify({
        suspects: data.suspects
        weapons: data.weapons
        rooms: data.rooms
    }) + ';'

module.exports = exports = app
