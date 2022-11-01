 
# Water Bot   
This bot will help you to control your water balance 💧

Just select the desired interval and the bot will automatically remind you that you need to drink some water ⏰ 

![screenshot](https://i.ibb.co/12s9GxB/image.png)

## Technologies

![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white) 

![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)

![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
## Run Locally  

Clone the project  

~~~bash  
  git clone git@github.com:katsapvlad/water_bot.git
~~~

Go to the project directory  

~~~bash  
  cd water_bot
~~~

Install dependencies  

~~~bash  
  bundle install
~~~

Then rename  ```.env_example``` to ```.env``` and configure your own bot token and telegram ID

Create and setup database (other database and migration actions are in the ```Rakefile```)

~~~bash  
  rake db:create
  
  rake db:migrate
~~~

Start Sidekiq  

~~~bash  
  bundle exec sidekiq -r ./app/workers/reminder_worker.rb
~~~

Start the bot  

~~~bash  
  ruby entrypoint.rb
~~~

