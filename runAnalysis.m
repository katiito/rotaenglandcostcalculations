function [stats_averted, stats_total] = runAnalysis(Numberofsamples, Numberofagegroups, Numberofyears)


%% INITIALIZE
    for year = 1:Numberofyears
        totalcosts.Allcombined{year} = zeros(1,Numberofsamples);
        totalaverted.Allcombined{year} = zeros(1,Numberofsamples);
    end
%% FUNCTIONS

    samples = getSamples;
    
    
%% RUN FUNCTIONS

    averted = samples.samplesCasesAverted(Numberofsamples);
    costs = samples.samplesCosts(Numberofsamples);
    
    %% Calculate costs per year per age group per healthcare setting
    for year = 1:Numberofyears
        for agegroup = 1:Numberofagegroups
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
                totalcosts.Allcombined{year} = totalcosts.Allcombined{year} + totalcosts.All{year}{agegroup};
                
                % these don't work
                totalaverted.All{year}{agegroup} = averted.Hosp{year}{agegroup} + averted.GP{year}{agegroup} + averted.AE{year}{agegroup};
                totalaverted.Allcombined{year} = totalaverted.Allcombined{year} + totalaverted.All{year}{agegroup};
                
        end
    end
    
    %% Do any recombining here
    %% ?????
    %% ?????
    
    %% calculate the confidence intervals for these
    for year = 1:Numberofyears
        for agegroup = 1:Numberofagegroups
            for fld = fields(averted)';
                fld = fld{1};
                %totalcosts.(fld).mean = 
                sorted_total = sort(totalcosts.(fld){year}{agegroup});
                sorted_averted = sort(averted.(fld){year}{agegroup});
                stats_total.(fld).low{year}{agegroup} = sorted_total(floor(Numberofsamples*0.025));
                stats_total.(fld).high{year}{agegroup} = sorted_total(ceil(Numberofsamples*0.975));
                stats_total.(fld).median{year}{agegroup} = sorted_total(Numberofsamples*0.5);
                stats_total.(fld).mode{year}{agegroup} = mode(round(sorted_total));
                stats_total.(fld).mean{year}{agegroup} = mean(sorted_total);
                stats_averted.(fld).low{year}{agegroup} = sorted_averted(floor(Numberofsamples*0.025));
                stats_averted.(fld).high{year}{agegroup} = sorted_averted(ceil(Numberofsamples*0.975));
                stats_averted.(fld).median{year}{agegroup} = sorted_averted(Numberofsamples*0.5);
                stats_averted.(fld).mode{year}{agegroup} = mode(round(sorted_averted));
                stats_averted.(fld).mean{year}{agegroup} = mean(sorted_averted);
            end 
            sorted_totalcosts = sort(totalcosts.Allcombined{year});
            sorted_totalaverted = sort(totalaverted.Allcombined{year});
            
            stats_total.All.mean{year} = sorted_totalcosts(floor(Numberofsamples*0.025));
            stats_total.All.median{year} = sorted_totalcosts(ceil(Numberofsamples*0.975));
            stats_total.All.mode{year} = sorted_totalcosts(Numberofsamples*0.5);
            stats_total.All.low{year} = mode(round(sorted_totalcosts));
            stats_total.All.high{year} = mean(sorted_totalcosts);
            
            stats_averted.All.mean{year} = sorted_totalaverted(floor(Numberofsamples*0.025));
            stats_averted.All.median{year} = sorted_totalaverted(ceil(Numberofsamples*0.975));
            stats_averted.All.mode{year} = sorted_totalaverted(Numberofsamples*0.5);
            stats_averted.All.low{year} = mode(round(sorted_totalaverted));
            stats_averted.All.high{year} = mean(sorted_totalaverted);

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