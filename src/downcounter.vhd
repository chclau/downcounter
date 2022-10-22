----------------------------------------------------------------------------------
-- Company:  FPGA'er
-- Engineer: Claudio Avi Chami - FPGA'er Website
--           http://fpgaer.tech
-- Create Date: 25.09.2022 
-- Module Name: downcounter.vhd
-- Description: Counter with enable and done output
--              
-- Dependencies: None
-- 
-- Revision: 3
-- Revision  1 - File Created
--           2 - Using unconstrained unsigned ports 
--           3 - Normalize unconstrained input using alias 
----------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity downcounter is

  port (
    clk      : in  std_logic;
    rstn     : in  std_logic;

    -- inputs
    data_in  : in  unsigned;
    load     : in  std_logic;
    en       : in  std_logic;

    -- outputs
    data_out : out unsigned;
    done     : out std_logic
  );
end downcounter;
architecture rtl of downcounter is
  -- normalize the unconstrained input
  alias data_in_norm : std_logic_vector(data_in'length - 1 downto 0) is data_in; -- normalized unconstrained input
begin

  counter_pr : process (clk)
  begin
    if (rising_edge(clk)) then
      if (rstn = '0') then
        data_out <= (others => '0');
        done <= '0';
      elsif (load = '1') then           -- load counter
        data_out <= unsigned(data_in_norm);
        done <= '0';                    -- start a new countdown - deassert done signal
      elsif (en = '1') then             -- is counting enabled?
        if (data_out = 0) then          -- check if counter reached zero
          done <= '1';                  -- set done output
        else
          data_out <= data_out - 1;     -- decrement counter
        end if;
      end if;
    end if;
  end process counter_pr;

end rtl;