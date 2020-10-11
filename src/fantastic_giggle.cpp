#include "../include/fantastic_giggle.hpp"
#include "../rtl_alu2/harness.hpp"
#include "../rtl_carry4_alu2/harness.hpp"
#include "../rtl_lod4/harness.hpp"
// Main entry point
int main(int argc, char **argv) {
  std::printf("fantastic giggle %s\n", fantastic_giggle_VSTRING_FULL);
  // Run Verilator's strap code
  Verilated::commandArgs(argc, argv);

  // assert(rtl_barrelshifter16::run());
  // assert(rtl_alu2::run());
  assert(rtl_carry4_alu2::run());
  assert(rtl_lod4::run());
  // We are done
  return 0;
}
