fs = require 'fs'
_io = require 'socket.io'

class Draft
	constructor: (@app) ->
		@app.get '/javascripts/draft-client.js', (req, res) ->
			res.sendfile './node_modules/draft/lib/draft-client.js'

	listen: (basedir, actions) =>
		io = _io.listen @app
		for k,action of actions
			make_cb = (action,data) -> () -> io.sockets.emit action, data
			for file in action.files
				fs.watch basedir+file, make_cb action.action, action.data

	# Emit a refresh to the client when anything changes in dir.
	listen_refresh: (dir) =>
		io = _io.listen @app
		fs.watch dir, ->
			io.sockets.emit action

module.exports = Draft