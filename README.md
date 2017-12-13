Robots Server
=============

About
-----

Simple Sinatra API with SQLite backend

Dependencies
============
Ruby 2.3.4

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



TODO
====
- Shutdown Server
- External script
- 

Done
----
- Load JSON Configs
- TDD
- Load JSON Config
