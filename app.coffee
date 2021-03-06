express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

app = express()

# view engine setup
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.set 'x-powered-by', false

# uncomment after placing your favicon in /public
# app.use favicon "#{__dirname}/public/favicon.ico"
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded
  extended: false
app.use cookieParser()
app.use require('less-middleware') path.join __dirname, 'public'
app.use express.static path.join __dirname, 'public'

index = require './routes/index'
channels = require './routes/api/v1/channels'
events = require './routes/api/v1/events'

app.use '/', index
app.use '/api/v1/channels', channels
app.use '/api/v1/events', events

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err

# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
      console.error err.stack
      res.status err.status or 500
        .json error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
    .json(err)

module.exports = app
