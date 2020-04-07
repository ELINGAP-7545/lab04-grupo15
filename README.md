#Implemetacion BCD en display 7 segmentos

# INTEGRANTES:

**Arley Stiven Rodriguez 60335;**

**Cesar Eduardo Martinez 63810;** 

**Juan Camilo Arévalo Garzón 63572;**  

# lab04
BCD2SSeg

# Introducción
En el presente trabajo se llevara a cabo la verificación e implemetación de un display de 7 segmentos el cual permitira la visualización de números hexadecimales. Inicialmente se comprobara el correcto funcionamiento con un solo display 7 segmentos, como siguiente paso se implemetaran 3 displays adicionales para completar un total de 4 con los cuales se realizara la verificación y correcto funcionamiento acorde a lo solicitado. A través de este trabajo abordaremos de forma optima el manejo adecuado de la heramienta utilizada (github) de igual forma en la simulacion analizaremos el funcionamiento de un hardware sencillo con la ayuda de herramientas computacionales como lo son Quartus.

# Diseño BCD-7seg

Teniendo en cuenta los ejercicios realizados en el transcurso de las clases: sumador, multiplicador y divisor ya se esta en la capacidad de diseñar hardware básico de forma optima. Para este ejercicio se propone realizar el diseño, sintentización e implementación del Display de 7 segmentos, el cual permite visualizar números en representación hexadecimal (0x0 a 0xF).  En el siguiente gráfico, se observa cual es el funcionamiento deseado del display:   


![gif_display](https://github.com/ELINGAP-7545/lab04-grupo15/blob/c874e64b35273e6b88f51a7db88721c01a7b3d35/Imagenes/seven-segment-display.gif)


A continuación se presentan los pasos recomendados para el ejercicio:

**Definir la caja funcional del BCD**: 

![bcd_black](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab03-BCD2SSeg/doc/BCD2SSeg.jpg)

Si se observa la caja negra/ funcional  además  de la salida de 7 segmentos este contiene  una salida `An`, esta salida es para conectar eventualmente el ánodo del display y poder hacer visualización dinámica cuando se tiene más de un display conectado.


**Definir la descripción Funcional**

Para ello se debe recordar que se puede hacer uso, bien sea, de las tablas de verdad o de la descripción algorítmica del BCD a  siete segmentos. Recordar que cada segmento es una salida  del diseño. Ejemplo, si desea  visualizar el número **1**, la salida seria `Sseg es 0110000`. Observar la gráfica a continuación para generar las salidas acorde al número de entrada.

![sseg](https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/7_segment_display_labeled.svg/1024px-7_segment_display_labeled.svg.png)


## Ejercicio - Visualización 1 Display
A continucacion se puede obervar la simulacion realizada para la utilizacion de un display 7 segmentos se puede visualizar la simulacion en numeros binarios de los numeros desde el 0 hasta el 9 en la parte superior, y la parte inferior la representacion de la poscion que se toma en para su visualizacion en el display 

![Imagen1](https://github.com/ELINGAP-7545/lab04-grupo15/blob/master/Imagenes/Captura123.JPG)



**Ejercicio - Visualización 1 Display Decimal hasta 15**

A continuacion se visualizara al igual que en el ejercicio anterior la simulacion de la representacion de display de 7 segmentos en bits pero en este caso lo representamos desde el número 0 hasta el 15 en forma decimal


![Codigo1](https://github.com/ELINGAP-7545/lab04-grupo15/blob/master/Imagenes/Codigo1.JPG)


![Simulacion1](https://github.com/ELINGAP-7545/lab04-grupo15/blob/master/Imagenes/Simulacion1.JPG)



# Ejercicio - Visualización Dinámica 4 Display


Si el diseño digital de algún sistema se requiere mas de un display de 7 segmentos, es necesario  generar una visualización tal que sea necesario el menor número de pines para conectar todos los display en con la FPGA.

Por ahora, se ha visualizado el números en un solo display de 7 segmentos. Pero en la mayoría de los casos, los 7 pines de los cátodos están inter-conectados entre cada display, como se observa en la figura:

![conex](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab04_display_7segx4/doc/conex.png)

Por lo tanto, se debe  realizar una multiplexación  entre los Anodos de cada Display, con el fin de visualizar en cada display un número diferente.  En otras palabras, en cada instante de tiempo, solo un display se encuentra activo. En este sentido, se debe garantizar que el destello en la visualización entre cada display no se perciba. Para ello, cada display debe activarse máximo cada 16 ms.

Visualmente esto se entiende mas con la siguiente simulación, donde se desea visualizar el  número en representación hexadecimal `0x4321`:


![diagrama](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab04_display_7segx4/doc/4sseg.jpg)


## Diagrama Caja negra 

Como siempre, antes de realizar la descripción del hardware se debe diseñar la caja funcional del modulo, con las entradas y salidas

![diagrama caja negra ](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab04_display_7segx4/doc/display_7segx4.jpg)

En este sentido, se adiciona al HDL de siete segmentos 4 señales de control para el LCD, llamadas An. cada bit de la señal `An` debe ser modificado en el tiempo, con el fin de activar solo un display.  

## Diagrama Estructural 

![estructural](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab04_display_7segx4/doc/display_7segx4_Diag_Estructural.jpg)

Se evidencia que se deben construir cuatro módulos  básicos, de los cuales uno de ellos esta descrito en el ejercicio anterior, [BCDtoSSeg.v](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab04_display_7segx4/src_ise_basys2/display_7segx4/BCDtoSSeg.v) . Los otros tres bloques son:

* Divisor de frecuencia: Su función es dividir la frecuencia de  `clk` de entrada, en el tiempo requerido para cada camvio de ánodo
* Selector de Ánodo: Sincronizado con la frecuencia  que genera el divisor, cambia en cada instante de tiempo el  ánodo, se puede ver como un registro de desplazamiento del bit 0 `1110 1101 1011 0111`
* Selector de Datos: dependiendo del ánodo activado, activa los datos correspondientes.

# BCD 4 Display 7 segmentos

**Codigo BCD**


  módulo  BCDtoSSeg (BCD, SSeg, an);

  entrada [ 3 : 0 ] BCD;
  salida  reg [ 0 : 6 ] SSeg;
  salida [ 3 : 0 ] an;

asignar un = 4'b1110 ;


siempre @ ( * ) comienza
  caso (BCD)	
   4'b0000 : SSeg =  7'b0000001 ; // "0"  
	4'b0001 : SSeg =  7'b1001111 ; // "1"
	4'b0010 : SSeg =  7'b0010010 ; // "2"
	4'b0011 : SSeg =  7'b0000110 ; // "3"
	4'b0100 : SSeg =  7'b1001100 ; // "4"
	4'b0101 : SSeg =  7'b0100100 ; // "5"
	4'b0110 : SSeg =  7'b0100000 ; // "6"
	4'b0111 : SSeg =  7'b0001111 ; // "7"
	4'b1000 : SSeg =  7'b0000000 ; // "8"  
	4'b1001 : SSeg =  7'b0000100 ; // "9"
   // 4'ha: SSeg = 7'b0001000; // Se quitan los numeros exadecimal ya que en este caso no es necesario su visualización
   // 4'hb: SSeg = 7'b1100000;
   // 4'hc: SSeg = 7'b0110001;
   // 4'hd: SSeg = 7'b1000010;
   // 4'he: SSeg = 7'b0110000;
   // 4'hf: SSeg = 7'b0111000;
    por defecto :
    SSeg =  0 ;
  endcase
fin

endmodule



**Simulacion en 4 display 7 segmentos**

![Display7seg](https://github.com/ELINGAP-7545/lab04-grupo15/blob/master/Imagenes/Display7seg.JPG)



**Codigo display**

`timescale 1ns / 1ps // escala de tiempo [unidad de tiempo] / [precisión de tiempo]

module display(
    input [15:0] num,
    input clk,
    output [0:6] sseg,
    output reg [3:0] an,
	 input rst,
	 output led
    );



reg [3:0]bcd=0;  // Restriccion de maximo 4 posiciones de numero 
//wire [15:0]num=16'h4321;
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));

reg [26:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[16];
assign led =enable;
always @(posedge clk) begin
  if(rst==1) begin 
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1; 
	end
end

reg [1:0] count =0;
always @(posedge enable) begin
		if(rst==1) begin
			count<= 0; // Mientras rst sea contador permanece en cero
			an<=4'b1111; 
		end else begin 
			count<= count+1; // Si rst es deferente de 1 contador aumenta hasta ocupar todas las posiciones de anodo
			an<=4'b1101; 
			case (count) 
				2'h0: begin bcd <= num[3:0];   an<=4'b1110; end 
				2'h1: begin bcd <= num[7:4];   an<=4'b1101; end 
				2'h2: begin bcd <= num[11:8];  an<=4'b1011; end 
				2'h3: begin bcd <= num[15:12]; an<=4'b0111; end 
			endcase
		end
end

endmodule


![Codigo_display](https://github.com/ELINGAP-7545/lab04-grupo15/blob/master/Imagenes/Codigo_Display.JPG)

**Testbench 4 display**

`timescale 1ns / 1ps   // escala de tiempo [unidad de tiempo] / [precisión de tiempo]

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:17:21 09/05/2019
// Design Name:   display
// Module Name:   C:/Users/UECCI/Desktop/ejer01/display_7segx4/testbench.v
// Project Name:  display_7segx4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: display
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg [15:0] num;
	reg clk2;
	reg rst;

	// Outputs
	wire [0:6] sseg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	display uut (  	// en este bloque llama al modulo de display y ejecuta
		.num(num), 
		.clk(clk2), 
		.sseg(sseg), 
		.an(an), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk2= 0; // apenas comienza la simulacion clk va a arrancar en cero
		rst = 1;	// apenas comienza la simulacion rst (reset) va a arrancar en uno
		#10 rst =0; //depues de un espacio de tiempo rst pasa a cero
		
		num = 16'h4321;
        

	end
      

	always #1 clk2 = ~clk2;
	
endmodule
