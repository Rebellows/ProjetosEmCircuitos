library IEEE;
use IEEE.std_logic_1164.all;

entity transmissor is
    port ( clock,reset,send: in STD_LOGIC;
           palavra: in std_logic_vector(7 downto 0);
           busy, linha: out STD_LOGIC
         );
end transmissor;

architecture a1 of transmissor is
    type STATES is (swait, sstart, S7, S6, S5, S4, S3, S2, S1, S0, sstop);
    signal EA, PE : STATES;
    signal saida: std_logic_vector(7 downto 0);
    signal linha_rx: std_logic;
    signal recebido: std_logic;     
begin
  
    process(clock, reset)
    begin
        if reset = '1' then 
            EA<=swait;
        elsif rising_edge(clock) then
            EA<=PE;
        end if;
    end process;

    process(EA, send) 
    begin
         case EA is
		when swait => if send = '0' then
				PE <= swait;
			else
				PE <= sstart;
			end if;
		when sstart => PE <= S7;
		when S7 => PE <= S6;
		when S6 => PE <= S5;
		when S5 => PE <= S4;
		when S4 => PE <= S3;
		when S3 => PE <= S2;
		when S2 => PE <= S1;
		when S1 => PE <= S0;
		when S0 => PE <= sstop;
		when sstop => PE <= swait;
        end case;            
    end process;

	
	busy <= '0' when EA = swait else '1';
	
	linha <= palavra(7) when EA = S7 else 
		 palavra(6) when EA = s6 else
		 palavra(5) when EA = S5 else
		 palavra(4) when EA = S4 else
		 palavra(3) when EA = S3 else
		 palavra(2) when EA = S2 else
		 palavra(1) when EA = S1 else
		 palavra(0) when EA = S0 else
		 '0' when EA = sstop or EA = sstart else '1';
		 
end a1;
