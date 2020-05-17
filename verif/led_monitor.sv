class led_monitor;

  logic verbose = 1;

  logic  [7:0]    q_LED[$];

  function void monitor(
    input logic [7:0]    LED
    );

    if(q_LED.size == 0 |
       q_LED[0] !== LED)
    begin
      $display("INFO:  [%0t][led_mon]: LED 0x%02x(%1d)", $time, LED, LED);
      q_LED.push_front(LED);
    end

  endfunction

endclass
