function printAnalysis(averted, totalcost, Numberofagegroups, Numberofyears)

    flds = fields(averted)';
    flds = flds(1:(end-1));
    
    for year = 1:Numberofyears
        
        for fld = flds
            fld = fld{1};
            o = sprintf('%s - %s', fld, num2str(2012+year)); disp(o);
            for agegroup = 1:Numberofagegroups
                o = sprintf('%.0f\t(%.0f,%.0f)\t%.0f\t(%.0f,%.0f)',...
                    averted.(fld).median{year}{agegroup},...
                    averted.(fld).low{year}{agegroup},averted.(fld).high{year}{agegroup},...
                    round(totalcost.(fld).median{year}{agegroup}, -3),...
                    round(totalcost.(fld).low{year}{agegroup}, -3),round(totalcost.(fld).high{year}{agegroup}, -3) ); 
                disp(o)

            end
            oo = sprintf('%.0f\t(%.0f,%.0f)\t%.0f\t(%.0f,%.0f)',...
                    averted.All.median{year},...
                    averted.All.low{year},averted.All.high{year},...
                    round(totalcost.All.median{year}, -3),...
                    round(totalcost.All.low{year}, -3),round(totalcost.All.high{year}, -3) ); 
            disp(oo)    
            o = sprintf('\n'); disp(o)
       end
    end
end