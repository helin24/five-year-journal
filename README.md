##Docker Commands
- `docker-compose up`: start the project
- `docker ps`: show processes
- `docker exec -it <container name or id> bash`: enter docker container

##Notes
- Enter the docker container in order to open a rails console

###Inspect Data
- `docker ps` to find the name or id of the container
- Enter the container
- Find username and password in config/database.yml
  - Default username here is postgres
- `psql -U postgres`
- `\dt` to show all tables
- select * from users to show all users

###View params for a new entry
- Enter web docker container
- `cd log`
- `tail -f development.log`
- Create new entry in browser
