#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>

static ULONGLONG totalSize = 0;

static void scanDir(const WCHAR *path) {
    WCHAR searchPath[MAX_PATH];
    wsprintfW(searchPath, L"%s\\*", path);

    WIN32_FIND_DATAW fd;
    HANDLE hFind = FindFirstFileW(searchPath, &fd);
    if (hFind == INVALID_HANDLE_VALUE) return;

    do {
        if (wcscmp(fd.cFileName, L".") == 0 || wcscmp(fd.cFileName, L"..") == 0)
            continue;

        WCHAR fullPath[MAX_PATH];
        wsprintfW(fullPath, L"%s\\%s", path, fd.cFileName);

        if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
            scanDir(fullPath);
        } else {
            ULARGE_INTEGER size;
            size.LowPart = fd.nFileSizeLow;
            size.HighPart = fd.nFileSizeHigh;
            totalSize += size.QuadPart;
        }
    } while (FindNextFileW(hFind, &fd));

    FindClose(hFind);
}

static void printUsage() {
    fprintf(stderr, "Usage: dirsize <directory>\n");
    fprintf(stderr, "Prints total size of all files in <directory> (bytes).\n");
}

int wmain(int argc, WCHAR *argv[]) {
    if (argc < 2) {
        printUsage();
        return 1;
    }

    // Allow /? or --help
    if (wcscmp(argv[1], L"/?") == 0 || wcscmp(argv[1], L"--help") == 0) {
        printUsage();
        return 0;
    }

    DWORD attr = GetFileAttributesW(argv[1]);
    if (attr == INVALID_FILE_ATTRIBUTES || !(attr & FILE_ATTRIBUTE_DIRECTORY)) {
        fprintf(stderr, "Error: '%S' is not a valid directory\n", argv[1]);
        return 1;
    }

    scanDir(argv[1]);
    printf("%llu\n", totalSize);
    return 0;
}
