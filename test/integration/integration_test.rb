require "rubygems"
require "sinatra/base"
class MyApp < Sinatra::Base
  
  def _(file)
    File.expand_path("../#{file}", __FILE__)
  end
  
  get '/' do
    send_file _("index.html")
  end
  get '/jquery.js' do
    send_file _('jquery-1.4.4.min.js')
  end
  get '/nibjs.js' do
    send_file _('../nibjs.js')
  end
  get '/fixture.js' do
    send_file _('../fixture.js')
  end
  get '/integration_test.js' do
    send_file _('integration_test.js')
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
