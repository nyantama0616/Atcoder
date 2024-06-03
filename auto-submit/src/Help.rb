module Help
  def self.show
    puts <<~HELP
      Usage: __atc-submit [options] problem_id
      
      Options:
        -h, --help: Show this help message.
        -c, --only-check: Only check the code, don't submit.
    HELP
  end
end
