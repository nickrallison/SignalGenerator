
#include <iostream>
#include <set>
#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmulti_ram.h"
#include "Vmulti_ram__Syms.h"

#define MAX_SIM_TIME 1024
vluint64_t sim_time = 0;

double sc_time_stamp() { return 0; }

int main(int argc, char** argv, char** env) {

    // #### Setup VCD trace dump & DUT instance ####
    Vmulti_ram *dut = new Vmulti_ram;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("wave/waveform.vcd");


    // #### Testbench code ####
    int address_space = 256;
    int data_space = 256;
    int parallel_access = 2;

    dut->i_clk = 0;
    dut->i_res = 0;
    dut->eval();
    sim_time++;
    dut->i_clk ^= 1;
    dut->i_res = 1;
    dut->eval();
    sim_time++;
    dut->i_clk ^= 1;
    dut->i_res = 0;
    dut->eval();
    sim_time++;

    int data[address_space] = {0};

    while (sim_time <= MAX_SIM_TIME) {
        std::set<int> addr_set;
        std::set<int> w_data_set;
        while (addr_set.size() < parallel_access) {
            addr_set.insert(rand() % address_space);
        }
        std::vector <int> addr_vec;
        addr_vec.reserve (addr_set.size ());
        std::copy (addr_set.begin (), addr_set.end (), std::back_inserter (addr_vec));
        while (w_data_set.size() < parallel_access) {
            w_data_set.insert(rand() % data_space);
        }
        std::vector <int> w_data_vec;
        w_data_vec.reserve (w_data_set.size ());
        std::copy (w_data_set.begin (), w_data_set.end (), std::back_inserter (w_data_vec));

        dut->i_clk ^= 1;
        for (int i = 0; i < parallel_access; i++) {
            dut->we[i] = 1;
            dut->re[i] = 1;
            dut->addr[i] = addr_vec[i];
            dut->w_data[i] = w_data_vec[i];
        }
        dut->eval();

        int correct_r_data[parallel_access] = {0};
        for (int i = 0; i < parallel_access; i++) {
            if (data[addr_vec[i]] != dut->r_data[i]) {
                std::cout << "Error: data mismatch at address " << addr_vec[i] << "..." 
                << unsigned(data[addr_vec[i]]) << " != " << unsigned(dut->r_data[i]) << std::endl;
            }
        }

        for (int i = 0; i < parallel_access; i++) {
            data[addr_vec[i]] = w_data_vec[i];
        }


        m_trace->dump(sim_time);
        sim_time++;


        dut->i_clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
        

    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}