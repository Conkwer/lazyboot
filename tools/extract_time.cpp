#include <iostream>
#include <string>
#include <regex>

int main() {
    std::string content;
    std::getline(std::cin, content); // Skip the first line
    std::getline(std::cin, content); // Read the second line

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
