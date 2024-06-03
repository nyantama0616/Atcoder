require './Setting.rb'
require "json"

class Contest
  attr_reader :contest_id, :contest_name, :task_name, :contest_dir, :task_dir, :contest_uri, :submittions_uri

  def initialize(contest_id)
    @contest_id = contest_id
    
    split = contest_id.split('_')
    @contest_name = split[0]
    @task_name = split[1]

    @contest_dir = "#{Setting::SOURCE_DIR}/tmp/#{@contest_name}"
    @task_dir = "#{@contest_dir}/#{@task_name}"

    @contest_uri = "https://atcoder.jp/contests/#{@contest_name}/tasks/#{@contest_id}"
    @submittions_uri = "https://atcoder.jp/contests/#{@contest_name}/submissions/me"

    create_dir
  end

  def to_json
    JSON.pretty_generate({
      contest_id: @contest_id,
      contest_name: @contest_name,
      task_name: @task_name,
      contest_dir: @contest_dir,
      task_dir: @task_dir
    })
  end

  def create_dir
    Dir.mkdir(@contest_dir) unless Dir.exist?(@contest_dir)
    Dir.mkdir(@task_dir) unless Dir.exist?(@task_dir)
  end

  def delete_dir
    FileUtils.rm_rf(@task_dir) if Dir.exist?(@task_dir)
    FileUtils.rm_rf(@contest_dir) if Dir.exist?(@contest_dir)
  end
end
