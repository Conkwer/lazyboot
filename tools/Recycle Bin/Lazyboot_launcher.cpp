#include <iostream>
#include <windows.h>


int main() {
    ShellExecute(NULL, "open", ".\\tools\\ConEmu\\ConEmu.exe", "/cmd \".\\tools\\Lazyboot.cmd\"", NULL, SW_HIDE);
}

