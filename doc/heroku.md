# Create a Heroku App

1. Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) if you haven't already.
2. Log in to your Heroku account via the CLI:
```
heroku login
```

3. Create a new Heroku app:

```
heroku create [app-name]  # Optional: specify an app name
```

4. Set Up Environment Variables on Heroku
 -  Use the Heroku CLI or dashboard to set any required environment variables.

5. Deploy to Heroku
- Deploy your application to Heroku by pushing your master/main branch to Heroku:
```
git push heroku master
```
- Heroku will detect your Ruby application, install dependencies, run your build scripts, and start your application using the command in the `Procfile`.

6. Run Database Migrations
```
heroku run rake db:migrate
```

7. Open Your App
Once deployed, you can open your app in a browser:
```
heroku open
```
