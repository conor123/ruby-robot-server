Robots Server
=============

About
-----

Simple Sinatra API with SQLite backend

Dependencies
============
Ruby 2.3.4
Running on Mac terminal, not tested on Windows OS

Congiguration
=============

- Please add a suitable sqlite dir

Installation
============

bundle install

Run Server
==========
ruby -Ilib app.rb

Web Endpoints
=============

Home
----
http://localhost:4567/


Testing
=======
To run a test

ruby -Ilib tests/app_test.rb

or from Rakefile (will throw some warnings, but works OK)

`rake test`

Curl Endpoints
==============

curl http://localhost:4567/server/health

curl http://localhost:4567/initialize -v

curl http://localhost:4567/robots

curl http://localhost:4567/robot/start/1

curl http://localhost:4567/robot/stop/1

curl http://localhost:4567/robot/recharge/1

curl http://localhost:4567/server/stop

curl http://localhost:4567/external/script


TODO
====

- External script manage after spawn
- Refactor code around Objects for file loading, config etc 

Done
----
- Load JSON Configs
- TDD
- Basic state management
- Shutdown Server: curl http://localhost:4567/server/stop
- External script Spawn
