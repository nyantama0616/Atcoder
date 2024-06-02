//使用例: g++-14 -std=gnu++20 -o ./build/main ./main.cpp && ./build/main abc354 a

#include <bits/stdc++.h>
#include <dirent.h>

using namespace std;

int file_count(const string path); // フォルダ内のファイル数を取得する
void act_sample(string input_dir, string output_dir, int sample_num); // 一つのsampleを実行する
bool check_sample(string input_dir, string output_dir, int sample_num); // 一つのsampleを実行する

const string ROOT_DIR = "/Users/x/Documents/programming/c++/AtCoder/main";

int main(int argc, char const *argv[]) {
    auto context_name = argv[1];
    auto task_name = argv[2];
    auto sample_num = 0;

    printf("context_name: %s\n", context_name);
    printf("task_name: %s\n", task_name);

    //{context_name}というフォルダが存在しない場合、新規作成する
    string context_path = ROOT_DIR + "/" + string(context_name);
    if (opendir(context_path.c_str()) == NULL) {
        auto command = "acc new " + string(context_name);
        system(command.c_str());
    }

    auto input_dir = context_path + "/" + task_name + "/tests";
    auto output_dir = context_path + "/" + task_name + "/outputs";

    //outputs_dirが存在しない場合、新規作成する
    if (opendir(output_dir.c_str()) == NULL) {
        auto command = "mkdir " + output_dir;
        system(command.c_str());
    }
    
    if (sample_num == 0) {
        int sample_count = file_count(input_dir) / 2;

        //全sampleを実行する
        for (int i = 1; i <= sample_count; i++) {
            act_sample(input_dir, output_dir, i);
        }
    } else {
        //任意sampleを実行する
        act_sample(input_dir, output_dir, sample_num);
    }
}

int file_count(const string path) {
    DIR *dp;
    struct dirent *entry;
    int file_count = 0;
    dp = opendir(path.c_str());
    while ((entry = readdir(dp)) != NULL) {
        if (entry->d_type == DT_REG) {
            file_count++;
        }
    }
    closedir(dp);

    return file_count;
}

//TODO: SampleManagerクラス作る

void act_sample(string input_dir, string outut_dir, int sample_num) {
    auto input_file = input_dir + "/sample-" + to_string(sample_num) + ".in";
    auto output_file = outut_dir + "/sample-" + to_string(sample_num) + ".out";
    auto command_check_sample = ROOT_DIR + "/build/dest < " + input_file + " > " + output_file;
    system(command_check_sample.c_str());

    bool flag = check_sample(input_dir, outut_dir, sample_num);
    if (flag) {
        printf("sample-%d: OK\n", sample_num);
    } else {
        printf("sample-%d: NG\n", sample_num);
        exit(-1);
    }
}

bool check_sample(string input_dir, string output_dir, int sample_num) {
    auto expected_output_file = input_dir + "/sample-" + to_string(sample_num) + ".out";
    auto output_file = output_dir + "/sample-" + to_string(sample_num) + ".out";

    //2つのファイルを1行ずつ比較する
    ifstream expected_output_file_stream(expected_output_file);
    ifstream output_file_stream(output_file);
    string expected_output_line;
    string output_line;
    int line_num = 1;
    while (getline(expected_output_file_stream, expected_output_line) && getline(output_file_stream, output_line)) {
        if (expected_output_line != output_line) {
            string command = "vimdiff " + expected_output_file + " " + output_file;
            system(command.c_str()); //一個でもミスると、vimdiffが立ち上がる
            return false;
        }
        line_num++;
    }
    expected_output_file_stream.close();
    output_file_stream.close();

    return true;
}
