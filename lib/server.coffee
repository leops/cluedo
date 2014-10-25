express = require 'express'
QRCode = require 'qrcode-js'
app = express()
data = require './data'
utils = require './utils'

app.set 'view engine', 'jade'

app.locals.showCell = utils.showCell
app.locals.addrCode = QRCode.toDataURL 'http://' + utils.getIP() + ':3000/', 4

app.use express.static('assets')

app.get '/', (req, res) ->
    res.render 'index'

app.get '/plateau', (req, res) ->
    res.render 'plateau'

app.get '/data', (req, res) ->
    res.type 'application/javascript'
    res.end 'window.clueData = ' + JSON.stringify({
        suspects: data.suspects
        weapons: data.weapons
        rooms: data.rooms
    }) + ';'

module.exports = exports = app
