# ソースコードを提出するクラス

require "mechanize"
require "./CodeServer"
require "./Contest"
require "./Session"
require "./Setting"

class Submitter
  def initialize(contest, codeServer: nil, session: nil)
    @contest = contest
    @codeServer = codeServer || CodeServer.new(contest)
    @session = session || Session.new

    @agent = Mechanize.new
    cookie = Mechanize::Cookie.new("REVEL_SESSION", @session.session_id)
    @agent.cookie_jar.add(@contest.contest_uri, cookie)
  end

  def submit
    page = @agent.get(@contest.contest_uri)
    form = page.forms[1]

    # 言語を選択
    form.field_with(name: "data.LanguageId").options.each do |option|
      if option.text == Setting::PROGRAMMING_LANGUAGES
        option.select
        break
      end
    end

    # ソースコードを入力
    form.field_with(name: "sourceCode").value = @codeServer.source_code

    page = @agent.submit(form)

    if page.title.include? "My Submissions" # 提出成功！
      # ブラウザで提出結果を確認する
      system "open #{@contest.submittions_uri}"

      puts "Submit successful!"
    else
      puts "Submit failed."
    end
  end
end

if __FILE__ == $0
  contest = Contest.new "abc354_a"
  submitter = Submitter.new contest
  submitter.submit
end
