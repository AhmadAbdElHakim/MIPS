module clock(clk);
`timescale 100ps/1ps
output reg clk;
initial
	begin
		assign clk = 0;
	end
always
	begin
		#625
		assign clk = 1;
		#625
		assign clk = 0;
	end
endmodule
module PC(Out,In,clk);

input clk;
input [31:0]In;
output reg [31:0]Out;

always@(posedge clk)
begin

Out <= In;

end

endmodule
module DataMemory(ReadData,Address,WriteData,MemRead,MemWrite,clk);


input clk;
input MemRead;
input MemWrite;
input[15:0]Address;
input[31:0]WriteData;
output reg[31:0]ReadData;

reg[31:0]datamem[0:8191];
integer file;
integer i;

always @(posedge clk)		//at rising edge the data of the address is read
begin

 ReadData <= datamem[Address];

end

initial				//to fill the data memory from a file
begin

$readmemb("D:\MIPS/DataMemory/ToDataMem.txt",datamem);

end

initial				//to monitor data memory contents in a file
begin

i=0;

file=$fopen("D:\MIPS/DataMemory/FromDataMem.txt");
$fmonitor(file,"%b // %h \n ",datamem[i],i );

for(i=0;i<8191;i=i+1)
begin
#1
i=i;
end

end

endmodule
module InstructionMemory(Instruction,ReadAdd,clk);

input clk;                   //the instruction is constant within the cycle
 input [31:0]ReadAdd;         //4 hexadicimal digits from pc
output reg [31:0]Instruction;

reg[31:0]instmem[0:8191];
integer file;
integer i;

always @(posedge clk)		//at rising edge the instruction is read
begin

 Instruction <= instmem[ReadAdd>>2];

end

initial				//to fill the instruction memory from a file
begin

$readmemb("D:\MIPS/InstructionMemory/ToInstMem.txt",instmem);

end

initial				//to monitor memory contents in a file
begin

i=0;

file=$fopen("D:\MIPS/InstructionMemory/FromInstMem.txt");
$fmonitor(file,"%b // %h \n ",instmem[i],i );

for(i=0;i<8191;i=i+1)
begin
#1
i=i;
end

end
endmodule









module MIPSALU (ctl, readData1, lowerIn, shamt, ALUresult, zero);
// lowerIn is the mux output

input [3:0] ctl;
input [31:0] readData1,lowerIn;
input [4:0] shamt;
output reg [31:0] ALUresult;
output zero;

// Zero flag equals 1. if the output equals zero
assign zero = (ALUresult == 0);

always @ (ctl, readData1, lowerIn)
 case(ctl)
	0:ALUresult <= readData1 & lowerIn;		//and
	1:ALUresult <= readData1 | lowerIn;		//or (ori)
	2:ALUresult <= readData1 + lowerIn;		//add (lw, sw, addi)
	6:ALUresult <= readData1 - lowerIn;		//sub (beq)
	7:ALUresult <= readData1 < lowerIn ? 1:0;	//slt
	//12:ALUresult <= ~ (readData1 | lowerIn);	//nor
	14:ALUresult <= lowerIn >> shamt;		//sll
	default:ALUresult <= 0;
 endcase
endmodule

module RegFile (ReadData1,ReadData2,ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,clk);

input clk;
input RegWrite;		//from control
input [4:0] ReadReg1;   //from instruction bus
input [4:0] ReadReg2;	//from instruction bus
input [4:0] WriteReg;	//from RegDst MUX
input [31:0] WriteData; //from instruction bus
output reg [31:0] ReadData1;
output reg [31:0] ReadData2;


reg [31:0] registers [0:31] ;

integer i;
integer file;

always @(posedge clk)
begin
//RegFile is supposed to read both regs
 ReadData1 <= registers[ReadReg1];
 ReadData2 <= registers[ReadReg2];
//write in register
if(RegWrite)
	registers[WriteReg]=WriteData;
end


initial				//to monitor registers contents in a file
begin

i=0;

file=$fopen("D:\MIPS/RegFile/FromRegFile.txt");
$fmonitor(file,"%b // %d \n ",registers[i],i );

for(i=0;i<31;i=i+1)
begin
#1
i=i;
end

end
endmodule

module ALUMux (MUXout, readData2, in2, ALUSrc);

output [31:0] MUXout;
input [31:0] readData2, in2;
input ALUSrc;
assign  MUXout = (ALUSrc == 1'b0)? readData2:
		 (ALUSrc == 1'b1)? in2:
		1'bx;
endmodule
module AluCtl(funct,aluop,aluctl);
input [5:0] funct;
input [2:0] aluop;
output reg [3:0] aluctl;

always @ (aluop,funct)

if (aluop == 3'b000)
 aluctl<=2;
else if (aluop==3'b001)
 aluctl<=6;
else if (aluop==3'b010)
  begin
     case (funct)
	32:aluctl <= 2;//add R type
	34:aluctl <= 6;
	36:aluctl <= 0;
	37:aluctl <= 1;
	42:aluctl <= 7;
	default:aluctl <= 0;
      endcase
  end
else if (aluop==3'b011) //addi
  aluctl<=2;
else if (aluop<=3'b100)
  aluctl<=1; //ori
else aluctl<=0;

endmodule


module SignExtend16_32(Exiting,Entering);

input[15:0]Entering;
output wire[31:0]Exiting;

assign Exiting = {{16{Entering[15]}} ,Entering};

endmodule



module ShiftLeft32(Exiting,Entering);

input[31:0]Entering;
output wire[31:0]Exiting;

assign Exiting = {Entering[29:0],2'b00};

endmodule



module ShiftLeft26_28(Exiting,Entering);

input[25:0]Entering;
output wire[27:0]Exiting;

assign Exiting = {Entering,2'b00};

endmodule



module Concatenator(JumpAddress,Instruction,PCplus4);

input[27:0]Instruction;
input[31:28]PCplus4;
output wire[31:0]JumpAddress;

assign JumpAddress = {PCplus4,Instruction};


endmodule


module Mux5(Out,In0,In1,Sel);

input [4:0]In0;
input [4:0]In1;
input Sel;
output reg [4:0]Out;

always@(Out,In0,In1,Sel)
begin
case(Sel)
1'b0: assign Out=In0;
1'b1: assign Out=In1;
default: assign Out=5'bxxxxx;
endcase
end
endmodule



module Mux32(Out,In0,In1,Sel);

input [31:0]In0;
input [31:0]In1;
input Sel;
output reg [31:0]Out;

always@(Out,In0,In1,Sel)
begin
case(Sel)
1'b0: assign Out=In0;
1'b1: assign Out=In1;
default: assign Out=32'dx;
endcase
end
endmodule

module PCAdder(Out,In);

input [31:0]In;
output reg [31:0]Out;
always@(Out,In)
Out<=In+3'b100;

endmodule
module ShiftAdder(Out,In1,In2);
input [31:0]In1;
input [31:0]In2;
output reg [31:0]Out;
always@(Out,In1,In2)
Out<=(In1+In2);
endmodule


module control(regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,opCode);

input[5:0] opCode;
output reg regDst,jump,branch,memRead,memToReg,memWrite,aluSrc,regWrite;
output reg[2:0] aluOp;

always @(opCode)

begin


if(opCode==6'b000000) //R type 
begin
regDst<=1'b1;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b010;
memWrite<=1'b0;
aluSrc<=1'b0;
regWrite<=1'b1;
end


else if(opCode==6'b000100) //beq
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b1;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'b001; //subtract 
memWrite<=1'b0;
aluSrc<=1'b0;
regWrite<=1'b0;
end

else if(opCode==6'b001000) //addi 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b000;
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b001101) //ori 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b100; 
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b101011) //sw 
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'b000; 
memWrite<=1'b1;
aluSrc<=1'b1;
regWrite<=1'b0;
end

else if(opCode==6'b100011) //lw
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b1;
memToReg<=1'b1;
aluOp<=3'b000; 
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b000010) //j
begin
regDst<=1'bx;
jump<=1'b1;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'bxxx; 
memWrite<=1'b0;
aluSrc<=1'bx;
regWrite<=1'b0;
end


else
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'bxxx; 
memWrite<=1'b0;
aluSrc<=1'bx;
regWrite<=1'b0;
end


end

endmodule




module mips_cpu(clock);
input clk;
wire [31:0] RA,MO2,MO3,MO4,MO5,RD1,RD2,aluresult,SignOut,ReadData,Add2in2,Add1out,Add2out,fullJA,IR;
wire [4:0]rs,rt,rd,shift,MO1;
wire [5:0]opcode,func;
wire [15:0]offset;
wire [25:0]JA;
wire [3:0]aluctl,L4BitsOfNewPC;
wire regdst,jump,branch,memread,memtoreg,aluop,memwrite,alusrc,regwrite,zero;
wire [27:0]shiftleft2out;

pc pc1(RA,MO5,clk);
InstructionMemory IM1(IR,RA,clk);
assign rs={IR[25:21]};
assign rt=IR[20:16];
assign rd=IR[15:11];
assign shift=IR[10:6];
assign opcode=IR[31:26];
assign func=IR[5:0];
assign offset=IR[15:0];
assign JA=IR[25:0];
assign L4BitsOfNewPC=Add1out[31:28];
assign fullJA={shiftleft2out,L4BitsOfNewPC};
RegFile RF1(RD1,RD2,rs,rt,MO1,MO3,regwrite,clk);
MIPSALU MALU1(aluctr,RD1,MO2,shift,aluresult,zero);
AluCtl AluCtl1(func,aluop,aluctl);
SignExtend16_32 SE1(SignOut,offset);
control Ctl1(regdst,jump,branch,memread,memtoreg,aluop,memwrite,alusrc,regwrite,opcode);
DataMemory DM1(ReadData,aluresult,RD2,memread,memwrite,clk);
ShiftLeft32 SL1(Add2in2,SignOut);
ShiftAdder SA1(Add2out,Add1out,Add2in2);
PCAdder PCADD1(Add1out,RA);
ShiftLeft26_28 SL2(shiftleft2out,JA);
Mux5 MUX1(MO1,rt,rd,regdst);
Mux32 MUX2(MO2,RD2,SignOut,alusrc);
Mux32 MUX3(MO3,aluresult,ReadData,memtoreg);
Mux32 MUX4(MO4,Add1out,Add2out,(zero&branch)); 
Mux32 MUX5(MO5,MO4,fullJA,jump);
 
endmodule

