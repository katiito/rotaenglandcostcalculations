function main()

Numberofsamples = 5e6;
Numberofagegroups = 9;
NumberofagegroupsToSum = 5;
Numberofyears = 1;

[averted, totalcost] = runAnalysis(Numberofsamples, Numberofagegroups, NumberofagegroupsToSum, Numberofyears);
printAnalysis(averted, totalcost, Numberofagegroups, NumberofagegroupsToSum, Numberofyears)

end