----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company:  FPGA'er
-- Engineer: Claudio Avi Chami - FPGA'er Website
--           http://fpgaer.tech
-- Create Date: 23.08.2022 
-- Module Name: downcounter.vhd
-- Description: Counter with enable and done output
--              
-- Dependencies: None
-- 
-- Revision: 1
-- Revision  1 - File Created
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity downcounter is
  generic ( DATA_W		: natural := 32 );
	
  port (
    clk: 			in std_logic;
    rstn: 		in std_logic;
    
    -- inputs
    data_in:	in std_logic_vector (DATA_W-1 downto 0);
    load: 		in std_logic;
    en:				in std_logic;
    
    -- outputs
    data_out: 	out std_logic_vector (DATA_W-1 downto 0);
    done:			out std_logic
  );
end downcounter;


architecture rtl of downcounter is
  signal counter_reg : unsigned (DATA_W-1 downto 0);

begin 

  counter_pr: process (clk) 
  begin 
    if (rising_edge(clk)) then
      if (rstn = '0') then 
        counter_reg 	<= (others => '0');
        done		<= '0';
      elsif (load = '1') then			-- load counter
        counter_reg	<= unsigned(data_in);
        done		<= '0';			-- start a new countdown - deassert done signal
      elsif (en = '1') then			-- is counting enabled?
        if (counter_reg = 0) then	  	-- check if counter reached zero
          done     	<= '1';			-- set done output
        else
          counter_reg <= counter_reg - 1;	-- decrement counter
        end if;	
      end if;			
    end if;
  end process counter_pr;

  data_out <= std_logic_vector(counter_reg);

end rtl;
