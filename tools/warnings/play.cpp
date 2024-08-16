#include <iostream>
#include <string>

// Define the MINIAUDIO_IMPLEMENTATION macro before including miniaudio.h
#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <soundbank> <file>\n";
        return 1;
    }

    std::string soundbank = argv[1];
    std::string file = argv[2];
    std::string filePath = "./" + soundbank + "/" + file;

    ma_result result;
    ma_engine engine;
    ma_sound sound;

    result = ma_engine_init(NULL, &engine);
    if (result != MA_SUCCESS) {
        std::cerr << "Failed to initialize audio engine. Error code: " << result << std::endl;
        return -1;
    }

    result = ma_sound_init_from_file(&engine, filePath.c_str(), 0, NULL, NULL, &sound);
    if (result != MA_SUCCESS) {
        std::cerr << "Failed to load sound file. Error code: " << result << std::endl;
        ma_engine_uninit(&engine);
        return -1;
    }

    ma_sound_start(&sound);

    std::cout << "Playing " << filePath << "...\n";

    // Wait for the audio to finish playing
    while (!ma_sound_at_end(&sound)) {
        ma_sleep(100); // Sleep for a short duration to avoid busy-waiting
    }

    ma_sound_uninit(&sound);
    ma_engine_uninit(&engine);

    return 0;
}
