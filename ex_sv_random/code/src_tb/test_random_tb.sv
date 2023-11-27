/******************************************************************************
Project Math_computer

File : test_random_tb.sv
Description : This module is meant to test some random constructs.
              Currently it is far from being efficient nor useful.

Author : Y. Thoma
Team   : REDS institute

Date   : 07.11.2022

| Modifications |--------------------------------------------------------------
Ver    Date         Who    Description
1.0    07.11.2022   YTA    First version

******************************************************************************/

/******************************************************************************

Réponses aux questions
1.  -
2.  -
3.  Comment se passe la simulation ?
    Elle se termine jamais. on arrive pas a atteindre 100%
4.  Afficher le taux de couverture afin de voir ce que vous pouvez atteindre, Qu'observez vous?
    on dépasse pas 94% de couverture
5.  -
6.  Combien d'itérations sont cécessaires pour atteindre 98% de couverture?
    346 itérations sont nécéssaires pour atteindre 98% de couverture
7.  -
8.  Combien d'itérations sont cécessaires pour atteindre 98% de couverture?
    22422 itérations sont nécéssaires pour atteindre 98% de couverture avec la cross couverture
9.  -
10. -
11. 694763 itérations sont nécessaires avec la couverture croisée et les bins définis
12. -
13. Oui il c'est possible mais ça prend très longtemps.

******************************************************************************/

module test_random_tb;

    logic clk = 0;

    // clocking block
    default clocking cb @(posedge clk);
    endclocking

    /*class STest;
        rand bit[7:0] sa;
        rand bit[7:0] sb;

        //  Si sa pair, alor sb pair
        constraint parity{
            sa[0] == 0 -> sb[0] == 0;
        }

        task stest_display();
            $display("Stest.sa : %b\n", sa);
            $display("Stest.sb : %b\n", sb);
        endtask
    endclass*/

    class RTest;
        //STest stest_array[3];
        rand bit[15:0] a;
        rand bit[15:0] b;
        rand bit[15:0] c;
        rand bit[1:0] m;

        //  M doit être entre 0 et 2 compris
        constraint m_value {
            m inside {[0:2]};
        }

        //  
        constraint ab_value {
             (m == 0) -> a < 10;
             (m == 1) -> b inside {[12:16]};
        }
        constraint c_value{
            c > (a + b);
        }

        covergroup cov_group;
            //cov_a: coverpoint a;
            
            option.at_least = 100;

            cov_a: coverpoint a{
                bins petites =    {[0:5000]};
                bins moyennes =   {[20000:50000]};
                bins grandes =    {[64000:65535]};
            }
            
            //cov_b: coverpoint b;
            
            cov_b: coverpoint b{
                bins petites =    {[0:10000]};
                bins moyennes =   {[20000:50000]};
                bins grandes =    {[64000:65535]};
            }
            
            //cov_c: coverpoint c;
            
            cov_c: coverpoint c{
                bins petites =    {[0:10000]};
                bins moyennes =   {[20000:50000]};
                bins grandes =    {[64000:65535]};
            }
            
            //cov_m: coverpoint m;
            cov_cross: cross cov_a, cov_b;
        endgroup
        
        function new;
            cov_group = new;
        endfunction : new

    endclass
    
    //STest stest[3];
    logic[15:0] a;
    logic[15:0] b;
    logic[15:0] c;
    logic[1:0]  m;
    
    int i = 0; 

    // clock generation
    always #5 clk = ~clk;

    task test_case0();
        static RTest rtest = new;

        a = 0;
        b = 0;
        c = 0;
        m = 0;

        ##1;

        // EX2
        while (rtest.cov_group.get_coverage() < 98) begin
            i++;

            // Randomize the object
            void'(rtest.randomize());
            // Apply its values to the signals (for nice view in the chronogram)
            ##1;
            rtest.cov_group.sample();
            a = rtest.a;
            b = rtest.b;
            c = rtest.c;
            m = rtest.m;

            //$display("|-----------------------------------------------------------------------------------------|\n");
            //$display("|     a : %6d     |       b : %6d     |       c : %6d     |       m : %6d     |\n", a, b, c, m);
            $display("[in loop] Coverage of cg_inst : %d\n", rtest.cov_group.get_coverage());
            $display("[in loop] Iterations : %d\n", i);
        end
        
        $display("[End of sim]  Coverage of cg_inst : %d\n", rtest.cov_group.get_coverage());
        $display("[End of sim]  Iterations : %d\n", i);
    endtask

    // Program launched at simulation start
    program TestSuite;
        initial begin
            test_case0();
            $stop;
        end

    endprogram

endmodule
