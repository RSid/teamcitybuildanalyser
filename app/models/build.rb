class Build
  include ActiveModel::Model
  attr_accessor :id, :time, :status, :users, :comments, :files

  def initialize(hashie_basic_build_info)
    @id = hashie_basic_build_info.id
    @status = hashie_basic_build_info.status
    @users = get_change_users(@id)
    @time = get_build_time(@id)
    @comments = get_change_comments(@id)
    @files = get_change_files(@id)
  end

  def get_build_time(id)
    TeamCity.build_statistics(id)[4].value.to_f/60000
  end

  def get_change_users(id)
    raw_build_results = TeamCity.get("changes?build=id:#{id}",
        {user: TeamCity.http_user, password: TeamCity.http_password})
    if raw_build_results["count"] == 0
        return "No changes registered"
    else
      change_users=[]
        raw_build_results["change"].each do |change|
          raw_change_info = TeamCity.get("changes/id:#{change["id"]}")
          change_users << {user: raw_change_info.username}
        end
      return change_users.flatten
    end
  end

  def get_change_comments(id)
    raw_build_results = TeamCity.get("changes?build=id:#{id}",
        {user: TeamCity.http_user, password: TeamCity.http_password})
    unless raw_build_results["count"] == 0
      change_comments=[]
        raw_build_results["change"].each do |change|
          raw_change_info = TeamCity.get("changes/id:#{change["id"]}")
          change_comments << {comments: raw_change_info.comment}
        end
      return change_comments.flatten
    end
  end

  def get_change_files(id)
    raw_build_results = TeamCity.get("changes?build=id:#{id}",
        {user: TeamCity.http_user, password: TeamCity.http_password})
    unless raw_build_results["count"] == 0
      change_files=[]
        raw_build_results["change"].each do |change|
          raw_change_info = TeamCity.get("changes/id:#{change["id"]}")
          change_files << {changed_files: raw_change_info.files}
        end
      return change_files.flatten
    end
  end
end
