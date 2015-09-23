/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : HW1_903119
Version : 
Date    : 2/26/2015
Author  : RB
Company : 
Comments: 


Chip type               : ATmega64
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/
//digital lock project in c language for AVR MCU Designed By R.Borumandi903119
//here we define header file
#include <mega64.h>
#include <stdlib.h>
#include <delay.h>
#include <stdio.h>
// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here
//here we define password_set[6] varrible that it was flash on flash memory
flash int password_set[6]={9,0,3,1,1,9};
 void main(void)//main function
{//we define our neccessory varrible here
int key_pressed;                  
char str_key_pressed[1];
int flag;
int start_flag_value;
int dimension;
int progress;
int   counter_false;
int index;
int stateok;
char password[6];
int counter_false_state;
index=0;
stateok=0;
start_flag_value=0;
counter_false=0;  
flag=0;
counter_false_state=0;


 
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0x0F;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

ETIMSK=0x00;

// USART0 initialization
// USART0 disabled
UCSR0B=0x00;

// USART1 initialization
// USART1 disabled
UCSR1B=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);
// this is code that pseudo progress bar and print name creator
        lcd_gotoxy(0,0);
        lcd_putsf("loading.....");
        for(progress=0;progress<16;progress++)
        {lcd_gotoxy(progress,1);
        lcd_putsf("\xff");
        delay_ms(50);
        }
        lcd_clear();
        lcd_putsf("Designed By ");
        lcd_gotoxy(0,1);
        lcd_putsf("R.Borumandi");
        delay_ms(1000);
        lcd_clear();
//arrival to core body program
lcd_putsf("enter password");
while (1)
{ 
       //this area code is used for scan key pad tha we want to use it
       if (flag!=1)
          {
              
        // for one stage PORTD.0=1
        //*********************************
          if (stateok!=1) 
         {
          PORTD.0=1;
          PORTD.1=0;
          PORTD.2=0;
          PORTD.3=0; 
          delay_ms(1);
          if(PIND.4==1)
          {key_pressed=1;password[index]=key_pressed;index=index+1;start_flag_value=1;}
          if(PIND.5==1)
          {key_pressed=2;password[index]=key_pressed;index=index+1;start_flag_value=1;}
          if(PIND.6==1)
          {key_pressed=3;password[index]=key_pressed;index=index+1;start_flag_value=1;}
                          
        // for stage tow PORTD.1=1
        //*********************************
       
             
              PORTD.0=0;
              PORTD.1=1;
              PORTD.2=0;
              PORTD.3=0;
               delay_ms(1);
              if(PIND.4==1)
              {key_pressed=4;password[index]=key_pressed;index=index+1;start_flag_value=1;}
              if(PIND.5==1)
              {key_pressed=5;password[index]=key_pressed;index=index+1;start_flag_value=1;}
              if(PIND.6==1)
              {key_pressed=6;password[index]=key_pressed;index=index+1;start_flag_value=1;}
        // for stage three PORTD.2=1
        //*********************************
       
     
              PORTD.0=0;
              PORTD.1=0;
              PORTD.2=1;
              PORTD.3=0; 
               delay_ms(1);
              if(PIND.4==1)
              {key_pressed=7;password[index]=key_pressed;index=index+1;start_flag_value=1;}
              if(PIND.5==1)
              {key_pressed=8;password[index]=key_pressed;index=index+1;start_flag_value=1;}
              if(PIND.6==1)
              {key_pressed=9; password[index]=key_pressed;index=index+1;start_flag_value=1;}
              
        // for stage four PORTD.3=1
        //*********************************
      
             
              PORTD.0=0;
              PORTD.1=0;
              PORTD.2=0;
              PORTD.3=1;  
               delay_ms(1);
              if(PIND.4==1)
              {key_pressed=10;password[index]=key_pressed;index=index+1;start_flag_value=1;}
              if(PIND.5==1)
              {key_pressed=0;password[index]=key_pressed;index=index+1;start_flag_value=1;}
              if(PIND.6==1)
              {flag=1; }
             if(start_flag_value==1)
              {password[index]=key_pressed;
              //
              //here we print key that pressed 
              delay_ms(30);
              itoa(key_pressed,str_key_pressed);   
               // in next stage print *
              lcd_gotoxy(index,1);
              lcd_puts(str_key_pressed); 
              delay_ms(100); 
             lcd_gotoxy(index,1);
              lcd_putsf("*"); 
              delay_ms(100);} 
                  
              if(index>6)
              {stateok=1;
              }
              }
     else
     
     {   //from user is want enter ok for examine password
           start_flag_value=0;
           lcd_clear();
           lcd_gotoxy(0,0);
           lcd_putsf("enter #ok"); 
           if(PIND.6==1)
           {flag=1; }
        
     } 
      
     }
     else{
              //here examin password by press key ok #
             for(dimension=0;dimension<6;dimension++)
             { if( password[dimension]== password_set[dimension])
               {lcd_clear();lcd_gotoxy(0,0);lcd_putsf("welcome");delay_ms(100);    }
               
                else
             {counter_false_state=1;
     
//       
//     
     
     }
     }   
         //here if enter wrong password here wait 30sec 
         if(counter_false_state==1) 
           {counter_false=counter_false+1; 
           lcd_clear();
          lcd_putsf("wrong password!");
          delay_ms(800);
          lcd_clear(); 
           //here is set ready for go first
          if(counter_false==3)
          { lcd_putsf("wait 30 sec");
            delay_ms(30000);
            lcd_gotoxy(0,0);
            lcd_putsf("enter password");
            counter_false=0;
        
      } 
              flag=0; 
              stateok=0;   
              start_flag_value=0;
              counter_false_state=0;
              index=0;
              lcd_clear();
              lcd_gotoxy(0,0); 
              lcd_putsf("enter password");            }
     
       } 
    

}
}