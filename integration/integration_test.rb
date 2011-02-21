require "rubygems"
require "sinatra/base"
class MyApp < Sinatra::Base
  get '/' do
    send_file File.expand_path("../index.html", __FILE__)
  end
  get '/jquery.js' do
    send_file File.expand_path('../jquery-1.4.4.min.js', __FILE__)
  end
  get '/nibjs.js' do
    nibjs = Dir[File.expand_path('../../dist/*.js', __FILE__)].last
    send_file nibjs
  end
  get '/fixture.js' do
    send_file File.expand_path('../../spec/fixture.js', __FILE__)
  end
  get '/integration_test.js' do
    send_file File.expand_path('../integration_test.js', __FILE__)
  end
  post '/success' do
    puts "Everything seems fine!"
    body("Everything seems fine!")
    response.finish
    Process.kill("TERM", Process.pid)
  end
  post '/error' do
    puts "An error occured!"
    body("An error occured!")
    response.finish
    Process.kill("TERM", Process.pid)
  end
end
MyApp.run!
