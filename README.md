[![Stories in Ready](https://badge.waffle.io/jianyuan/wallgig.png?label=ready)](https://waffle.io/jianyuan/wallgig)
# [wallgig](http://wallgig.net)

[![Build Status](https://travis-ci.org/jianyuan/wallgig.png?branch=master)](https://travis-ci.org/jianyuan/wallgig)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/jianyuan/wallgig/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

* [wallgig](http://wallgig.net) is a wallpaper sharing community written in Ruby on Rails 4
* Created by Jian Yuan
* IRC: [#wallgig @ Rizon](https://qchat.rizon.net/?channels=wallgig&prompt=1)

## Technologies used
### Languages
* [Ruby](https://www.ruby-lang.org)
* [Coffeescript](http://coffeescript.org)
* [Haml](http://haml.info)
* [SASS](http://sass-lang.com)

### Server
* Elasticsearch
* PostgreSQL
* Puma
* Redis

## How to run
* The easiest way to get this up and running is by using [Vagrant](http://vagrantup.com).

### Steps
1. Install [Virtualbox](http://virtualbox.com) and [Vagrant](http://vagrantup.com).
2. Copy **.env.example** to **.env** and make changes accordingly.
3. Run `vagrant up` to download and set up the virtual machine (VM) automatically.
4. Run `vagrant ssh` to ssh into that machine. For Windows users, you should be using a Unix-like shell such as MinGW or Git Shell.
5. Inside the VM, run `bundle install` to install dependencies.
6. To start, run `foreman start`. This will boot up Sidekiq, Redis and Puma in development mode.
7. You can now access the app from [http://localhost:3000](http://localhost:3000)
8. Start hacking!
