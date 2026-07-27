# DevOps Assignment, Spare 
this repo contains my solution for the received assignment from the respected company spare. the assignment revolves around containerization an api application, building a docker swarm stack of the app with a database, and creating automation of the process (GitHub actions workflow, and linux scripts)
## Creating the docker image for the api
- used a lightweight base image, since the app is small
- created non root user for security (the least privilege principle)
- tried to minimize the build time for each layer by separating the steps as much as possible
- the default command of the container, is the command that runs the app
# Creating the `docker-compose` file for the stack 
the stack is going to built of two services:
- a container from the image we created earlier
- a PostgreSQL container running the database 

notes on the docker-compose file:
- the database image is initiated first, and after that the api is initiated
- a health check is conducted on both containers (with number of retries, specific interval, and timeout)
- both containers are on the same network (so they can contact each other with their container names, and keeps the data safe)
# Creating the GitHub Actions workflow 
- we declare first what the workflow is allowed to do (read repo, and write to the registry)
- we then build the stack and perform tests on it, for any operation
- if the operation is a push or a merger, the pipeline builds an image of the api and pushes it to the registry 
# Operations Scripts
- the up function is safe to run multiple times (and the won't crash if its already running)
- there are helper functions, to print errors to `stderr`, to give information, and to ensure the user passed a service name 
- each function contains and exit if an error happens and a clear error message 
