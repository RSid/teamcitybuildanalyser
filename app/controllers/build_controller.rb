require 'teamcity'

class BuildController < ApplicationController

  # This only needs to be set once per Ruby execution.
  # You may use guestAuth instead of httpAuth and omit the use of http_user and http_password
  # This is using the latest version of the api
  TeamCity.configure do |config|
    config.endpoint = 'http://ci.buildium.com/httpAuth/app/rest'
    config.http_user = 'allahoffman'
    config.http_password = ''
  end

  def index
    @builds = TeamCity.builds[0..10]

    @build_info = []

    @builds.each do |build|
      @build_info << Build.new(build)
    end

    #binding.pry

    # @build_info = []
    #
    # @builds.each do |build|
    #   if build.status=="SUCCESS"
    #     @build_info << {build_id: build.id, build_status: build.status, build_time: (TeamCity.build_statistics(build.id)[4].value.to_f/60000)}
    #   end
    # end
    #
    # @build_stats = TeamCity.build_statistics(@builds[0].id)
    # @changes = get_changes_helper(@builds)
  end

  private

  # def get_changes_helper(builds)
  #   all_builds_results = []
  #   builds.each do |build|
  #       build_results = TeamCity.get("changes?build=id:#{build.id}",
  #         {user: TeamCity.http_user, password: TeamCity.http_password})
  #       if build_results["count"] == 0
  #         all_builds_results << [{build_id: build.id}, "No changes registered"]
  #       else
  #         build_changes = []
  #         build_results["change"].each do |change|
  #           raw_change_info = TeamCity.get("changes/id:#{change["id"]}")
  #           build_changes << {user: raw_change_info.username, comments: raw_change_info.comment} #, changed_files: raw_change_info.files
  #         end
  #         all_builds_results << [build_id: build.id] + build_changes
  #       end
  #   end
  #   return all_builds_results
  # end
end
