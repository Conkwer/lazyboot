#include <iostream>
#include <fstream>
#include <chrono>
#include <ctime>
#include <cmath>

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: timer.exe <command> [-m]\n";
        return 1;
    }

    std::string command = argv[1];
    bool verbose = argc > 2 && std::string(argv[2]) == "-m";

    if (command == "start") {
        std::ofstream file("timer.cfg", std::ios::trunc);
        auto now = std::chrono::system_clock::now();
        auto now_c = std::chrono::system_clock::to_time_t(now);
        file << static_cast<long long>(now_c) << '\n';
    } else if (command == "stop") {
        std::ofstream file("timer.cfg", std::ios::app);
        auto now = std::chrono::system_clock::now();
        auto now_c = std::chrono::system_clock::to_time_t(now);
        file << static_cast<long long>(now_c) << '\n';
    } else if (command == "view") {
        std::ifstream file("timer.cfg");
        long long start, stop;
        file >> start >> stop;
        auto elapsed = stop - start;

        if (verbose) {
            double minutes = elapsed / 60.0;
            minutes = std::round(minutes * 10) / 10;  // Round to one decimal place
            std::cout << minutes << std::endl;  // Removed " min"
        } else {
            int hours = elapsed / 3600;
            int minutes = (elapsed % 3600) / 60;
            int seconds = elapsed % 60;

            std::cout << (hours < 10 ? "0" : "") << hours << ":"
                      << (minutes < 10 ? "0" : "") << minutes << ":"
                      << (seconds < 10 ? "0" : "") << seconds << std::endl;
        }
    }

    return 0;
}
