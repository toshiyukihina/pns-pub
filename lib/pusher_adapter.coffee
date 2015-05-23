Adapter = require './adapter'
Pusher = require 'pusher'
Promise = require 'bluebird'

# Pusher Adapter
# https://pusher.com/
class PusherAdapter extends Adapter

  constructor: ->
    super()

    params =
      appId: process.env.PUSHER_APPID
      key: process.env.PUSHER_KEY
      secret: process.env.PUSHER_SECRET
    
    unless params.appId? and params.key? and params.secret?
      throw new Error 'You must export PUSHER_APPID/PUSHER_KEY/PUSHER_SECRET via ENV'

    @pusher = new Pusher params

  trigger: (params = {channels, name, data}) =>
    new Promise (resolve, reject) =>
      try
        @pusher.trigger params.channels, params.name, params.data
        resolve()
      catch e
        e.status = 400
        reject e

  getChannels: (options={}) =>
    new Promise (resolve, reject) =>
      try
        @pusher.get
          path: '/channels'
          params: {}
        , (error, request, response) ->
          unless error?
            resolve JSON.parse(response.body)
          else
            console.error error
            e = new Error "#{error.message}"
            reject e
      catch e
        reject(e)

module.exports = PusherAdapter
