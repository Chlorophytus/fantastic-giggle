#pragma once
#include "Vrtl_program_counter_dut.h"
#include "config.hpp"
#include <cstdint>
#include <filesystem>
#include <lua.hpp>
#include <memory>
#include <optional>

using F32 = float;
using F64 = double;
using S8 = std::int8_t;
using S16 = std::int16_t;
using S32 = std::int32_t;
using S64 = std::int64_t;
using U8 = std::uint8_t;
using U16 = std::uint16_t;
using U32 = std::uint32_t;
using U64 = std::uint64_t;

namespace rtl_program_counter {
const char *const *get_peekables();
const char *const *get_pokeables();
template <typename T>
const std::optional<T> peek(std::unique_ptr<Vrtl_program_counter_dut> &dut,
                            const int which) {
  static_assert(std::is_integral<T>(),
                "Please use an integer value for peeks.");
  auto result = T{};
  switch (which) {
  case 0:
    result = dut->tx_addr;
    return result;
  default:
    return {};
  }
}
template <typename T>
void poke(std::unique_ptr<Vrtl_program_counter_dut> &dut, const int which,
          const T val) {
  switch (which) {
  case 0:
    dut->enable = val;
    return;
  case 1:
    dut->cjmp = val;
    return;
  case 2:
    dut->rjmp = val;
    return;
  case 3:
    dut->rx_count = val;
    return;
  case 4:
    dut->rx_realm = val;
    return;
  default:
    return;
  }
}
int do_peek(lua_State *);
int do_poke(lua_State *);
int do_reset(lua_State *);
int do_step(lua_State *);
bool run();
} // namespace rtl_program_counter
