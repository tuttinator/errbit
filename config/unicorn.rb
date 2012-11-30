# http://michaelvanrooijen.com/articles/2011/06/01-more-concurrency-on-a-single-heroku-dyno-with-the-new-celadon-cedar-stack/

worker_processes 2 # amount of unicorn workers to spin up. This should be >= nr_cpus
timeout 30         # restarts workers that hang for 30 seconds
preload_app true

app_path  = File.expand_path(File.join(File.dirname(__FILE__), ".."))


pids_path = File.expand_path(File.join(File.dirname(__FILE__), "../../../shared/pids"))

listen "#{pids_path}/unicorn.obv.sock" # by default Unicorn listens on port 8080


pid "#{pids_path}/unicorn.pid"
stderr_path "#{app_path}/log/unicorn.error.log"
stdout_path "#{app_path}/log/unicorn.log"
