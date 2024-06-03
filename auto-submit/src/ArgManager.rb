class ArgManager
  attr_reader :problem_id, :help, :only_check

  def initialize(argv)
    @help = false
    @only_check = false

    argv.each do |arg|
      if arg[0] == "-"
        case arg
        when "--help", "-h"
          @help = true
        when "--only-check", "-c"
          @only_check = true
        else
          raise ArgumentError, "Invalid Argument Option '#{arg}'"
        end
      else
        validate_problem_id(arg)
        @problem_id = arg
      end
    end
  end

  private

  def validate_problem_id(problem_id)
    # abc000_x の形式であるか
    unless problem_id.match?(/abc\d{3}_\w/)
      raise ArgumentError, "Invalid Problem ID '#{problem_id}': Problem ID must be in the form of 'abc000_x'."
    end
  end
end
