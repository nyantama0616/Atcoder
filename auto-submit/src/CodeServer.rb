# main.cpp内のincludeを展開し、例えばabc123/a/dest.cppに書き込む

require_relative "../Setting.rb"
require_relative "./Problem.rb"

class CodeServer
  attr_reader :dest_file_path

  def initialize(problem, is_compile: true)
    @problem = problem
    @main_file_path = "#{Setting::MAIN_DIR}/main.cpp"
    @macros_file_path = "#{Setting::INCLUDE_DIR}/mylib/macros.h"
    @defines_file_path = "#{Setting::INCLUDE_DIR}/mylib/defines.h"
    @dest_file_path = "#{problem.task_dir}/dest"
    @dest_cpp_file_path = "#{problem.task_dir}/dest.cpp"

    # ファイルの内容を読み込む
    main_file_content =  File.open(@main_file_path).read
    macros_file_content = File.open(@macros_file_path).read
    defines_file_content = File.open(@defines_file_path).read
    
    defines_file_content.gsub!("#include <mylib/macros.h>", "") # #include<mylib/macros.h>を削除

    dest_file_content = main_file_content.gsub("#include <mylib\/macros.h>", macros_file_content) # #include<mylib/macros.h>を展開
    dest_file_content.gsub!("#define DEBUG_MODE 1", "#define DEBUG_MODE 0") # DEBUG_MODEをオフにする
    dest_file_content.gsub!("#pragma once", "")
    dest_file_content.gsub!("#include <mylib\/defines.h>", defines_file_content) # #include<mylib/defines.h>を展開

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
