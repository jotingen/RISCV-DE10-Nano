	component soc_system is
		port (
			clk_clk      : in  std_logic := 'X'; -- clk
			ddr3_clk_clk : out std_logic         -- clk
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			clk_clk      => CONNECTED_TO_clk_clk,      --      clk.clk
			ddr3_clk_clk => CONNECTED_TO_ddr3_clk_clk  -- ddr3_clk.clk
		);

