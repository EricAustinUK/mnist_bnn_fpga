#include "nrf.h"

void cnf_spi_pins(){
    static bool cfgd = false;
    if(cfgd) return;
    cfgd = true;
    
    NRF_SPIM0->PSEL.SCK  = 13; // telling SPI peripheral to send clock to 13?
    NRF_SPIM0->PSEL.MISO = 0xFFFFFFFF;  // blanking MISO for now
    NRF_SPIM0->PSEL.MOSI = 15; // telling SPI peripheral to send over pin 15
}

void send_arr(uint32_t *arr, uint32_t size){

    NRF_SPIM0->TXD.PTR = uint32_t(arr);
    NRF_SPIM0->TXD.MAXCNT = size; 

}
