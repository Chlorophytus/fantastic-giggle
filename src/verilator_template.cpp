#include "../include/verilator_template.hpp"
#include "../rtl_test_example/harness.hpp"
// Main entry point
int main(int argc, char **argv) {
  std::printf("verilator template %s\n", verilator_template_VSTRING_FULL);
  // Run Verilator's strap code
  Verilated::commandArgs(argc, argv);

  rtl_test_example::run();
  // We are done
  return 0;
}