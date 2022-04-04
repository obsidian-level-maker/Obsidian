#include "nodes.h"
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <string>

extern "C" {
#include "lex.yy.h"
}

static auto now_ =
    std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
static auto now = *std::localtime(&now_);
static std::string gameValue;
static std::string themeValue;
static std::string countValue;
static std::string versionValue;
std::string result;

void year() { result.append(std::to_string(now.tm_year + 1900)); }

void month() { result.append(std::to_string(now.tm_mon + 1)); }

void day() { result.append(std::to_string(now.tm_mday)); }

void hour() { result.append(std::to_string(now.tm_hour)); }

void minute() { result.append(std::to_string(now.tm_min)); }

void second() { result.append(std::to_string(now.tm_sec)); }

void game() { result.append(gameValue); }

void theme() { result.append(themeValue); }

void count() { result.append(countValue); }

void version() { result.append(versionValue); }

void raw_append(const char *string) { result.append(string); }

const char *ff_main(const char *levelcount, const char *game, const char *theme, const char *version, const char *format) {
    int c;
    gameValue = game;
    themeValue = theme;
    countValue = levelcount;
    versionValue = version;
    std::string input = format;
    result.clear();

    auto buffer_state = yy_scan_bytes(input.c_str(), input.size());
    yy_switch_to_buffer(buffer_state);
    token t;
    while ((t = static_cast<token>(yylex())) != tokEof) {
    }

    return result.c_str();
}