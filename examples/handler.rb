require "rubygems"
require "sinatra/base"
class MyApp < Sinatra::Base
  
  def _(file)
    File.expand_path("../#{file}", __FILE__)
  end
  
  set :public, File.dirname(__FILE__)
  
  get '/' do
    send_file _("index.html")
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
