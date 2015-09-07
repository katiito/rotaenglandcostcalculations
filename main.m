function main()

Numberofsamples = 100000;
Numberofagegroups = 9;
Numberofyears = 2;

[averted, totalcost] = runAnalysis(Numberofsamples, Numberofagegroups, Numberofyears);
printAnalysis(averted, totalcost, Numberofagegroups, Numberofyears)

end