
#include <iostream>
#include <bitset>
#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vlinterp.h"
#include "Vlinterp__Syms.h"

#define MAX_SIM_TIME 0xFFFF
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
    Vlinterp *dut = new Vlinterp;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("wave/waveform.vcd");

    int8_t i_high_signed = 127;
    int8_t i_low_signed = -128;
    uint16_t i_ctrl = 0x0000;

    dut->i_high_signed = i_high_signed;
    dut->i_low_signed = i_low_signed;

    while (sim_time <= MAX_SIM_TIME) {
        dut->i_ctrl = i_ctrl;
        dut->eval();

        int out = dut->out;
        out = sign_extend<24>(out);

        std::cout << ((float) out) / (float) std::pow (2, 16) << "\n";

        m_trace->dump(sim_time);
        sim_time++;
        i_ctrl++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}