class uart_driver;

  logic verbose = 1;

  logic  [7:0]    q_UART[$];

  logic CTS;
  logic RXD;

  logic uart_state_idle;
  logic uart_state_start;
  logic uart_state_D0;
  logic uart_state_D1;
  logic uart_state_D2;
  logic uart_state_D3;
  logic uart_state_D4;
  logic uart_state_D5;
  logic uart_state_D6;
  logic uart_state_D7;
  logic uart_state_P0;
  logic uart_state_stop;
  logic [3:0] uart_state_timer;
  logic [11:0] uart_buffer;

  int uart_sample;

  function void reset();
    uart_state_idle = '1;
    uart_state_start  = '0;
    uart_state_D0  = '0;
    uart_state_D1  = '0;
    uart_state_D2  = '0;
    uart_state_D3  = '0;
    uart_state_D4  = '0;
    uart_state_D5  = '0;
    uart_state_D6  = '0;
    uart_state_D7  = '0;
    uart_state_P0  = '0;
    uart_state_stop  = '0;
    uart_state_timer  = '0;
    uart_sample = 0;
    CTS = '1;
    RXD = '1;
  endfunction

  function void drive(
    output logic CTS,
    output logic RXD
    );

    CTS = '1;

    uart_sample      <= uart_sample + 40; //Match ticks per clock for now

    uart_state_idle  <= '0;
    uart_state_start <= '0;
    uart_state_D0    <= '0;
    uart_state_D1    <= '0;
    uart_state_D2    <= '0;
    uart_state_D3    <= '0;
    uart_state_D4    <= '0;
    uart_state_D5    <= '0;
    uart_state_D6    <= '0;
    uart_state_D7    <= '0;
    uart_state_P0    <= '0;
    uart_state_stop  <= '0;

    case('1)
      uart_state_idle:  begin
                        RXD = '1;
                        if(q_UART.size() > 0 && 
                           uart_sample%240 == 0)
                          begin
                            uart_state_start <= '1;
                          end 
                        else 
                          begin
                            uart_state_idle <= '1;
                          end
                        end
      uart_state_start: begin
                        RXD = '0;
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D0 <= '1;
                          end 
                        else 
                          begin
                            uart_state_start <= '1;
                          end
                        end
      uart_state_D0:    begin
                        RXD = q_UART[0][0];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D1 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D0 <= '1;
                          end
                        end
      uart_state_D1:    begin
                        RXD = q_UART[0][1];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D2 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D1 <= '1;
                          end
                        end
      uart_state_D2:    begin
                        RXD = q_UART[0][2];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D3 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D2 <= '1;
                          end
                        end
      uart_state_D3:    begin
                        RXD = q_UART[0][3];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D4 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D3 <= '1;
                          end
                        end
      uart_state_D4:    begin
                        RXD = q_UART[0][4];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D5 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D4 <= '1;
                          end
                        end
      uart_state_D5:    begin
                        RXD = q_UART[0][5];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D6 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D5 <= '1;
                          end
                        end
      uart_state_D6:    begin
                        RXD = q_UART[0][6];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_D7 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D6 <= '1;
                          end
                        end
      uart_state_D7:    begin
                        RXD = q_UART[0][7];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_P0 <= '1;
                          end 
                        else 
                          begin
                            uart_state_D7 <= '1;
                          end
                        end
      uart_state_P0:    begin
                        RXD = ^q_UART[0];
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_stop <= '1;
                          end 
                        else 
                          begin
                            uart_state_P0 <= '1;
                          end
                        end
      uart_state_stop:  begin
                        RXD = '1;
                        if(uart_sample%240 == 0)
                          begin
                          uart_state_idle <= '1;
                          $display("> %c",q_UART[0]);
                          q_UART.pop_front();
                          end 
                        else 
                          begin
                            uart_state_stop <= '1;
                          end
                        end
    endcase

  endfunction

  function void putchar(
    logic [7:0] c
    );
    q_UART.push_back(c);
  endfunction

endclass
