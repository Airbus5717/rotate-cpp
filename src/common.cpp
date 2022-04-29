#include "include/common.hpp"

#include "frontend/include/token.hpp"

//* USEFUL COMMON UTILS FOR ROTATE-LANG

namespace rotate
{

bool is_space_rotate(char i)
{
    return i == ' ' || i == '\n';
}

void log_error(const char *str)
{
    fprintf(stderr, "[%sERROR%s]: %s\n", LRED, RESET, str);
}

void exit_error(const char *str)
{
    log_error(str);
    exit(1);
}

void log_debug(const char *str)
{
    fprintf(stderr, "[%sDEBUG%s]: %s\n", LYELLOW, RESET, str);
}

void log_info(const char *str)
{
    fprintf(stderr, "[%sINFO%s] : %s\n", LGREEN, RESET, str);
}

void log_token(const char *str, const rotate::token &tkn)
{
    fprintf(stderr, "[%sTOKEN%s]: idx: %u, len: %u, col: %u, line: %u, type: %s, val: `%.*s`\n",
            LYELLOW, RESET, tkn.index, tkn.length, tkn.col, tkn.line, tkn_type_describe(tkn.type),
            tkn.length, str + tkn.index);
}

u32 get_digits_from_number(u32 num)
{
    return (num >= 1000000000)  ? 9
           : (num >= 100000000) ? 8
           : (num >= 10000000)  ? 7
           : (num >= 1000000)   ? 6
           : (num >= 100000)    ? 5
           : (num >= 10000)     ? 4
           : (num >= 1000)      ? 3
           : (num >= 100)       ? 2
           : (num >= 10)        ? 1
                                : 0;
}

bool is_allocated(token_type type)
{
    switch (type)
    {
        case TknTypeInteger:
        case TknTypeHexInteger:
        case TknTypeBinaryInteger:
        case TknTypeFloat:
        case TknTypeBuiltinFunc:
        case TknTypeIdentifier:
        case TknTypeString:
        case TknTypeChar:
            return true;
        default:
            return false;
    }
}

} // namespace rotate
