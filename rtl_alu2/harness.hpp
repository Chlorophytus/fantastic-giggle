#pragma once
#include "Vrtl_alu2_dut.h"
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

namespace rtl_alu2 {
const char *const *get_peekables();
const char *const *get_pokeables();
template <typename T>
const std::optional<T> peek(std::unique_ptr<Vrtl_alu2_dut> &dut,
                            const int which) {
  static_assert(std::is_integral<T>(),
                "Please use an integer value for peeks.");
  auto result = T{};
  switch (which) {
  case 0:
    result = dut->tx_result;
    return result;
  case 1:
    result = dut->tx_carryflag;
    return result;
  case 2:
    result = dut->tx_zeroflag;
    return result;
  case 3:
    result = dut->tx_signflag;
    return result;
  default:
    return {};
  }
}

template <typename T>
void poke(std::unique_ptr<Vrtl_alu2_dut> &dut, const int which, const T val) {
  switch (which) {
  case 0:
    dut->rx_carryflag = val;
    return;
  case 1:
    dut->rx_what_op = val;
    return;
  case 2:
    dut->rx_operand0 = val;
    return;
  case 3:
    dut->rx_operand1 = val;
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
} // namespace rtl_alu2
