# propile

Community Conference Program Compiler for Agile France.

Continuous delivery is ensured by Travis: [![Build Status](https://travis-ci.org/agile-france/propile.png?branch=master)](https://travis-ci.org/agile-france/propile)


## Installation

### Sysadmin

Some environment variables are needed to set up the app :

#### Database

* `PROPILE_DEV_DB_NAME`
* `PROPILE_DEV_DB_USER`
* `PROPILE_DEV_DB_PASS`
* `PROPILE_TEST_DB_NAME`
* `PROPILE_TEST_DB_USER`
* `PROPILE_TEST_DB_PASS`
* `PROPILE_PROD_DB_NAME`
* `PROPILE_PROD_DB_USER`
* `PROPILE_PROD_DB_PASS`

#### Mailer (with Sendgrid service)

* `SENDGRID_USERNAME`
* `SENDGRID_PASSWORD`

You only need the first six for a development environment, set them in your
.bashrc, .tmuxrc, or whatever you want than will set environment variables for
your application.

To create databases :

    $ sudo -u postgres psql

    postgres=# create database <PROPILE_DEV_DB_NAME>;
    postgres=# create user <PROPILE_DEV_DB_USER> with password '<PROPILE_DEV_DB_PASS>';
    postgres=# grant all privileges on database <PROPILE_DEV_DB_NAME> to <PROPILE_DEV_DB_USER>;
    postgres=# create database <PROPILE_TEST_DB_NAME>;
    postgres=# create user <PROPILE_TEST_DB_USER> with password '<PROPILE_TEST_DB_PASS>';
    postgres=# grant all privileges on database <PROPILE_TEST_DB_NAME> to <PROPILE_TEST_DB_USER>;
    postgres=# ^d

    $ bundle exec rake db:migrate
    $ RAILS_ENV=test bundle exec rake db:migrate

Then, ensure tests are passing :

    bundle exec rspec spec/


### Setup

To populate database the very first time you run the app :

    bundle exec rake db:seed


This will create a `Session` and a few `Presenter`s and `Comment`s.

To create a user for yourself :

    email, pass = 'your email', 'your pass'

    me = Account.new
    me.email = email
    me.maintainer = true # set to false if you want a presenter account
    me.password = pass
    me.password_confirmation = pass
    me.confirmed_at = Time.now
    me.save
    me.presenter.create!

You can now log in. Please note that even if you set yourself as a maintainer,
a presenter profile should still be created as `me.presenter` to avoid app
crashing when reaching dashboard.


### Mails

To be able to inspect mails on development env, please install `mailcatcher` :

    gem install mailcatcher


It will proxies all mails to a web interface that you can start using :

    mailcatcher


No mail will be sent out. You can run the application without installing or
running mailcatcher, you just won't be able to inspect mails.


## Findings about design

### Sessions and sessions

There are two kind of session in this app :

* sessions handled by `SessionsController` : sessions in a conference point of view
* sessions handled by `Account::SessionsController` : your regular session, aka log status

The `Session` model is related to former one.


### Creating accounts

To create account, go to the [configuration page](http://0.0.0.0:3000/profile_configs) and
use the "New presenter/Maintainer" link in the "Maintainers" section.

Upon completion, a confirmation email will be sent.
