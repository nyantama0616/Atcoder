# main.cpp内のincludeを展開し、例えばabc123/a/dest.cppに書き込む

require "./Setting.rb"
require "./Contest.rb"

class CodeServer
  attr_reader :dest_file_path

  @@main_dir = "/Users/x/Documents/programming/c++/AtCoder/main"
  @@include_dir = "/Users/x/Documents/programming/c++/AtCoder/include"

  def initialize(contest, is_compile: true)
    @contest = contest
    @main_file_path = "#{@@main_dir}/main.cpp"
    @macros_file_path = "#{@@include_dir}/mylib/macros.h"
    @dest_file_path = "#{contest.task_dir}/dest"
    @dest_cpp_file_path = "#{contest.task_dir}/dest.cpp"

    # ファイルの内容を読み込む
    main_file_content =  File.open(@main_file_path).read
    macros_file_content = File.open(@macros_file_path).read

    # #include<mylib/macros.h>を展開
    dest_file_content = main_file_content.gsub("#include <mylib\/macros.h>", macros_file_content)

    File.open(@dest_cpp_file_path, "w") do |file|
      file.puts dest_file_content
    end

    compile if is_compile
  end

  def compile
    command = "g++-14 -std=c++20 -Wall -Wextra -O2 -o #{@dest_file_path} #{@dest_cpp_file_path}"
    system command
  end

  def source_code
    File.open(@dest_cpp_file_path).read
  end
end

contest = Contest.new "abc123_c"
CodeServer.new contest
