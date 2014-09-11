class Build
  include ActiveModel::Model
  attr_accessor :id, :time, :status, :users, :comments, :files, :user

  def initialize(hashie_basic_build_info)
    @id = hashie_basic_build_info.id
    @status = hashie_basic_build_info.status
    @time = get_build_time(@id)
    make_changes_api_call(@id)
  end

  private

  def make_changes_api_call(id)
    raw_build_results = TeamCity.get("changes?build=id:#{id}",
        {user: TeamCity.http_user, password: TeamCity.http_password})
    @comments = get_change_comments(raw_build_results)
    @files = get_change_files(raw_build_results)
    @users = get_change_users(raw_build_results)
  end

  def get_build_time(id)
    TeamCity.build_statistics(id)[4].value.to_f/60000
  end

  def get_change_users(raw_build_results)
    if raw_build_results["count"] == 0
        return ChangeUser.new({user: "No changes registered"})
    else
      change_users=[]
        raw_build_results["change"].each do |change|
          raw_change_info = TeamCity.get("changes/id:#{change["id"]}")
          change_users << ChangeUser.new({user: raw_change_info.username})
        end
      return change_users
    end
  end

  def get_change_comments(raw_build_results)
    unless raw_build_results["count"] == 0
      change_comments=[]
        raw_build_results["change"].each do |change|
          raw_change_info = TeamCity.get("changes/id:#{change["id"]}")
          change_comments << {comments: raw_change_info.comment}
        end
      return change_comments.flatten
    end
  end

  def get_change_files(raw_build_results)
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
