#include <iostream>
#include <windows.h>
#include <fstream>
#include <string>

// Function to set the console font size
void SetConsoleFontSize(int fontSize) {
    CONSOLE_FONT_INFOEX cfi;
    cfi.cbSize = sizeof(cfi);
    cfi.nFont = 0;
    cfi.dwFontSize.X = 0;   // Width of each character in the font
    cfi.dwFontSize.Y = fontSize;  // Height
    cfi.FontFamily = FF_DONTCARE;
    cfi.FontWeight = FW_NORMAL;
    wcscpy_s(cfi.FaceName, L"Consolas"); // Choose your font
    SetCurrentConsoleFontEx(GetStdHandle(STD_OUTPUT_HANDLE), FALSE, &cfi);
}

int main(int argc, char *argv[]) {
    // Read the font size from a configuration file
    std::ifstream configFile("font.cfg");
    int fontSize = 20; // Default font size
    if (configFile.is_open()) {
        configFile >> fontSize;
        configFile.close();
    }

    // Set the console font size
    SetConsoleFontSize(fontSize);

    // Rest of your code
    std::string cmd = ".\\lazyboot.cmd";

    // Check if an argument is provided and append it to the command
    if (argc >= 2) {
        cmd += " ";
        cmd += argv[1];
    }

    // Call the batch file with or without the argument
    system(cmd.c_str());

    return 0;
}
