require 'nokogiri'
require 'open-uri'
require 'uri'

$problem_name = ARGV[0]
$test_num = ARGV[1]

$context_name = $problem_name.split('_')[0]

$input_path = "#{__dir__}/tmp/#{$problem_name}/example_input#{$test_num}.txt"
$output_path = "#{__dir__}/tmp/#{$problem_name}/original_output#{$test_num}.txt"

# 例をtmp/{$problem_name}/に保存
def save_examle(text, type)
  file_path = "tmp/#{$problem_name}/example_#{type}#{$test_num}.txt"
  text = text.gsub(/\r\n/, "\n")
  
  File.open(file_path, "w") do |file|
    file.puts text
  end
end

def judge
  example_output = File.open("tmp/#{$problem_name}/example_output#{$test_num}.txt").read
  original_output = File.open("tmp/#{$problem_name}/original_output#{$test_num}.txt").read

  original_output.gsub!(/ \n/, "\n") # 末尾の空白を削除
  
  res = if example_output == original_output
    "\e[32mAccepted\e[0m"
  else
    "\e[31mWrong Answer\e[0m"
  end

  puts "#{$problem_name} - Example #{$test_num}: #{res}"
end

# 前処理
Dir.mkdir("tmp/#{$problem_name}") unless Dir.exist?("tmp/#{$problem_name}")

uri = URI.parse("https://atcoder.jp/contests/#{$context_name}/tasks/#{$problem_name}")

doc = Nokogiri::HTML.parse(uri.open)

# 例題Xの入力を保存
input_h3 = doc.css("h3").select { |h3_element| h3_element.text.include?("入力例 #{$test_num}") }[0] # <h3>入力例 X</h3> の要素を取得
input_section = input_h3.parent
input_pre = input_section.css("pre")[0] # <pre>...</pre> の要素を取得
save_examle(input_pre.text, "input")

# 例題Xの出力を保存
output_h3 = doc.css("h3").select { |h3_element| h3_element.text.include?("出力例 #{$test_num}") }[0] # <h3>出力例 X</h3> の要素を取得
output_section = output_h3.parent
output_pre = output_section.css("pre")[0] # <pre>...</pre> の要素を取得
save_examle(output_pre.text, "output")


system "cd .. && make atcoder4 in=#{$input_path} out=#{$output_path} -s"

judge

# 後処理
FileUtils.rm_rf("tmp/#{$problem_name}")
