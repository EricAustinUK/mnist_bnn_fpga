//Copyright (C)2014-2026 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.12.02_SP2 
//Created Time: 2026-06-17 11:08:05
create_clock -name nrf_SPIM_CLK -period 125 -waveform {0 62.5} [get_ports {i_sck}]
create_clock -name MCLK -period 37.037 -waveform {0 18.518} [get_ports {i_clk}]
