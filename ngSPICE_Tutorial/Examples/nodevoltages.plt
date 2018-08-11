set terminal X11 noenhanced
set title "schmitt trigget simulation"
set xlabel "s"
set ylabel "V"
set grid
unset logscale x 
set xrange [1.000239e-02:1.500000e-02]
unset logscale y 
set yrange [-1.099963e+01:1.099998e+01]
#set xtics 1
#set x2tics 1
#set ytics 1
#set y2tics 1
set format y "%g"
set format x "%g"
plot 'nodevoltages.data' using 1:2 with lines lw 1 title "v(input)",\
'nodevoltages.data' using 3:4 with lines lw 1 title "v(output)",\
'nodevoltages.data' using 5:6 with lines lw 1 title "v(x1.fb)"
set terminal push
set terminal postscript eps color noenhanced
set out 'nodevoltages.eps'
replot
set term pop
replot
