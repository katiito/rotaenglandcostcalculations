function [stats_averted, stats_total] = runAnalysis(Numberofsamples, Numberofagegroups, NumberofagegroupsToSum, Numberofyears)



%% FUNCTIONS

    samples = getSamples;
    
    
%% RUN FUNCTIONS

    averted = samples.samplesCasesAverted(Numberofsamples);
    costs = samples.samplesCosts(Numberofsamples);
    
%% INITIALIZE
for year = 1:Numberofyears
    totalcosts.Allagegroups{year} = zeros(1,Numberofsamples);
    totalcosts.HospAllagegroups{year} = zeros(1,Numberofsamples);
    totalcosts.GPAllagegroups{year} = zeros(1,Numberofsamples);
    totalcosts.AEAllagegroups{year} = zeros(1,Numberofsamples);

    averted.Allagegroups{year} = zeros(1,Numberofsamples);
    averted.HospAllagegroups{year} = zeros(1,Numberofsamples);
    averted.GPAllagegroups{year} = zeros(1,Numberofsamples);
    averted.AEAllagegroups{year} = zeros(1,Numberofsamples);
end
    
    %% Calculate costs per year per age group per healthcare setting
    for year = 1:Numberofyears
        for agegroup = 1:NumberofagegroupsToSum
                if agegroup < 7
                    hospcost = costs.HospPaed;
                else
                    hospcost = costs.HospNonPaed;
                end
                totalcosts.Hosp{year}{agegroup} = averted.Hosp{year}{agegroup}.* hospcost;
                totalcosts.GP{year}{agegroup} = averted.GP{year}{agegroup} .* costs.GP;
                totalcosts.AE{year}{agegroup} = averted.AE{year}{agegroup} .* costs.AE;
                %% add other outcomes here too....
                totalcosts.All{year}{agegroup} = totalcosts.Hosp{year}{agegroup} + totalcosts.GP{year}{agegroup} + totalcosts.AE{year}{agegroup};
                totalcosts.Allagegroups{year} = totalcosts.Allagegroups{year} + totalcosts.All{year}{agegroup};
                
                totalcosts.HospAllagegroups{year} =  totalcosts.HospAllagegroups{year} + totalcosts.Hosp{year}{agegroup};
                totalcosts.GPAllagegroups{year} =  totalcosts.GPAllagegroups{year} + totalcosts.GP{year}{agegroup};
                totalcosts.AEAllagegroups{year} =  totalcosts.AEAllagegroups{year} + totalcosts.AE{year}{agegroup};
                
                averted.All{year}{agegroup} = averted.Hosp{year}{agegroup} + averted.GP{year}{agegroup} + averted.AE{year}{agegroup};
                averted.Allagegroups{year} = averted.Allagegroups{year} + averted.All{year}{agegroup};
                
                averted.HospAllagegroups{year} =  averted.HospAllagegroups{year} + averted.Hosp{year}{agegroup};
                averted.GPAllagegroups{year} =  averted.GPAllagegroups{year} + averted.GP{year}{agegroup};
                averted.AEAllagegroups{year} =  averted.AEAllagegroups{year} + averted.AE{year}{agegroup};
                
                
%                 % these don't work
%                 totalaverted.All{year}{agegroup} = averted.Hosp{year}{agegroup} + averted.GP{year}{agegroup} + averted.AE{year}{agegroup};
%                 totalaverted.Allagegroups{year} = totalaverted.Allagegroups{year} + totalaverted.All{year}{agegroup};
                
        end
    end
    
    %% Do any recombining here
    %% ?????
    %% ?????
    
    %% calculate the confidence intervals for these
    
    relevantfields = {'AE','GP','Hosp'};
    for year = 1:Numberofyears
        for agegroup = 1:NumberofagegroupsToSum
            for fld = relevantfields;
                fld = fld{1};
                %totalcosts.(fld).mean = 
                sorted_total = sort(totalcosts.(fld){year}{agegroup});
                sorted_averted = sort(averted.(fld){year}{agegroup});
                stats_total.(fld).low{year}{agegroup} = sorted_total(floor(Numberofsamples*0.025));
                stats_total.(fld).high{year}{agegroup} = sorted_total(ceil(Numberofsamples*0.975));
                stats_total.(fld).median{year}{agegroup} = sorted_total(Numberofsamples*0.5);
                stats_total.(fld).mode{year}{agegroup} = mode(round(sorted_total, -1));
                stats_total.(fld).mean{year}{agegroup} = mean(sorted_total);
                stats_averted.(fld).low{year}{agegroup} = sorted_averted(floor(Numberofsamples*0.025));
                stats_averted.(fld).high{year}{agegroup} = sorted_averted(ceil(Numberofsamples*0.975));
                stats_averted.(fld).median{year}{agegroup} = sorted_averted(Numberofsamples*0.5);
                stats_averted.(fld).mode{year}{agegroup} = mode(round(sorted_averted, -1));
                stats_averted.(fld).mean{year}{agegroup} = mean(sorted_averted);
            end 
            sorted_totalcosts = sort(totalcosts.Allagegroups{year});
            sorted_totalcostsHosp = sort(totalcosts.HospAllagegroups{year});
            sorted_totalcostsGP = sort(totalcosts.GPAllagegroups{year});
            sorted_totalcostsAE = sort(totalcosts.AEAllagegroups{year});
            
            sorted_totalaverted = sort(averted.Allagegroups{year});
            sorted_totalavertedHosp = sort(averted.HospAllagegroups{year});
            sorted_totalavertedGP = sort(averted.GPAllagegroups{year});
            sorted_totalavertedAE = sort(averted.AEAllagegroups{year});
         
            stats_total.All.low{year} = sorted_totalcosts(floor(Numberofsamples*0.025));
            stats_total.All.high{year} = sorted_totalcosts(ceil(Numberofsamples*0.975));
            stats_total.All.median{year} = sorted_totalcosts(Numberofsamples*0.5);
            stats_total.All.mode{year} = mode(round(sorted_totalcosts, -1));
            stats_total.All.mean{year} = mean(sorted_totalcosts);
            
            stats_total.AllAE.low{year} = sorted_totalcostsAE(floor(Numberofsamples*0.025));
            stats_total.AllAE.high{year} = sorted_totalcostsAE(ceil(Numberofsamples*0.975));
            stats_total.AllAE.median{year} = sorted_totalcostsAE(Numberofsamples*0.5);
            stats_total.AllAE.mode{year} = mode(round(sorted_totalcostsAE, -1));
            stats_total.AllAE.mean{year} = mean(sorted_totalcostsAE);
            
            stats_total.AllGP.low{year} = sorted_totalcostsGP(floor(Numberofsamples*0.025));
            stats_total.AllGP.high{year} = sorted_totalcostsGP(ceil(Numberofsamples*0.975));
            stats_total.AllGP.median{year} = sorted_totalcostsGP(Numberofsamples*0.5);
            stats_total.AllGP.mode{year} = mode(round(sorted_totalcostsGP, -1));
            stats_total.AllGP.mean{year} = mean(sorted_totalcostsGP);
            
            stats_total.AllHosp.low{year} = sorted_totalcostsHosp(floor(Numberofsamples*0.025));
            stats_total.AllHosp.high{year} = sorted_totalcostsHosp(ceil(Numberofsamples*0.975));
            stats_total.AllHosp.median{year} = sorted_totalcostsHosp(Numberofsamples*0.5);
            stats_total.AllHosp.mode{year} = mode(round(sorted_totalcostsHosp, -1));
            stats_total.AllHosp.mean{year} = mean(sorted_totalcostsHosp);
            
            stats_averted.All.low{year} = sorted_totalaverted(floor(Numberofsamples*0.025));
            stats_averted.All.high{year} = sorted_totalaverted(ceil(Numberofsamples*0.975));
            stats_averted.All.median{year} = sorted_totalaverted(Numberofsamples*0.5);
            stats_averted.All.mode{year} = mode(round(sorted_totalaverted, -1));
            stats_averted.All.mean{year} = mean(sorted_totalaverted);

            stats_averted.AllAE.low{year} = sorted_totalavertedAE(floor(Numberofsamples*0.025));
            stats_averted.AllAE.high{year} = sorted_totalavertedAE(ceil(Numberofsamples*0.975));
            stats_averted.AllAE.median{year} = sorted_totalavertedAE(Numberofsamples*0.5);
            stats_averted.AllAE.mode{year} = mode(round(sorted_totalavertedAE, -1));
            stats_averted.AllAE.mean{year} = mean(sorted_totalavertedAE);


            stats_averted.AllGP.low{year} = sorted_totalavertedGP(floor(Numberofsamples*0.025));
            stats_averted.AllGP.high{year} = sorted_totalavertedGP(ceil(Numberofsamples*0.975));
            stats_averted.AllGP.median{year} = sorted_totalavertedGP(Numberofsamples*0.5);
            stats_averted.AllGP.mode{year} = mode(round(sorted_totalavertedGP, -1));
            stats_averted.AllGP.mean{year} = mean(sorted_totalavertedGP);
            
            stats_averted.AllHosp.low{year} = sorted_totalavertedHosp(floor(Numberofsamples*0.025));
            stats_averted.AllHosp.high{year} = sorted_totalavertedHosp(ceil(Numberofsamples*0.975));
            stats_averted.AllHosp.median{year} = sorted_totalavertedHosp(Numberofsamples*0.5);
            stats_averted.AllHosp.mode{year} = mode(round(sorted_totalavertedHosp, -1));
            stats_averted.AllHosp.mean{year} = mean(sorted_totalavertedHosp);

            
        end
        %% calculate CIs for total across all age groups, outcomes
%         sorted_total = sort(totalcosts.(fld){year}{agegroup});
%         sorted_averted = sort(averted.(fld){year}{agegroup});
%         stats_total.(fld).low{year}{agegroup} = sorted_total(floor(Numberofsamples*0.025));
%         stats_total.(fld).high{year}{agegroup} = sorted_total(ceil(Numberofsamples*0.975));
%         stats_total.(fld).median{year}{agegroup} = sorted_total(Numberofsamples*0.5);
%         stats_averted.(fld).low{year}{agegroup} = sorted_averted(floor(Numberofsamples*0.025));
%         stats_averted.(fld).high{year}{agegroup} = sorted_averted(ceil(Numberofsamples*0.975));
%         stats_averted.(fld).median{year}{agegroup} = sorted_averted(Numberofsamples*0.5);
    end
    
    
    
    
end