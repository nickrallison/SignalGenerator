
#include <iostream>
#include <bitset>
#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsignal_generator.h"
#include "Vsignal_generator__Syms.h"

#define MAX_SIM_TIME 0xFFFFFF
vluint64_t sim_time = 0;

template <size_t Bits, typename T>
inline constexpr T sign_extend(const T& v) noexcept {
    static_assert(std::is_integral<T>::value, "T is not integral");
    static_assert((sizeof(T) * 8u) >= Bits, "T is smaller than the specified width");
    if constexpr ((sizeof(T) * 8u) == Bits) return v;
    else {
        using S = struct { signed Val : Bits; };
        return reinterpret_cast<const S*>(&v)->Val;
    }
}

int main(int argc, char** argv, char** env) {
    Vsignal_generator *dut = new Vsignal_generator;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("wave/waveform.vcd");


    // dut->i_high_signed = i_high_signed;
    // dut->i_low_signed = i_low_signed;
    dut->step_size=0x000000000008;
    dut->i_res = 0;
    dut->i_clk = 0;
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
    dut->step_size=0x000000000008;
    dut->i_res = 1;
    dut->i_clk ^= 1;
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
    dut->step_size=0x000000000008;
    dut->i_res = 0;
    dut->i_clk ^= 1;
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
    while (sim_time <= MAX_SIM_TIME) {
        // dut->i_ctrl = i_ctrl;
        dut->step_size=0x000000000008;
        dut->i_clk ^= 1;
        dut->eval();
        // int out = dut->data;
        // out = sign_extend<24>(out);
        // std::cout << "out: " << out << std::endl;

        m_trace->dump(sim_time);
        sim_time++;
    }
    std::cout << "Test passed!" << std::endl;

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}