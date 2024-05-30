require 'nokogiri'
require 'open-uri'
require 'uri'

class TestCaseSubmitter
  @@html_cache = [] # スクレイピングの結果をキャッシュするための変数

  def initialize(problem_name, test_num)
    @problem_name = problem_name
    @test_num = test_num
    @context_name = problem_name.split('_')[0]
    @case_dir = "#{__dir__}/tmp/#{@problem_name}/case#{@test_num}"
    @standard_input_path = "#{@case_dir}/standard_input.txt"
    @expected_output_path = "#{@case_dir}/_path.txt"
    @standard_output_path = "#{@case_dir}/standard_output.txt"

    uri = URI.parse("https://atcoder.jp/contests/#{@context_name}/tasks/#{@problem_name}")

    if uri == @@html_cache[0]
      @html = @@html_cache[1]
    else
      @html = Nokogiri::HTML.parse(uri.open)
      @@html_cache = [uri, @html]
    end

    create_dir
  end

  def create_dir
    Dir.mkdir(@case_dir) unless Dir.exist?(@case_dir)
  end

  def get_example_text(type)
    h3 = @html.css("h3").select { |h3_element| h3_element.text.include?("#{type}例 #{@test_num}") }[0]
    return no_example if h3.nil?

    section = h3.parent
    pre = section.css("pre")[0]
    pre.text
  end

  def save_examle_text(text, file_path)
    text = text.gsub(/\r\n/, "\n")

    File.open(file_path, "w") do |file|
      file.puts text
    end
  end

  def execute
    system "cd .. && make sample in=#{@standard_input_path} out=#{@standard_output_path} -s"
  end

  def judge
    example_output = File.open(@expected_output_path).read
    original_output = File.open(@standard_output_path).read

    original_output.gsub!(/ \n/, "\n") # 末尾の空白を削除

    res = if example_output == original_output
            "\e[32mAccepted\e[0m"
          else
            "\e[31mWrong Answer\e[0m"
          end

    puts "#{@problem_name} - Example #{@test_num}: #{res}"
  end

  def submit
    input_example_text = get_example_text("入力")
    output_example_text = get_example_text("出力")

    save_examle_text(input_example_text, @standard_input_path)
    save_examle_text(output_example_text, @expected_output_path)

    execute
    judge
  end

  def no_example
    raise "No Example"
  end

  def test_case_num
    h3 = @html.css("h3").select { |h3_element| h3_element.text.include?("入力例") }.length
  end
end
