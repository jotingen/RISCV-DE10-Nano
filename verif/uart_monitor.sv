class uart_monitor;

  logic verbose = 1;

  logic  [7:0]    q_UART[$];

  logic uart_state_idle;
  logic uart_state_something;
  logic [3:0] uart_state_timer;
  logic [11:0] uart_buffer;

  int uart_sample;

  function void reset();
    uart_state_idle = '1;
    uart_state_something  = '0;
    uart_state_timer  = '0;
    uart_sample = 0;
  endfunction

  function void monitor(
    input logic RTS,
    input logic TXD
    );

    uart_sample = uart_sample + 40; //Match ticks per clock for now
    if(uart_sample%240 == 0)
      begin
      uart_state_idle <=        '0;
      uart_state_something  <=  '0;
      uart_state_timer  <=            uart_state_timer;             
      uart_buffer <= {uart_buffer[10:0],TXD};
      case('1)
        uart_state_idle: begin
                         if(TXD == '0)
                           begin
                           //$write(TXD);
                           uart_state_something <= '1;
                           end 
                         else
                           begin
                           uart_state_idle <= '1;
                           end 
                         end
        uart_state_something: begin
                         //$write(TXD);
                         if(uart_state_timer == 'd10)
                           begin
                           //$display("");
                           //$display("%b",{uart_buffer[10:0],TXD});
                           //$display("%h",{uart_buffer[2],
                           //               uart_buffer[3],
                           //               uart_buffer[4],
                           //               uart_buffer[5],
                           //               uart_buffer[6],
                           //               uart_buffer[7],
                           //               uart_buffer[8],
                           //               uart_buffer[9]});
                           //$display("%c",{uart_buffer[2],
                           //               uart_buffer[3],
                           //               uart_buffer[4],
                           //               uart_buffer[5],
                           //               uart_buffer[6],
                           //               uart_buffer[7],
                           //               uart_buffer[8],
                           //               uart_buffer[9]});
                           q_UART.push_front({uart_buffer[2],
                                              uart_buffer[3],
                                              uart_buffer[4],
                                              uart_buffer[5],
                                              uart_buffer[6],
                                              uart_buffer[7],
                                              uart_buffer[8],
                                              uart_buffer[9]});
                           $write("%c",q_UART[0]);
                           uart_state_timer <= '0;
                           uart_state_idle <= '1;
                           end 
                         else
                           begin
                           uart_state_timer <= uart_state_timer + 1;
                           uart_state_something <= '1;
                           end 
                         end
      endcase
      end

  endfunction

endclass
