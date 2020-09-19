#include "../include/fantastic_giggle.hpp"
#include "../rtl_test_example/harness.hpp"
// Main entry point
int main(int argc, char **argv) {
  std::printf("fantastic giggle %s\n", fantastic_giggle_VSTRING_FULL);
  // Run Verilator's strap code
  Verilated::commandArgs(argc, argv);

  assert(rtl_test_example::run());
  // We are done
  return 0;
}