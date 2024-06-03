# ソースコードを提出するクラス

require "mechanize"
require_relative "./CodeServer.rb"
require_relative "./Problem.rb"
require_relative "./Session.rb"
require_relative "../Setting.rb"

class Submitter
  def initialize(problem, code_server: nil, session: nil)
    @problem = problem
    @code_server = code_server || CodeServer.new(problem)
    @session = session || Session.new

    @agent = Mechanize.new
    cookie = Mechanize::Cookie.new("REVEL_SESSION", @session.session_id)
    @agent.cookie_jar.add(@problem.problem_uri, cookie)
  end

  def submit
    page = @agent.get(@problem.problem_uri)
    form = page.forms[1]

    # 言語を選択
    form.field_with(name: "data.LanguageId").options.each do |option|
      if option.text == Setting::PROGRAMMING_LANGUAGES
        option.select
        break
      end
    end

    # ソースコードを入力
    form.field_with(name: "sourceCode").value = @code_server.source_code

    page = @agent.submit(form)

    if page.title.include? "My Submissions" # 提出成功！
      # ブラウザで提出結果を確認する
      system "open #{@problem.submittions_uri}"

      puts "Submit successful!"
    else
      puts "Submit failed."
    end
  end
end

if __FILE__ == $0
  problem = Problem.new "abc354_a"
  submitter = Submitter.new problem
  submitter.submit
end
