# http://michaelvanrooijen.com/articles/2011/06/01-more-concurrency-on-a-single-heroku-dyno-with-the-new-celadon-cedar-stack/

worker_processes 2 # amount of unicorn workers to spin up. This should be >= nr_cpus
timeout 30         # restarts workers that hang for 30 seconds
preload_app true

app_path  = File.expand_path(File.join(File.dirname(__FILE__), ".."))


pids_path = File.expand_path(File.join(File.dirname(__FILE__), "../../../shared/pids"))

listen "#{pids_path}/unicorn.sock" # by default Unicorn listens on port 8080


pid "#{pids_path}/unicorn.pid"
stderr_path "#{app_path}/log/unicorn.error.log"
stdout_path "#{app_path}/log/unicorn.log"

# Taken from github: https://github.com/blog/517-unicorn
# Though everyone uses pretty miuch the same code
before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
 
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
