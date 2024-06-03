require 'yaml'
require "./Setting.rb"

# TODO: このモジュールいらんかも
module Cookie
  COOKIE_FILE = "#{Setting::SOURCE_DIR}/secrets/cookies.yml"

  File.open(COOKIE_FILE, "w") unless File.exist?(COOKIE_FILE)

  def self.SESSION_ID
    cookies.dig("atcoder.jp", "/", "REVEL_SESSION")
  end

  private

  def self.cookies
    begin
      config = YAML.unsafe_load_file(COOKIE_FILE)
      return config
    rescue Psych::DisallowedClass => e
      puts "Unsafe YAML content found: #{e.message}"
    rescue Psych::SyntaxError => e
      puts "YAML syntax error: #{e.message}"
    end
  end
end
