
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : long, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R5
	.DEF _rx_rd_index0=R4
	.DEF _rx_counter0=R7
	.DEF _tx_wr_index0=R6
	.DEF _tx_rd_index0=R9
	.DEF _tx_counter0=R8
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x52,0x65,0x63,0x3A,0x0,0x73,0x65,0x6E
	.DB  0x64,0x3A,0x0,0x73,0x65,0x6E,0x64,0x69
	.DB  0x6E,0x67,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x05
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x15
	.DW  _0x0*2+5

	.DW  0x06
	.DW  _0x15+6
	.DW  _0x0*2+5

	.DW  0x06
	.DW  _0x15+12
	.DW  _0x0*2+5

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 4/13/2015
;Author  : ROOT
;Company : eng
;Comments:
;
;
;Chip type               : ATmega64
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;#include <stdio.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0051 {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0052 char status,data;
; 0000 0053 char message;
; 0000 0054 char lcd_buffer[16];
; 0000 0055 status=UCSR0A;
	SBIW R28,16
	CALL __SAVELOCR4
;	status -> R17
;	data -> R16
;	message -> R19
;	lcd_buffer -> Y+4
	IN   R17,11
; 0000 0056 data=UDR0;
	IN   R16,12
; 0000 0057 
; 0000 0058 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0059    {
; 0000 005A    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 005B #if RX_BUFFER_SIZE0 == 256
; 0000 005C    // special case for receiver buffer size=256
; 0000 005D    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 005E #else
; 0000 005F    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0060    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 0061       {
; 0000 0062       rx_counter0=0;
	CLR  R7
; 0000 0063       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0064       }
; 0000 0065 #endif
; 0000 0066    }
_0x5:
; 0000 0067    lcd_clear();
_0x3:
	CALL _lcd_clear
; 0000 0068               message=getchar();
	RCALL _getchar
	MOV  R19,R30
; 0000 0069               lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 006A               lcd_puts("Rec:");
	__POINTW2MN _0x6,0
	CALL _lcd_puts
; 0000 006B               lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 006C               itoa(message,lcd_buffer);
	MOV  R30,R19
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x0
; 0000 006D               lcd_puts(lcd_buffer);
; 0000 006E }
	CALL __LOADLOCR4
	ADIW R28,20
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI

	.DSEG
_0x6:
	.BYTE 0x5
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0075 {

	.CSEG
_getchar:
; 0000 0076 char data;
; 0000 0077 while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x7:
	TST  R7
	BREQ _0x7
; 0000 0078 data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 0079 #if RX_BUFFER_SIZE0 != 256
; 0000 007A if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0xA
	CLR  R4
; 0000 007B #endif
; 0000 007C #asm("cli")
_0xA:
	cli
; 0000 007D --rx_counter0;
	DEC  R7
; 0000 007E #asm("sei")
	sei
; 0000 007F return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0080 }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0090 {
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0091 if (tx_counter0)
	TST  R8
	BREQ _0xB
; 0000 0092    {
; 0000 0093    --tx_counter0;
	DEC  R8
; 0000 0094    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0095 #if TX_BUFFER_SIZE0 != 256
; 0000 0096    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xC
	CLR  R9
; 0000 0097 #endif
; 0000 0098    }
_0xC:
; 0000 0099 }
_0xB:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00A0 {
_putchar:
; 0000 00A1 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0xD:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0xD
; 0000 00A2 #asm("cli")
	cli
; 0000 00A3 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x11
	SBIC 0xB,5
	RJMP _0x10
_0x11:
; 0000 00A4    {
; 0000 00A5    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00A6 #if TX_BUFFER_SIZE0 != 256
; 0000 00A7    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x13
	CLR  R6
; 0000 00A8 #endif
; 0000 00A9    ++tx_counter0;
_0x13:
	INC  R8
; 0000 00AA    }
; 0000 00AB else
	RJMP _0x14
_0x10:
; 0000 00AC    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00AD #asm("sei")
_0x14:
	sei
; 0000 00AE }
	JMP  _0x20C0001
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;void main(void)
; 0000 00B8 { int key_pressed;
_main:
; 0000 00B9 int sendbuffer;
; 0000 00BA char lcd_buffer[16];
; 0000 00BB int index=4;
; 0000 00BC int state_flag=0;
; 0000 00BD int ok=0;
; 0000 00BE sendbuffer=0;
	SBIW R28,20
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	key_pressed -> R16,R17
;	sendbuffer -> R18,R19
;	lcd_buffer -> Y+4
;	index -> R20,R21
;	state_flag -> Y+2
;	ok -> Y+0
	__GETWRN 20,21,4
	__GETWRN 18,19,0
; 0000 00BF // Declare your local variables here
; 0000 00C0 
; 0000 00C1 // Input/Output Ports initialization
; 0000 00C2 // Port A initialization
; 0000 00C3 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C4 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C5 PORTA=0x00;
	OUT  0x1B,R30
; 0000 00C6 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00C7 
; 0000 00C8 // Port B initialization
; 0000 00C9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00CA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00CB PORTB=0x00;
	OUT  0x18,R30
; 0000 00CC DDRB=0x00;
	OUT  0x17,R30
; 0000 00CD 
; 0000 00CE // Port C initialization
; 0000 00CF // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00D0 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 00D1 PORTC=0x00;
	OUT  0x15,R30
; 0000 00D2 DDRC=0x00;
	OUT  0x14,R30
; 0000 00D3 
; 0000 00D4 // Port D initialization
; 0000 00D5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00D6 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00D7 PORTD=0x00;
	OUT  0x12,R30
; 0000 00D8 DDRD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 00D9 
; 0000 00DA // Port E initialization
; 0000 00DB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00DC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00DD PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 00DE DDRE=0x00;
	OUT  0x2,R30
; 0000 00DF 
; 0000 00E0 // Port F initialization
; 0000 00E1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E3 PORTF=0x00;
	STS  98,R30
; 0000 00E4 DDRF=0x00;
	STS  97,R30
; 0000 00E5 
; 0000 00E6 // Port G initialization
; 0000 00E7 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E8 // State4=T State3=T State2=T State1=T State0=T
; 0000 00E9 PORTG=0x00;
	STS  101,R30
; 0000 00EA DDRG=0x00;
	STS  100,R30
; 0000 00EB 
; 0000 00EC // Timer/Counter 0 initialization
; 0000 00ED // Clock source: System Clock
; 0000 00EE // Clock value: Timer 0 Stopped
; 0000 00EF // Mode: Normal top=0xFF
; 0000 00F0 // OC0 output: Disconnected
; 0000 00F1 ASSR=0x00;
	OUT  0x30,R30
; 0000 00F2 TCCR0=0x00;
	OUT  0x33,R30
; 0000 00F3 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00F4 OCR0=0x00;
	OUT  0x31,R30
; 0000 00F5 
; 0000 00F6 // Timer/Counter 1 initialization
; 0000 00F7 // Clock source: System Clock
; 0000 00F8 // Clock value: Timer1 Stopped
; 0000 00F9 // Mode: Normal top=0xFFFF
; 0000 00FA // OC1A output: Discon.
; 0000 00FB // OC1B output: Discon.
; 0000 00FC // OC1C output: Discon.
; 0000 00FD // Noise Canceler: Off
; 0000 00FE // Input Capture on Falling Edge
; 0000 00FF // Timer1 Overflow Interrupt: Off
; 0000 0100 // Input Capture Interrupt: Off
; 0000 0101 // Compare A Match Interrupt: Off
; 0000 0102 // Compare B Match Interrupt: Off
; 0000 0103 // Compare C Match Interrupt: Off
; 0000 0104 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0105 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0106 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0107 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0108 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0109 ICR1L=0x00;
	OUT  0x26,R30
; 0000 010A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 010B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 010C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 010D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 010E OCR1CH=0x00;
	STS  121,R30
; 0000 010F OCR1CL=0x00;
	STS  120,R30
; 0000 0110 
; 0000 0111 // Timer/Counter 2 initialization
; 0000 0112 // Clock source: System Clock
; 0000 0113 // Clock value: Timer2 Stopped
; 0000 0114 // Mode: Normal top=0xFF
; 0000 0115 // OC2 output: Disconnected
; 0000 0116 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0117 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0118 OCR2=0x00;
	OUT  0x23,R30
; 0000 0119 
; 0000 011A // Timer/Counter 3 initialization
; 0000 011B // Clock source: System Clock
; 0000 011C // Clock value: Timer3 Stopped
; 0000 011D // Mode: Normal top=0xFFFF
; 0000 011E // OC3A output: Discon.
; 0000 011F // OC3B output: Discon.
; 0000 0120 // OC3C output: Discon.
; 0000 0121 // Noise Canceler: Off
; 0000 0122 // Input Capture on Falling Edge
; 0000 0123 // Timer3 Overflow Interrupt: Off
; 0000 0124 // Input Capture Interrupt: Off
; 0000 0125 // Compare A Match Interrupt: Off
; 0000 0126 // Compare B Match Interrupt: Off
; 0000 0127 // Compare C Match Interrupt: Off
; 0000 0128 TCCR3A=0x00;
	STS  139,R30
; 0000 0129 TCCR3B=0x00;
	STS  138,R30
; 0000 012A TCNT3H=0x00;
	STS  137,R30
; 0000 012B TCNT3L=0x00;
	STS  136,R30
; 0000 012C ICR3H=0x00;
	STS  129,R30
; 0000 012D ICR3L=0x00;
	STS  128,R30
; 0000 012E OCR3AH=0x00;
	STS  135,R30
; 0000 012F OCR3AL=0x00;
	STS  134,R30
; 0000 0130 OCR3BH=0x00;
	STS  133,R30
; 0000 0131 OCR3BL=0x00;
	STS  132,R30
; 0000 0132 OCR3CH=0x00;
	STS  131,R30
; 0000 0133 OCR3CL=0x00;
	STS  130,R30
; 0000 0134 
; 0000 0135 // External Interrupt(s) initialization
; 0000 0136 // INT0: Off
; 0000 0137 // INT1: Off
; 0000 0138 // INT2: Off
; 0000 0139 // INT3: Off
; 0000 013A // INT4: Off
; 0000 013B // INT5: Off
; 0000 013C // INT6: Off
; 0000 013D // INT7: Off
; 0000 013E EICRA=0x00;
	STS  106,R30
; 0000 013F EICRB=0x00;
	OUT  0x3A,R30
; 0000 0140 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0141 
; 0000 0142 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0143 TIMSK=0x00;
	OUT  0x37,R30
; 0000 0144 
; 0000 0145 ETIMSK=0x00;
	STS  125,R30
; 0000 0146 
; 0000 0147 // USART0 initialization
; 0000 0148 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0149 // USART0 Receiver: On
; 0000 014A // USART0 Transmitter: On
; 0000 014B // USART0 Mode: Asynchronous
; 0000 014C // USART0 Baud Rate: 9600
; 0000 014D UCSR0A=0x00;
	OUT  0xB,R30
; 0000 014E UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 014F UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0150 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0151 UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0152 
; 0000 0153 // USART1 initialization
; 0000 0154 // USART1 disabled
; 0000 0155 UCSR1B=0x00;
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0156 
; 0000 0157 // Analog Comparator initialization
; 0000 0158 // Analog Comparator: Off
; 0000 0159 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 015A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 015B SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 015C 
; 0000 015D // ADC initialization
; 0000 015E // ADC disabled
; 0000 015F ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0160 
; 0000 0161 // SPI initialization
; 0000 0162 // SPI disabled
; 0000 0163 SPCR=0x00;
	OUT  0xD,R30
; 0000 0164 
; 0000 0165 // TWI initialization
; 0000 0166 // TWI disabled
; 0000 0167 TWCR=0x00;
	STS  116,R30
; 0000 0168 
; 0000 0169 // Alphanumeric LCD initialization
; 0000 016A // Connections are specified in the
; 0000 016B // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 016C // RS - PORTA Bit 0
; 0000 016D // RD - PORTA Bit 1
; 0000 016E // EN - PORTA Bit 2
; 0000 016F // D4 - PORTA Bit 4
; 0000 0170 // D5 - PORTA Bit 5
; 0000 0171 // D6 - PORTA Bit 6
; 0000 0172 // D7 - PORTA Bit 7
; 0000 0173 // Characters/line: 16
; 0000 0174 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0175 
; 0000 0176 // Global enable interrupts
; 0000 0177 #asm("sei")
	sei
; 0000 0178   lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0179   lcd_puts("send:");
	__POINTW2MN _0x15,0
	CALL _lcd_puts
; 0000 017A while (1)
_0x16:
; 0000 017B       {   if(state_flag==0 && ok==0){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,0
	BRNE _0x1A
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,0
	BREQ _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 017C           PORTD.0=1;
	SBI  0x12,0
; 0000 017D           PORTD.1=0;
	CBI  0x12,1
; 0000 017E           PORTD.2=0;
	CALL SUBOPT_0x2
; 0000 017F           PORTD.3=0;
; 0000 0180           delay_ms(1);
; 0000 0181           if(PIND.4==1)
	SBIS 0x10,4
	RJMP _0x24
; 0000 0182           {key_pressed=7;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,7
	CALL SUBOPT_0x3
; 0000 0183           if(PIND.5==1)
_0x24:
	SBIS 0x10,5
	RJMP _0x25
; 0000 0184           {key_pressed=8;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,8
	CALL SUBOPT_0x3
; 0000 0185           if(PIND.6==1)
_0x25:
	SBIS 0x10,6
	RJMP _0x26
; 0000 0186           {key_pressed=9;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,9
	CALL SUBOPT_0x3
; 0000 0187 
; 0000 0188         //ç for stage tow PORTD.1=1
; 0000 0189         //*********************************
; 0000 018A 
; 0000 018B 
; 0000 018C               PORTD.0=0;
_0x26:
	CBI  0x12,0
; 0000 018D               PORTD.1=1;
	SBI  0x12,1
; 0000 018E               PORTD.2=0;
	CALL SUBOPT_0x2
; 0000 018F               PORTD.3=0;
; 0000 0190                delay_ms(1);
; 0000 0191               if(PIND.4==1)
	SBIS 0x10,4
	RJMP _0x2F
; 0000 0192               {key_pressed=4;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,4
	CALL SUBOPT_0x3
; 0000 0193               if(PIND.5==1)
_0x2F:
	SBIS 0x10,5
	RJMP _0x30
; 0000 0194               {key_pressed=5;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,5
	CALL SUBOPT_0x3
; 0000 0195               if(PIND.6==1)
_0x30:
	SBIS 0x10,6
	RJMP _0x31
; 0000 0196               {key_pressed=6;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,6
	CALL SUBOPT_0x3
; 0000 0197         //ç for stage three PORTD.2=1
; 0000 0198         //*********************************
; 0000 0199 
; 0000 019A 
; 0000 019B               PORTD.0=0;
_0x31:
	CBI  0x12,0
; 0000 019C               PORTD.1=0;
	CBI  0x12,1
; 0000 019D               PORTD.2=1;
	SBI  0x12,2
; 0000 019E               PORTD.3=0;
	CBI  0x12,3
; 0000 019F                delay_ms(1);
	CALL SUBOPT_0x4
; 0000 01A0               if(PIND.4==1)
	SBIS 0x10,4
	RJMP _0x3A
; 0000 01A1               {key_pressed=1;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,1
	CALL SUBOPT_0x3
; 0000 01A2               if(PIND.5==1)
_0x3A:
	SBIS 0x10,5
	RJMP _0x3B
; 0000 01A3               {key_pressed=2;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,2
	CALL SUBOPT_0x3
; 0000 01A4               if(PIND.6==1)
_0x3B:
	SBIS 0x10,6
	RJMP _0x3C
; 0000 01A5               {key_pressed=3; sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,3
	CALL SUBOPT_0x3
; 0000 01A6 
; 0000 01A7         //ç for stage four PORTD.3=1
; 0000 01A8         //*********************************
; 0000 01A9 
; 0000 01AA 
; 0000 01AB               PORTD.0=0;
_0x3C:
	CBI  0x12,0
; 0000 01AC               PORTD.1=0;
	CBI  0x12,1
; 0000 01AD               PORTD.2=0;
	CBI  0x12,2
; 0000 01AE               PORTD.3=1;
	SBI  0x12,3
; 0000 01AF                delay_ms(1);
	CALL SUBOPT_0x4
; 0000 01B0               if(PIND.6==1)
	SBIS 0x10,6
	RJMP _0x45
; 0000 01B1               {key_pressed=10;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,10
	CALL SUBOPT_0x3
; 0000 01B2               if(PIND.5==1)
_0x45:
	SBIS 0x10,5
	RJMP _0x46
; 0000 01B3               {key_pressed=0;sendbuffer=10*sendbuffer+key_pressed;index=index+1;state_flag=1;}
	__GETWRN 16,17,0
	CALL SUBOPT_0x3
; 0000 01B4               if(PIND.4==1)
_0x46:
	SBIS 0x10,4
	RJMP _0x47
; 0000 01B5               {
; 0000 01B6               lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 01B7               lcd_clear();
	CALL _lcd_clear
; 0000 01B8               lcd_putsf("sending");
	__POINTW2FN _0x0,11
	CALL _lcd_putsf
; 0000 01B9               delay_ms(100);
	LDI  R26,LOW(100)
	CALL SUBOPT_0x5
; 0000 01BA               putchar(sendbuffer);
	MOV  R26,R18
	RCALL _putchar
; 0000 01BB               lcd_clear();
	CALL _lcd_clear
; 0000 01BC               lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 01BD              lcd_puts("send:");
	__POINTW2MN _0x15,6
	CALL _lcd_puts
; 0000 01BE              sendbuffer=0;
	__GETWRN 18,19,0
; 0000 01BF              index=4;
	__GETWRN 20,21,4
; 0000 01C0 
; 0000 01C1               }
; 0000 01C2 
; 0000 01C3                if(state_flag==1)
_0x47:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x48
; 0000 01C4              {lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 01C5              lcd_puts("send:");
	__POINTW2MN _0x15,12
	CALL _lcd_puts
; 0000 01C6               lcd_gotoxy(index,0);
	ST   -Y,R20
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 01C7               itoa(key_pressed,lcd_buffer);
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x0
; 0000 01C8               lcd_puts(lcd_buffer);
; 0000 01C9               state_flag=0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 01CA               delay_ms(80);  }
	LDI  R26,LOW(80)
	CALL SUBOPT_0x5
; 0000 01CB                  }
_0x48:
; 0000 01CC 
; 0000 01CD       }
_0x19:
	RJMP _0x16
; 0000 01CE }
_0x49:
	RJMP _0x49

	.DSEG
_0x15:
	.BYTE 0x12

	.CSEG
_itoa:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 5
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x20C0001
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R11,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	CALL SUBOPT_0x5
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	CALL SUBOPT_0x5
	LDI  R30,LOW(0)
	MOV  R10,R30
	MOV  R11,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	CP   R11,R13
	BRLO _0x2040004
_0x2040005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R10
	MOV  R26,R10
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040007
	RJMP _0x20C0001
_0x2040007:
_0x2040004:
	INC  R11
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0001
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040008
_0x204000A:
	RJMP _0x20C0002
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x204000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x204000B
_0x204000D:
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
__seed_G100:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	MOVW R26,R28
	ADIW R26,6
	CALL _itoa
	MOVW R26,R28
	ADIW R26,4
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CBI  0x12,2
	CBI  0x12,3
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x3:
	MOVW R30,R18
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R16
	ADC  R31,R17
	MOVW R18,R30
	__ADDWRN 20,21,1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+2,R30
	STD  Y+2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
