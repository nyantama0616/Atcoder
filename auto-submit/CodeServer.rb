# main.cpp内のincludeを展開し、例えばabc123/a/dest.cppに書き込む

require "./Setting.rb"
require "./Contest.rb"

class CodeServer
  @@main_dir = "/Users/x/Documents/programming/c++/AtCoder/main"
  @@include_dir = "/Users/x/Documents/programming/c++/AtCoder/include"

  def initialize(contest)
    @main_file_path = "#{@@main_dir}/main.cpp"
    @macros_file_path = "#{@@include_dir}/mylib/macros.h"
    @dest_file_path = "#{contest.task_dir}/dest.cpp"

    # ファイルの内容を読み込む
    main_file_content =  File.open(@main_file_path).read
    macros_file_content = File.open(@macros_file_path).read

    # #include<mylib/macros.h>を展開
    dest_file_content = main_file_content.gsub("#include <mylib\/macros.h>", macros_file_content)

    File.open(@dest_file_path, "w") do |file|
      file.puts dest_file_content
    end
  end
end
