Chat example code
=================

To run you need to start the proxy server with `-p`, the frontend with `-f public`
and the 4 server side controllers with `-c controllers/auth.coffee` `-c controllers/ping.coffee`
`-c controllers/websocket.coffee` and `-c controllers/chat.coffee`

Or all at once with 

    flora -p --port=3001 -f public -c controllers/auth.coffee -c controllers/chat.coffee -c controllers/ping.coffee -c controllers/websocket.coffee
