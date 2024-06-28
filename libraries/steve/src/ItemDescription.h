#pragma once

#include <cstdint>
#include <string>

namespace steve
{
struct ItemDescription
{
    std::string name;
    bool        blacklisted = false, whitelisted = false;
    float       weight = 1.f;
};
} // namespace steve
