----------------------------------------------------------------------------------
-- Company:  FPGA'er
-- Engineer: Claudio Avi Chami - FPGA'er Website
--           http://fpgaer.tech
-- Create Date: 23.08.2022 
-- Module Name: tb_downcounter.vhd
-- Description: testbench for down counter
--              
-- Dependencies: downcounter.vhd
-- 
-- Revision: 1
-- Revision  1 - File Created
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
	use ieee.numeric_std.ALL;
    
entity tb_downcounter is
end entity;

architecture test of tb_downcounter is

    constant DATA_W  : natural := 32;
    constant PERIOD  : time := 10 ns;
	
    signal clk       : std_logic := '0';
    signal rstn      : std_logic := '0';
    signal load      : std_logic := '0';
    signal en        : std_logic := '0';
    signal data_in   : std_logic_vector (DATA_W-1 downto 0) := (others => '0');
    signal endSim	   : boolean   := false;

    component downcounter  is
      generic ( DATA_W		: natural := 32 );
      
      port (
        clk: 		  in std_logic;
        rstn: 		in std_logic;
        
        -- inputs
        data_in:	in std_logic_vector (DATA_W-1 downto 0);
        load: 		in std_logic;
        en:			  in std_logic;
        
        -- outputs
        data_out: out std_logic_vector (DATA_W-1 downto 0);
        done:		  out std_logic
      );
    end component;
    

begin
  clk <= not clk after PERIOD/2;

	-- Main simulation process
	process 
	begin
		wait for 20 ns;
    wait until(falling_edge(clk));
    rstn <= '1';
    wait until(rising_edge(clk));
    wait until(rising_edge(clk));
    
    data_in <= std_logic_vector(to_unsigned(4, data_in'length));
    load    <= '1';
    wait until(rising_edge(clk));
    load    <= '0';
    en      <= '1';
    
    for i in 0 to 2 loop
      wait until(rising_edge(clk));
    end loop;
    en      <= '0';
    wait until(rising_edge(clk));
    wait until(rising_edge(clk));
    en      <= '1';
    wait until(rising_edge(clk));
   
		wait for 70 ns;
    
    data_in <= std_logic_vector(to_unsigned(15, data_in'length));
    load    <= '1';
    wait until(rising_edge(clk));
    load    <= '0';

		wait for 30 ns;
    data_in <= std_logic_vector(to_unsigned(5, data_in'length));
    load    <= '1';
    wait until(rising_edge(clk));
    load    <= '0';
		wait for 100 ns;

		endSim  <= true;
	end	process;	
		
	-- End the simulation
	process 
	begin
		if (endSim) then
			assert false 
				report "End of simulation." 
				severity failure; 
		end if;
		wait for 10 ns;
	end process;	

    downc_inst : downcounter
      generic map (
        DATA_W	 => DATA_W
      )
      port map (
        clk 		  => clk 		  ,
        rstn		  => rstn		  ,
        data_in 	=> data_in  ,
        load 		  => load 		,
        en			  => en			  ,
        data_out  => open     ,
        done		  => open
      );

end architecture;
