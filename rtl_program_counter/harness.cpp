#include "harness.hpp"
using namespace rtl_program_counter;
static std::unique_ptr<Vrtl_program_counter_dut> dut{nullptr};

const char *const *rtl_program_counter::get_peekables() {
  return (const char *const[]){"tx_addr", nullptr};
};
const char *const *rtl_program_counter::get_pokeables() {
  return (const char *const[]){"enable",   "cjmp",     "rjmp",
                               "rx_count", "rx_realm", nullptr};
};
int rtl_program_counter::do_peek(lua_State *L) {
  auto option = luaL_checkoption(L, 1, nullptr, get_peekables());
  auto peeked = peek<lua_Integer>(dut, option);
  if (peeked.has_value()) {
    lua_pushinteger(L, peeked.value());
  } else {
    lua_pushnil(L);
  }
  return 1;
}

int rtl_program_counter::do_poke(lua_State *L) {
  auto option = luaL_checkoption(L, 1, nullptr, get_pokeables());
  auto value = luaL_checkinteger(L, 2);
  poke<lua_Integer>(dut, option, value);
  return 0;
}

int rtl_program_counter::do_reset(lua_State *L) {
  dut->aresetn = 0;
  dut->aclk = 1;
  dut->eval();
  dut->aresetn = 1;
  dut->aclk = 0;
  dut->eval();
  return 0;
}

int rtl_program_counter::do_step(lua_State *L) {
  dut->aclk = 1;
  dut->eval();
  dut->aclk = 0;
  dut->eval();
  return 0;
}

bool rtl_program_counter::run() {
  std::printf("Running test %s %s\n", rtl_program_counter_NAME,
              rtl_program_counter_VSTRING_FULL);
  dut = std::make_unique<Vrtl_program_counter_dut>();

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

  auto path = std::filesystem::path(rtl_program_counter_SOURCE_DIR);
  path /= "test";
  path /= "run.lua";
  auto my_status = false;

  if (!luaL_dofile(L, path.c_str())) {
    my_status = true;
  } else {
    std::fprintf(stderr, "%s\n", lua_tostring(L, -1));
    lua_pop(L, 1);
  }

  lua_close(L);
  dut = nullptr;
  return my_status;
}
