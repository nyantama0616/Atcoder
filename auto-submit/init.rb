require_relative "./Setting.rb"

defines_file_path = "#{Setting::INCLUDE_DIR}/mylib/defines.h"
main_cpp_file_path = "#{Setting::MAIN_DIR}/main.cpp"

File.open(defines_file_path, "w") do |file|
  file.puts "#include <mylib/macros.h>"
end

File.open(main_cpp_file_path, "w") do |file|
  file.puts <<~MAIN_CPP
      \#include <mylib/macros.h>
      \#include <mylib/defines.h>
      
      int main() {

      }
  MAIN_CPP
end
