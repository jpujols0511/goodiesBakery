require "sinatra"
require "httparty"
require "action_mailer"
# require "mailer.rb"

app_key = 'LFNYQTGUYBXQQOWHNEIY'

get "/" do
  def send_email(recipi)
    Newsletters.welcome_email(recipi).deliver_now
  end
  erb :home
end

get "/cakes" do
  erb :cakes
end

get "/cookies" do
  erb :cookies
end

get "/muffins" do
  erb :muffins
end

get "/events" do
  response = HTTParty.get("https://www.eventbriteapi.com/v3/events/search/?q=#{params[:createria]}&location.address=#{params[:address]}&price=free&token=#{app_key}", format: :plain)
  eventResponse = JSON.parse response, symbolize_names: true
  events = eventResponse.dig(:events)
  eventArray = []
  eventDesc = []
  eventStartDate = []
  eventImages = []
  1..9.times do |i|
    event = events[i]
    eventArray << event.dig(:name,:text)
    eventDesc << event.dig(:description,:text)
    eventStartDate << event.dig(:start,:local)
    eventImages << event.dig(:logo, :original, :url)
  end

  @eventTitles = eventArray
  @eventDescription=  eventDesc
  @eventDate = eventStartDate
  @eventImages = eventImages
  erb :events
end

get "/about" do
  erb :about
end

get "/result" do
  @firstName = params[:first_name]
  @lastName = params[:last_name]
  send_email(params[:input])
  erb :result
end

get "/cart" do
  erb :cart
end

get "/login" do
  erb :login
end
