# Bullish

[![CircleCI](https://circleci.com/gh/EssenceOfChaos/bullish.svg?style=svg)](https://circleci.com/gh/EssenceOfChaos/bullish)

![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)

You're given a starting balance :moneybag: and a list of stocks to choose from. Choose wisely and watch your portfolio grow :chart_with_upwards_trend: ! Test out the app on [Heroku](https://bullish-app.herokuapp.com/).

---

## Contributing

Contributers will need the auth0 credentials to run the app locally and be able to authenticate. Open an [issue](https://github.com/EssenceOfChaos/bullish/issues/new) for a bug fix or to request credentials to contribute to the development of the application.

Next, you'll need to run `source .env` to load the environment variables before starting the server with `mix phx.server`.

This app uses Auth0 to authenticate a user via [auth0](https://auth0.com/).

Note: The callback URL's default to either `http://localhost:4000/auth/auth0/callback` or `http://localhost:3000/auth/auth0/callback` so make sure you are running the application on either port `3000` or `4000`.

At this point you should be able to run the app locally and successfully log in and interact with the application. The documentation for the trading API can be found at [iextrading](https://iextrading.com/developer/docs/).
