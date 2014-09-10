require 'teamcity'

class TeamcityController < ApplicationController

  # This only needs to be set once per Ruby execution.
  # You may use guestAuth instead of httpAuth and omit the use of http_user and http_password
  # This is using the latest version of the api
  TeamCity.configure do |config|
    config.endpoint = 'http://ci.buildium.com/httpAuth/app/rest'
    config.http_user = [username]
    config.http_password = [password]
  end

  def index
    @build_info = TeamCity.build_statistics(237)
  end
end
