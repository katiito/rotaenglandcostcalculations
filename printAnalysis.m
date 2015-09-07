function printAnalysis(averted, totalcost, Numberofagegroups, Numberofyears)

    flds = fields(averted)';
    flds1 = flds(1:3); 
    flds2 = flds(5:end); %flds(1:(end-1));
    index = 1;
    for year = 1:Numberofyears
        
        for fld = flds1
            fld1 = fld{1};
            fld2 = flds2{index};
            o = sprintf('%s - %s', fld1, num2str(2012+year)); disp(o);
            for agegroup = 1:Numberofagegroups
                o = sprintf('%.0f\t(%.0f,%.0f)\t%.0f\t(%.0f,%.0f)',...
                    averted.(fld1).median{year}{agegroup},...
                        averted.(fld1).low{year}{agegroup},averted.(fld1).high{year}{agegroup},...
                    round(totalcost.(fld1).median{year}{agegroup}, -3),...
                        round(totalcost.(fld1).low{year}{agegroup}, -3),round(totalcost.(fld1).high{year}{agegroup}, -3) ); 
                disp(o)

            end
            oo = sprintf('%.0f\t(%.0f,%.0f)\t%.0f\t(%.0f,%.0f)',...
                    averted.(fld2).median{year},...
                    averted.(fld2).low{year},averted.(fld2).high{year},...
                    round(totalcost.(fld2).median{year}, -3),...
                    round(totalcost.(fld2).low{year}, -3),round(totalcost.(fld2).high{year}, -3) ); 
            disp(oo)    
            o = sprintf('\n'); disp(o)
            
            
            index = index +1;
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