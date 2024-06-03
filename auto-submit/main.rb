require_relative "./src/Problem.rb"
require_relative "./src/Submitter.rb"
require_relative "./src/SampleChecker.rb"
require_relative "./src/CodeServer.rb"
require_relative "./src/ArgManager.rb"
require_relative "./src/Help.rb"

args = ArgManager.new(ARGV)

if args.help
  Help.show
  return
end

problem = Problem.new args.problem_id
sample_checker =  SampleChecker.new problem
code_server = CodeServer.new problem
submitter =  Submitter.new problem, code_server: code_server

ac = sample_checker.check_all

return if args.only_check

if ac
  submitter.submit
else
  puts "Please check your code."
end
