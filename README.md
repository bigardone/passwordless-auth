# PasswordlessAuth
This is the demo project for a new series I'll be writing on how to authenticate **Phoenix** socket
connections with a **password-less** and **database-less** approach, inspired by **Slack's magic link authentication**.

## Scenario
Have you ever found yourself adding **HTTP basic authentication** to a small admin panel of some sort?
Have you end up changing it for something way more complex? How many times this change left you with a feeling of
unnecessary over-engineering? This small experiment relies on **OTP**, **Phoenix Token** and email sending,
to build up a secure and simple authentication system for a Phoenix socket connection, used by a small **Elm** SPA application.

## Why password-less and database-less?
Because, why not? I wanted it to be as simple as possible, taking advantage of some of the features which make **Elixir** and **Phoenix** so awesome.

## Tutorial
Coming soon...

## Running the project
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Elm dependencies with `cd apps/passwordless_auth_web/assets/elm && elm package install`
  * Install Node.js dependencies with `cd apps/passwordless_auth_web/assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Final result
![Alt text](https://monosnap.com/image/hjQgvjcVEwRLS7I2j77UpWys3wrirq.png)

Beautiful icons by https://icons8.com
