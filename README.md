# PasswordlessAuth
This is the demo project for a new series I'll be writing on how to authenticate Phoenix socket connections with a password-less and database-less approach, inspired by Slack's magic link authentication.

## Scenario
Have you ever found yourself adding HTTP basic authentication to a small admin panel of some sort? Have you ended up changing it for something way more complicated? How many times did this change leave you with a feeling of unnecessary over-engineering? This small experiment relies on OTP, Phoenix Token, and email sending, to build up a secure and straightforward authentication system for a Phoenix socket connection, used by a small Elm SPA application.

## Why password-less and database-less?
Because, why not? I wanted it to be as simple as possible, taking advantage of some of the features which make Elixir and Phoenix so awesome.

## Tutorial
1.  [Project setup and the initial functionality for storing and verifying authentication tokens](http://codeloveandboards.com/blog/2018/06/09/elixir-and-phoenix-basic-passwordless-and-databaseless-authentication-pt-1)
2.  [Sending authentication link emails and the user socket connection](http://codeloveandboards.com/blog/2018/06/20/elixir-and-phoenix-basic-passwordless-and-databaseless-authentication-pt-2)
3.  [Setting up webpack as our asset bundler and the Elm single-page application](http://codeloveandboards.com/blog/2018/09/01/elixir-and-phoenix-basic-passwordless-and-databaseless-authentication-pt-3)

## Running the project
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Elm dependencies with `cd apps/passwordless_auth_web/assets/elm && elm package install`
  * Install Node.js dependencies with `cd apps/passwordless_auth_web/assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Final result
![Final result](https://monosnap.com/image/5VUT424b4Hu9ITi8r1SGae7HQleCPT.png)

Beautiful icons by https://icons8.com
