# JournalExApi

Setup:

  * Install dependencies with `mix deps.get`
  * Set environment variable `GUARDIAN_SECRET_KEY`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`
  
Endpoints:

* POST    /api/users/sign_up  
* POST    /api/users/sign_in  
* GET     /api/authors/:id    
* PUT     /api/authors  
* GET     /api/articles       
* POST    /api/articles  
* DELETE  /api/articles/:id 
