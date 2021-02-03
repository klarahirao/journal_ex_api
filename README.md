# JournalExApi (recruitment task)

Setup:

  * Install dependencies with `mix deps.get`
  * Set environment variable `GUARDIAN_SECRET_KEY`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`
  
Endpoints:

* POST    /api/users/sign_up (`username`, `first_name`, `last_name`, `age`, `password`)
* POST    /api/users/sign_in (`username`, `password`)
* GET     /api/authors/:id    
* PUT     /api/authors (`author` -> (`first_name`, `last_name`, `age`))
* GET     /api/articles?page=&page_size=    
* POST    /api/articles (`article` -> (`title`, `description`, `body`))
* DELETE  /api/articles/:id 

Authentication:
  * Use `POST /api/users/sign_up` to create new account

  * Use returned token in the authorisation header like so:

  `curl localhost:4000/api/authors/1 
    -H 'content-type: application/json' 
    -H 'authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiO...'`
