require "mechanize"
require "io/console"
require "./Cookie"

class Session
  def initialize
    @agent = Mechanize.new

    unless logined?
      login repeat: 3
    end
  end

  def login(repeat: 1)
    page = @agent.get('https://atcoder.jp/login')

    repeat.times do
      
      # プロンプト
      print 'Please enter your AtCoder username: '
      username = gets.chomp
      print 'Please enter your AtCoder password: '
      password = STDIN.noecho(&:gets).chomp
      puts
      
      # フォームにusernameとpasswordを入力
      form = page.forms[1]
      form.field_with(name: 'username').value = username
      form.field_with(name: 'password').value = password
  
      page = @agent.submit(form)
  
      if page.title == 'AtCoder'
        @agent.cookie_jar.save_as(Cookie::COOKIE_FILE, session: true)
        puts 'Login successful!'
        return true
      else
        puts 'Login failed.'
      end
    end

    false
  end

  def logined?
    !!Cookie.SESSION_ID&.value
  end

  def session_id
    Cookie.SESSION_ID&.value
  end
end

if __FILE__ == $0
  session = Session.new
end
