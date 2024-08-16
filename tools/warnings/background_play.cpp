#include <iostream>
#include <cstdlib>
#include <windows.h>
#include <string>

// was compiled in gcc 13.2.0 with: -static-libgcc -lcomdlg32 -std=c++20 -lshlwapi -m32

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <soundbank> <file>\n";
        return 1;
    }

    std::string soundbank = argv[1];
    std::string file = argv[2];
    std::string command = ".\\" + soundbank + "\\" + file;

    // Use ShellExecute to run the command with hidden window
    ShellExecute(NULL, "open", "mpg123.exe", ("-o s \"" + command + "\"").c_str(), NULL, SW_HIDE);

    return 0;
}
