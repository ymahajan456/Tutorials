set terminal X11 noenhanced
set title "schmitt trigget simulation"
set xlabel "V"
set ylabel "V"
set grid
unset logscale x 
set xrange [-9.999649e+00:9.999996e+00]
unset logscale y 
set yrange [-7.051623e+00:7.051569e+00]
#set xtics 1
#set x2tics 1
#set ytics 1
#set y2tics 1
set format y "%g"
set format x "%g"
plot 'hysteresis.data' using 1:2 with lines lw 1 title "v(output)"
set terminal push
set terminal postscript eps color noenhanced
set out 'hysteresis.eps'
replot
set term pop
replot
