#include <iostream>
#include <fstream>
#include <string>
#include <regex>

int main() {
    std::ifstream file("tools/cfg/time.txt");
    std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());

    std::regex pattern(R"((\d{2}:\d{2}:\d{2}))");
    std::smatch matches;

    while (std::regex_search(content, matches, pattern)) {
        std::string time = matches[0];
        std::string minsec = time.substr(3, 5);
        std::cout << minsec << std::endl;
        content = matches.suffix().str();
    }

    return 0;
}
