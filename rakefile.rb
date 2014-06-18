task :run do
  ruby 'lib/runner.rb'
end

task gof: :run
