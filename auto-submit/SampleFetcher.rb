# 問題ページからサンプルケースを取得するクラス

require 'uri'
require 'open-uri'
require 'nokogiri'
require "./Contest.rb"

class SampleFetcher
  def initialize(contest)
    @contest = contest

    @sample_dir = "#{contest.task_dir}/samples"

    return if Dir.exist?(@sample_dir) # samplesディレクトリが存在する場合は何もしない
    
    create_dir

    fetch
  end
  
  private
  
  def create_dir
    Dir.mkdir(@sample_dir) unless Dir.exist?(@sample_dir)
  end
  
  def fetch
    uri = URI.parse("https://atcoder.jp/contests/#{@contest.contest_name}/tasks/#{@contest.contest_id}")
    html = Nokogiri::HTML.parse(uri.open)

    case_num = html.css("h3").select { |h3_element| h3_element.text.include?("入力例") }.length

    case_num.times do |i|
      case_dir = "#{@sample_dir}/case#{i + 1}"
      case_file_input = "#{case_dir}/input.txt"
      case_file_output = "#{case_dir}/output.txt"
      Dir.mkdir(case_dir)

      
      # 入力例の取得

      h3_input = html.css("h3").select { |h3_element| h3_element.text.include?("入力例 #{i + 1}") }[0]
      section = h3_input.parent
      pre = section.css("pre")[0]

      File.open(case_file_input, "w") do |file|
        file.puts pre.text
      end

      # 出力例の取得

      h3_output = html.css("h3").select { |h3_element| h3_element.text.include?("出力例 #{i + 1}") }[0]
      section = h3_output.parent
      pre = section.css("pre")[0]

      File.open(case_file_output, "w") do |file|
        file.puts pre.text
      end


    end
  end
end
