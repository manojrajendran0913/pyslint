      module chk_count(
        input event clk_ev, 
        input bit a, b, c, 
        input int  max,
        output bit[31:0] count);
        bit x, y;  // static checker variables 
        bit[31:0] v=0;
  
        assign y = a && b; 
        assign x = a && v;  
        bit [31:0] dyn = 1; 
  
        ap_illegal_aa: assert property(
            @ (clk_ev) dyn[0]==0); 
      
        always_ff @ (clk_ev) begin : ff1
            automatic bit[31:0] v;  
            if(y && !c) v+=1'b1; 
            if(y && c)  v-=1'b1;
           count <= v; 
       end
            ap_count: assert property(@ (clk_ev) count < max);       
    endmodule : chk_count

    module tb_chk_count;

      bit a, b, c; 
      int max; 
      bit [31:0] count;
      event clk_ev; 
 
      chk_count uut (
        .clk_ev(clk_ev),
        .a(a),
        .b(b),
        .c(c),
        .max(max),
        .count(count));

      initial begin
           forever begin
            #5;
            ->clk_ev;
         end
      end
 
      initial begin
         #10;
         $finish;
          end

      endmodule