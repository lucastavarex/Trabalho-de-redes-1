-------------- DATA: 22/06/2022                        --------------
-------------- AUTOR: LUCAS TAVARES DA SILVA FERREIRA  --------------
-------------- DRE: 120152739                          --------------
-------------- TÍTULO: TRABALHO 1 DE LABORATÓRIO       --------------
-------------- DISCIPLINA: SISTEMAS DIGITAIS           --------------
-------------- PROFESSOR: ROBERTO PACHECO              --------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ULA IS -- LA ULA ULA
    PORT( 
		A, B: IN STD_LOGIC_VECTOR (3 DOWNTO 0);   -- OPERANDOS
		SEL : IN STD_LOGIC_VECTOR (2 DOWNTO 0);    -- SELECIONA OPERAÇÃO 
		RES: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);   -- FLAGS
        COUT,NULO,NEG,OVRF: OUT STD_LOGIC ;       -- VETOR DE SAÍDA FINAL
        RES2: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);  -- VARIÁVEIS TEMPORÁRIAS DE RESULTADO
        R1,R2,R3,R4: OUT STD_LOGIC
		
		  ); 
END ULA;

ARCHITECTURE DADOS OF ULA IS
SIGNAL S,RES_SOMA,RES_SOMA3,RES_SUBT,RES_SUBT1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
CONSTANT ZERO,ZERO3 : STD_LOGIC := '0';
SIGNAL CARRYOUT1, CARRYOUT2,CARRYOUT3,CARRYOUT4, OVERFLOW1, OVERFLOW2, OVERFLOW3, OVERFLOW4 : STD_LOGIC;
SIGNAL X1, X2, X3, X4,X5,X6,X7,X8, AUX: STD_LOGIC; -- VARIÁVEIS INTERMEDIARIAS


COMPONENT SUBTRADOR4 IS 
    PORT( 
		NA, NB: IN STD_LOGIC_VECTOR (3 DOWNTO 0) ; -- VETOR DE ENTRADA
		SUBT: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);   -- VETOR DE SAIDA
		CARRY_OUT,OVERFLOW: OUT STD_LOGIC          -- BIT DE COUT E OVF
            );
END COMPONENT SUBTRADOR4;

COMPONENT SOMADOR4 IS
PORT ( 
A, B: IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
CARRY_IN: IN STD_LOGIC;
SOMA: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
CARRY_OUT,OVERFLOW: OUT STD_LOGIC
);
END COMPONENT SOMADOR4;



	BEGIN
	ADD: SOMADOR4 PORT MAP (A, B, ZERO, RES_SOMA, CARRYOUT2, OVERFLOW2);         -- SOMA DE A E B
	SUBT0: SUBTRADOR4 PORT MAP (A, B, RES_SUBT, CARRYOUT1, OVERFLOW1);           -- SUBTRAÇÃO 
	ADD1: SOMADOR4 PORT MAP (A, "0001", ZERO3, RES_SOMA3, CARRYOUT3, OVERFLOW3); -- PARA O INCREMENTO DE 1
	SUBT1: SUBTRADOR4 PORT MAP ("0000", A, RES_SUBT1, CARRYOUT4, OVERFLOW4);     -- COMPLEMENTO DE 2
    
    
   -- LÓGICA PARA SELECIONAR A OPERAÇÃO 
	X1<= ((NOT (SEL(2))) AND (NOT (SEL (1))) AND (NOT (SEL (0))));    --  (A-B)
	X2<= ((NOT (SEL(2))) AND (NOT (SEL (1))) AND ( (SEL (0))));       --  (A+B)
	X3<= ((NOT (SEL(2))) AND ( (SEL (1))) AND (NOT (SEL (0))));       --  INCREMENTO DE UM DE A
	X4<= ((NOT (SEL(2))) AND ( (SEL (1))) AND ( (SEL (0))));          --  TROCA DE SINAL DE A - C2
	X5<=  (( (SEL(2))) AND (NOT (SEL (1))) AND (NOT (SEL (0))));      --  OR  BIT A BIT  AB
	X6<=  (( (SEL(2))) AND ( NOT (SEL (1))) AND ( (SEL (0))));        --  NOT A
  	X7 <= (((SEL(2))) AND ( (SEL (1))) AND ( NOT (SEL (0))));         --  NOT B
	X8<= (( (SEL(2))) AND ( (SEL (1))) AND ((SEL (0))));              --  NOT C
	
	-- AGORA FAZEMOS A LÓGICA PARA O RESULTADO
	S (3)<=(X1 AND RES_SUBT(3)) OR (X2 AND RES_SOMA(3)) OR (X3 AND RES_SOMA3(3)) OR (X4 AND RES_SUBT1(3)) OR (X5 AND (A(3) OR B(3))) OR (X6 AND (NOT (A(3)))) OR (X7 AND (NOT (B(3)))) OR   (X8 AND (A(3) AND B(3)))  ;
	S (2)<=(X1 AND RES_SUBT(2)) OR (X2 AND RES_SOMA(2)) OR (X3 AND RES_SOMA3(2)) OR (X4 AND RES_SUBT1(2)) OR (X5 AND (A(2) OR B(2))) OR (X6 AND (NOT (A(2)))) OR (X7 AND (NOT (B(2)))) OR   (X8 AND (A(2) AND B(2)) ) ;
	S (1)<=(X1 AND RES_SUBT(1)) OR (X2 AND RES_SOMA(1)) OR (X3 AND RES_SOMA3(1)) OR (X4 AND RES_SUBT1(1)) OR (X5 AND (A(1) OR B(1))) OR (X6 AND (NOT (A(1)))) OR (X7 AND (NOT (B(1)))) OR   (X8 AND (A(1) AND B(1)))  ;
	S (0)<=(X1 AND RES_SUBT(0)) OR (X2 AND RES_SOMA(0)) OR (X3 AND RES_SOMA3(0)) OR (X4 AND RES_SUBT1(0)) OR (X5 AND (A(0) OR B(0))) OR (X6 AND (NOT (A(0)))) OR (X7 AND (NOT (B(0)))) OR   (X8 AND (A(3) AND B(0)))  ;
	RES<=S;
	

 	R1 <=  S(3)   ;
    R2 <=  S(2)  ;
	R3 <=  S(1)   ;
    R4 <=  S(0)   ;
	
	
    NEG<=S(3);
	COUT <= (X1 AND CARRYOUT1) OR (X2 AND CARRYOUT2) OR (X3 AND CARRYOUT3) OR (X4 AND CARRYOUT4);
	AUX <=  (X1 AND OVERFLOW1) OR (X2 AND OVERFLOW2) OR (X3 AND OVERFLOW3) OR (X4 AND OVERFLOW4);
	NULO <= (NOT AUX) AND (NOT S(3)) AND (NOT  S(2)) AND ( NOT S(1)) AND (NOT S (0));
	OVRF <= AUX;


END DADOS;