# TimeSlot API Instructure


## Install Rails App
After cloning down the app, enter into the project folder.
Try typing the command below to setup the environment by docker-compose.yml.
```
docker-compose up
```
It will install essential libraries and setup the database.
However, there might be some issues when trying `bundle install`.
One of the gem had been removed yesterday (3/24) and causing ActiveStorage error when trying to deploy or bundle install.

I had tried few ways to remove activeStorage/actionMailbox/actionText, which could remove the dependency of Marcel(0.3.x) and mimemagic(0.3.2), however, it did not work well.

Supposedly, the rails app should have been setup correctly after docker-compse is run. 

After all that, the server should be running and listening to port 3000.


## API Description

There are 3 main APIs listed in `time_slots_controller.rb`, which are `index`, `create`, `delete`. The timeslot start_at and end_at are stored as integers in database.

The `users_controller.rb` was not being fully developed with user authentication but only had 1 attribute called "name", which is seeded with "Jessie" when docker runs. The main focus in this project would be time_slots_controller.

If needed to test GET Index request, simply types below url to the browser should get the response json.
```
    http://localhost:3000/users/1/time-slots
```
If needed to test POST/DELETE request, it is required to use API tester to send request body. And the required request body structure is listed below:
### create
```
    params = {
        start_at: timestamp,
        end_at: timestamp
    }
    
    post '/users/1/time-slots', params: params
```
### delete
```
    delete '/usres/1/time-slots/1'
```


## Unit Test

Unit Test should be completeted when running `docker-compose up`.
