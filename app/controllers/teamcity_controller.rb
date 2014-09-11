require 'teamcity'

class TeamcityController < ApplicationController
  def get_changes_helper(build_id)
    TeamCity.get("changes?build=id:#{build_id}",
      {user: TeamCity.http_user, password: TeamCity.http_password})
  end

  # This only needs to be set once per Ruby execution.
  # You may use guestAuth instead of httpAuth and omit the use of http_user and http_password
  # This is using the latest version of the api
  TeamCity.configure do |config|
    config.endpoint = 'http://ci.buildium.com/httpAuth/app/rest'
    config.http_user = 'allahoffman'
    config.http_password = ''
  end

  def index
    @builds = TeamCity.builds

    @build_info = []

    @builds.each do |build|
      @build_info << {build_id: build.id, build_status: build.status, build_time: TeamCity.build_statistics(build.id)[4].value}
    end

    @build_stats = TeamCity.build_statistics(@builds[0].id)
    @changes = get_changes_helper(@builds[5].id)
  end
end
