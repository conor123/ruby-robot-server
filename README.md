Robots Server
=============

About
-----

Simple Sinatra API with SQLite backend

Dependencies
============
Ruby 2.3.4

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

or from Rakefile

`rake test`

Curl Endpoints
==============

curl http://localhost:4567/server/health

curl http://localhost:4567/initialize -v

curl http://localhost:4567/robots

curl http://localhost:4567/robot/start/:id



TODO
====

- Load JSON Config

Done
----
- Load JSON Configs
- TDD
