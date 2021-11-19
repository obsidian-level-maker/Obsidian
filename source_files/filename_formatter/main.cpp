#include "nodes.h"
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <string>

extern "C" {
#include "lex.yy.h"
#include <getopt.h>
}

static auto now_ =
    std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
static auto now = *std::localtime(&now_);
static std::string gameValue;
static std::string versionValue;
static std::string themeValue;
static std::string countValue;

void year() { std::cout << now.tm_year + 1900; }

void month() { std::cout << now.tm_mon + 1; }

void day() { std::cout << now.tm_mday; }

void hour() { std::cout << now.tm_hour; }

void minute() { std::cout << now.tm_min; }

void second() { std::cout << now.tm_sec; }

void game() { std::cout << gameValue; }

void version() { std::cout << versionValue; }

void theme() { std::cout << themeValue; }
void count() { std::cout << countValue; }

int main(int argc, char **argv) {
    int c;
    std::string input;
    while ((c = getopt(argc, argv, "g:v:t:c:f:")) != EOF) {
        switch (c) {
            case 'g':
                gameValue = optarg;
                break;
            case 'v':
                versionValue = optarg;
                break;
            case 't':
                themeValue = optarg;
                break;
            case 'c':
                countValue = optarg;
                break;
            case 'f':
                input = optarg;
                break;
            case '?':
                std::cerr << "invalid arguments\n";
                exit(1);
        }
    }

    auto buffer_state = yy_scan_bytes(input.c_str(), input.size());
    yy_switch_to_buffer(buffer_state);
    token t;
    while ((t = static_cast<token>(yylex())) != tokEof) {
    }
}
