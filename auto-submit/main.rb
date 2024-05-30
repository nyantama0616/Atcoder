# 実行方法: ruby main.rb [problem_name] [test_num]
# 例1: ruby main.rb abc000_a
# 例1: ruby main.rb abc000_a 1

require_relative 'TestCaseSubmitter'

problem_name = ARGV[0]
test_num = ARGV[1]

# 前処理
dir_name = "#{__dir__}/tmp/#{problem_name}"
Dir.mkdir(dir_name) unless Dir.exist?(dir_name)

submitter = TestCaseSubmitter.new(problem_name, 1)

# 第2引き数が指定されている場合はそのテストケースのみ実行
unless test_num.nil?
  submitter.submit
  exit 0
end

# すべてのテストケースを実行
submitter.test_case_num.times do |i|
  submitter = TestCaseSubmitter.new(problem_name, i + 1)
  submitter.submit
end

# 後処理
# FileUtils.rm_rf("tmp/#{problem_name}")
