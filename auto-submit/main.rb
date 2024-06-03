require_relative "./src/Problem.rb"
require_relative "./src/Submitter.rb"
require_relative "./src/SampleChecker.rb"
require_relative "./src/CodeServer.rb"

problem_id = ARGV[0]

problem = Problem.new "abc354_a"
sample_checker =  SampleChecker.new problem
code_server = CodeServer.new problem
submitter =  Submitter.new problem, code_server: code_server

if sample_checker.check_all
  submitter.submit
else
  puts "Please check your code."
end
