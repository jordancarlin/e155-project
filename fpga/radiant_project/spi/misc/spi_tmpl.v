    spi __(.spi2_miso_io( ),
        .spi2_mosi_io( ),
        .spi2_sck_io( ),
        .spi2_scs_n_i( ),
        .spi2_mcs_n_o( ),
        .rst_i( ),
        .ipload_i( ),
        .ipdone_o( ),
        .sb_clk_i( ),
        .sb_wr_i( ),
        .sb_stb_i( ),
        .sb_adr_i( ),
        .sb_dat_i( ),
        .sb_dat_o( ),
        .sb_ack_o( ),
        .spi_pirq_o( ),
        .spi_pwkup_o( ));
