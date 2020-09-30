#include "harness.hpp"
using namespace rtl_carryadder8;
static std::unique_ptr<Vrtl_carryadder8_dut> dut{nullptr};

const char *const *rtl_carryadder8::get_peekables() {
  return (const char *const[]){"tx_sum", "tx_carryflag", "tx_zeroflag",
                               "tx_ready", nullptr};
};
const char *const *rtl_carryadder8::get_pokeables() {
  return (const char *const[]){"rx_enable",    "rx_write",   "rx_strobe",
                               "rx_carryflag", "rx_addend0", "rx_addend1",
                               nullptr};
};
int rtl_carryadder8::do_peek(lua_State *L) {
  auto option = luaL_checkoption(L, 1, nullptr, get_peekables());
  auto peeked = peek<lua_Integer>(dut, option);
  if (peeked.has_value()) {
    lua_pushinteger(L, peeked.value());
  } else {
    lua_pushnil(L);
  }
  return 1;
}

int rtl_carryadder8::do_poke(lua_State *L) {
  auto option = luaL_checkoption(L, 1, nullptr, get_pokeables());
  auto value = luaL_checkinteger(L, 2);
  poke<lua_Integer>(dut, option, value);
  return 0;
}

int rtl_carryadder8::do_reset(lua_State *L) {
  dut->aresetn = 0;
  dut->aclk = 1;
  dut->eval();
  dut->aresetn = 1;
  dut->aclk = 0;
  dut->eval();
  return 0;
}

int rtl_carryadder8::do_step(lua_State *L) {
  dut->aclk = 1;
  dut->eval();
  dut->aclk = 0;
  dut->eval();
  return 0;
}

bool rtl_carryadder8::run() {
  std::printf("Running test %s %s\n", rtl_carryadder8_NAME,
              rtl_carryadder8_VSTRING_FULL);
  dut = std::make_unique<Vrtl_carryadder8_dut>();

  auto L = luaL_newstate();
  luaL_openlibs(L);
  lua_pushcfunction(L, do_peek);
  lua_setglobal(L, "do_peek");
  lua_pushcfunction(L, do_poke);
  lua_setglobal(L, "do_poke");
  lua_pushcfunction(L, do_reset);
  lua_setglobal(L, "do_reset");
  lua_pushcfunction(L, do_step);
  lua_setglobal(L, "do_step");

  auto path = std::filesystem::path(rtl_carryadder8_SOURCE_DIR);
  path /= "test";
  path /= "run.lua";
  auto my_status = false;

  if (!luaL_dofile(L, path.c_str())) {
    my_status = true;
  }

  lua_close(L);
  dut = nullptr;
  return my_status;
}
