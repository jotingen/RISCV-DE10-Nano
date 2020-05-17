//###########################################################################
//
//  Copyright 2011 XtremeEDA Corp.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//      http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//###########################################################################

`define DDR3_CLK_RESET_FIXTURE(DDR3_CLK_HPERIOD,DDR3_RST_PERIOD) \
parameter ddr3_clkHPeriod = DDR3_CLK_HPERIOD; \
logic ddr3_clk; \
logic ddr3_rst; \
initial begin \
  ddr3_clk = 1; \
  ddr3_rst = 0; \
end \
task automatic ddr3_step(int size = 1); \
  repeat (size) begin \
    int step_size = ddr3_clkHPeriod - $time % (ddr3_clkHPeriod); \
    #(step_size) ddr3_clk <= ~ddr3_clk; \
    #(ddr3_clkHPeriod) ddr3_clk <= ~ddr3_clk; \
  end \
endtask \
task ddr3_nextSamplePoint(); \
  if ($time%(ddr3_clkHPeriod) == 0) #1; \
  else repeat (2) #0; \
endtask \
task ddr3_reset(); \
  ddr3_rst = 1; \
  step(DDR3_RST_PERIOD); \
  ddr3_rst = 0; \
  step(1); \
endtask \
task ddr3_pause(); \
  #0; \
endtask
