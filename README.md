# keywords_app
## The functions are implemented in this application: 
1. Import CSV file has keywords. 
2. Search on [http://www.google.co.uk/search](http://www.google.co.uk/search) for each keyword. 
3. Using Delayed Job to search on google without stopping the process. 
4. Using Facebook Outh2 to login the app. 
5. Using `ransack` to make filter on the URLs. 
6. Using `will_paginate` to paginate URLs. 

## Clone the app & Run: 
To clone on localhost: 
```
cd 
git clone https://github.com/MohamedYakout/keywords_app.git
cd keywords_app/ 
```
To install gems in Gemfile: 
```
bundle install
```
To create DB: 
Firstly create `database.yml` in config folder with your localhost mysql credentials. [username, password]. 
Then create & migrate DB: 
```
rake db:create
rake db:migrate
``` 

## Run app & delayed jobs: 
Open two tabs in terminal, and run the following to start server: 
```
rails s
```
And this to run delayed jobs: 
```
rake jobs:work
```

## Important note to use Facebook Outh2: 
You should run the application on browser using the following URL: 
`http://lvh.me:3000/`