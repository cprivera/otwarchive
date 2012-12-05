# otw1 runs sphinx off a slave database
# server "otw1.ao3.org", :search # otw1 is gone

# otw2 runs redis, resque and memcache.
# it also runs the database migrations and can be used to get a console
server "otw2.ao3.org", :backend, :primary => true

# otw3 and otw4 are the main web/app combos
server "otw3.ao3.org", :web, :app
server "otw4.ao3.org", :app

# otw5 is the db server
server "otw5.ao3.org", :db

before "deploy:update_code", "production_only:git_in_home", "production_only:get_local_configs"
after "deploy:update_code", "production_only:update_public", "production_only:update_tag_feeds", "production_only:update_configs"

before "deploy:migrate", "production_only:backup_db"
after "deploy:restart", "production_only:update_cron_email", "production_only:update_cron_reindex"
after "deploy:restart", "production_only:notify_testers"

# deploy from clean branch
set :branch, "deploy"
