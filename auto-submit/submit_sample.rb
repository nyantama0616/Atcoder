require 'nokogiri'
require 'open-uri'
require 'uri'

class TestCaseSubmitter
  def initialize(problem_name, test_num)
    @problem_name = problem_name
    @test_num = test_num
    @context_name = problem_name.split('_')[0]
    @input_path = "#{__dir__}/tmp/#{@problem_name}/example_input#{@test_num}.txt"
    @output_path = "#{__dir__}/tmp/#{@problem_name}/original_output#{@test_num}.txt"

    uri = URI.parse("https://atcoder.jp/contests/#{@context_name}/tasks/#{@problem_name}")
    @doc = Nokogiri::HTML.parse(uri.open)
  end

  def submit
    # 例をtmp/#{@problem_name}/に保存
    save_examle("input")
    save_examle("output")

    system "cd .. && make atcoder4 in=#{@input_path} out=#{@output_path} -s"

    judge
  end

  def get_example_text(type)
    h3 = @doc.css("h3").select { |h3_element| h3_element.text.include?("#{type}例 #{@test_num}") }[0]
    no_example if h3.nil?

    section = h3.parent
    pre = section.css("pre")[0]
    pre.text
  end

  def save_examle_text(text, type)
    file_path = "tmp/#{@problem_name}/example_#{type}#{@test_num}.txt"
    text = text.gsub(/\r\n/, "\n")

    File.open(file_path, "w") do |file|
      file.puts text
    end
  end

  def execute
    system "cd .. && make atcoder4 in=#{@input_path} out=#{@output_path} -s"
  end

  def judge
    example_output = File.open("tmp/#{@problem_name}/example_output#{@test_num}.txt").read
    original_output = File.open("tmp/#{@problem_name}/original_output#{@test_num}.txt").read

    original_output.gsub!(/ \n/, "\n") # 末尾の空白を削除

    res = if example_output == original_output
            "\e[32mAccepted\e[0m"
          else
            "\e[31mWrong Answer\e[0m"
          end

    puts "#{@problem_name} - Example #{@test_num}: #{res}"
  end

  def no_example
    raise "No Example"
  end
end

problem_name = ARGV[0]
test_num = ARGV[1]

# 前処理
Dir.mkdir("tmp/#{problem_name}") unless Dir.exist?("tmp/#{problem_name}")

submitter = TestCaseSubmitter.new(problem_name, test_num)

input_example_text = submitter.get_example_text("入力")
output_example_text = submitter.get_example_text("出力")

submitter.save_examle_text(input_example_text, "input")
submitter.save_examle_text(output_example_text, "output")

submitter.execute
submitter.judge

# 後処理
FileUtils.rm_rf("tmp/#{$problem_name}")
