require "./contest.rb"
require "./SampleFetcher.rb"
require "./CodeServer.rb"

class SampleChecker
  def initialize(contest)
    @contest = contest
    @sample_fetcher = SampleFetcher.new contest
    @code_server = CodeServer.new contest, is_compile: false
  end

  # 全てのサンプルケースがACかどうかを判定
  def check_all
    all_ac = true

    @sample_fetcher.case_num.times do |i|
      all_ac = false unless check(i)
    end

    all_ac
  end

  # 一つのサンプルケースがACかどうかを判定
  def check(index)
    my_answer_path = "#{@sample_fetcher.get_case_dir_path(index)}/my_answer"
    
    # 回答を作成
    command = "#{@code_server.dest_file_path} < #{@sample_fetcher.get_case_input_path(index)} > #{my_answer_path}"
    system command

    expected = File.open(@sample_fetcher.get_case_output_path(index)).read
    my_answer = File.open(my_answer_path).read

    if expected == my_answer
      puts "Case #{index + 1}: \e[32mAC\e[0m"
      true
    else
      puts "Case #{index + 1}: \e[31mWA\e[0m"
      false
    end
  end
end

if __FILE__ == $0
  contest = Contest.new "abc354_a"
  checker = SampleChecker.new contest
  puts checker.check_all
end
