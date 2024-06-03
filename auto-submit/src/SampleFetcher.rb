# 問題ページからサンプルケースを取得するクラス

require 'uri'
require 'open-uri'
require 'nokogiri'
require_relative "./Problem.rb"

class SampleFetcher
  attr_reader :case_num

  def initialize(problem)
    @problem = problem

    @sample_dir = "#{problem.task_dir}/samples"

    # samplesディレクトリが存在する場合はfetchしない
    if Dir.exist?(@sample_dir)
      @case_num = Dir.entries(@sample_dir).length - 2
      return
    end
    
    Dir.mkdir(@sample_dir)

    fetch
  end

  def get_case_dir_path(i)
    "#{@sample_dir}/case#{i + 1}"
  end

  def get_case_input_path(i)
    raise "out of range in case num" if i >= @case_num

    input_file_path = "#{@sample_dir}/case#{i + 1}/input.txt"
  end

  def get_case_output_path(i)
    raise "out of range in case num" if i >= @case_num

    output_file_path = "#{@sample_dir}/case#{i + 1}/output.txt"
  end
  private
  
  def fetch
    uri = URI.parse(@problem.problem_uri)
    html = Nokogiri::HTML.parse(uri.open)

    @case_num = html.css("h3").select { |h3_element| h3_element.text.include?("入力例") }.length

    @case_num.times do |i|
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
