function data = getSamples()

    data.samplesCasesAverted = @readinIncidenceData;
    data.samplesCosts = @readinCostData;
    
end


function out = readinIncidenceData(NSamples)
    
    %Columns are age groups: <1, 1, 2, 3, 4, 5-14, 15-44, 45-64, 65+
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% HOSPITALIZATIONS averted %%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        %% Atchison et al, JID Paper
        Hospmode_dummy{1} = {-3.579902535, -3.869265664, -4.741527781, -5.248349692, -5.559676618, -7.493257598, -5.203838701, -4.372385758, -4.077705502};
        Hospsd_dummy{1} = {0.065417723, 0.208731265, 0.173753163, 0.13261478, 0.099295009, 0.051650206, 0.032362849, 0.044206961, 0.059129581};
        HospPersonYears{1} = {732000, 720620, 710233, 701269, 709087, 23000000, 14000000, 6400000, 9200000};
        HospActualCases{1} = {15101, 10078, 4524, 2986, 2402, 11782, 70781, 71082, 134079};
      
%         avertedHosp_Estimate{1} = {5256, 4648, 1565, 710, 333, 1020, 6043, 9484, 21368}; %2013-14
%         avertedHosp_Low{1} = {5256, 4648, 1565, 710, 333, 1020, 6043, 9484, 21368}; %2013-14
%         avertedHosp_High{1} = {5256+0.1, 4648+0.1, 1565+0.1, 710+0.1, 333+0.1, 1020+0.1, 6043+0.1, 9484+0.1, 21368+0.1}; %2013-14
% 
% 
%         avertedHosp_Estimate{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15
%         avertedHosp_Low{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15
%         avertedHosp_High{2} = {0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1}; %2014-15

        %% Calculate SD for visits averted assuming Normal distribution of uncertainty
        for i=1:size(mode_dummy,2)
                
            pdfHospdummyPred{i} = cellfun(@(a,b) makedist('Normal','mu',a','sigma',b'),...
                                    Hospmode_dummy{i},...
                                    Hospsd_dummy{i},...
                                    'UniformOutput', false);
            % get normal dummy samples
            HospdummySamples{i} = cellfun(@(p,nsamples) random(p, [1,nsamples]),...
                                    pdfHospdummyPred{i},...
                                    num2cell(repmat(NSamples, 1, size(pdfHospdummyPred{i},2))),...
                                    'UniformOutput', false);
            % get cases averted by untransform(inc) - actual
            out.Hosp{i} = cellfun(@(personyears,d, actualcases) personyears .* exp(d) - actualcases,...
                                    HospPersonYears{i},...
                                    HospdummySamples{i},...
                                    HospActualCases{i},...
                                    'UniformOutput', false);                    
            
        end       
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% GP Visits averted %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% Jemma's results for use in same paper
        GPmode_dummy{1} = {-1.327974276, -1.75620359, -2.557815775, -3.033931301, -3.32319408, -4.047622661, -4.042491393, -4.023419131, -3.4347886};
        GPmode_dummy{2} = {-1.362105525, -1.813579345, -2.633020591, -3.095544009, -3.3720819, -4.088338634, -4.108035729, -4.096495415, -3.532044806};
        GPsd_dummy{1} = {0.06210594, 0.070968325, 0.057192449, 0.058836123, 0.062214465, 0.044075084, 0.031813401, 0.032373513, 0.032038487};
        GPsd_dummy{2} = {0.0806655, 0.092229045, 0.074267385, 0.076768209, 0.081377906, 0.057427597, 0.041410565, 0.042204177, 0.041702273};
        
        GPPersonYears{1} = {40877.76336, 46710.64767, 47559.52638, 48026.57646, 48004.21887, 454309.2848, 1507825.266, 1065563.95, 716828.9912};
        GPPersonYears{2} = {28212.43542, 31299.3811, 33047.99453, 33457.21563, 33806.98159, 319098.5529, 1031372.073, 739965.6088, 504331.9267};
        
        GPActualCases{1} = {9527.676933, 6663.812162, 3295.473194, 2070.196338, 1574.13043, 7431.834031, 26403.12224, 19034.59197, 23724.97803};
        GPActualCases{2} = {6471.005666, 4389.884747, 2347.174126, 1422.586374, 1091.191849, 5045.919824, 17566.77231, 12509.96441, 16255.91132};
%         avertedGP_Estimate{1} = {1305, 1403, 389, 241, 156, 502, 65, 30, -620}; %2013-14
%         avertedGP_Estimate{2} = {755, 714, 28, 91, 69, 304, -611, -204, -1507}; %2014-15
%         avertedGP_High95{1} = {2708, 2607, 826, 524, 380, 1218, 1768, 1279, 877}; %2013-14
%         avertedGP_High95{2} = {1992, 1725, 400, 337, 270, 942, 823, 858, -251}; %2014-15
%         avertedGP_Low95{1} = {64, 356, -2, -11, -43, -154, -1535, -1142, -2026}; %2013-14
%         avertedGP_Low95{2} = {-302, -130, -294, -120, -102, -265, -1933, -1181, -2664}; %2014-15

        %% Calculate SD for visits averted assuming Normal distribution of uncertainty
        for i=1:size(mode_dummy,2)
                
            pdfGPdummyPred{i} = cellfun(@(a,b) makedist('Normal','mu',a','sigma',b'),...
                                    GPmode_dummy{i},...
                                    GPsd_dummy{i},...
                                    'UniformOutput', false);
            % get normal dummy samples
            GPdummySamples{i} = cellfun(@(p,nsamples) random(p, [1,nsamples]),...
                                    pdfGPdummyPred{i},...
                                    num2cell(repmat(NSamples, 1, size(pdfGPdummyPred{i},2))),...
                                    'UniformOutput', false);
            % get cases averted by untransform(inc) - actual
            out.GP{i} = cellfun(@(personyears,d, actualcases) personyears .* exp(d) - actualcases,...
                                    GPPersonYears{i},...
                                    GPdummySamples{i},...
                                    GPActualCases{i},...
                                    'UniformOutput', false);                    
            
        end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% ED Visits averted %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% NEED TO GET ALEX ELLIOT'S FIGURES FOR THESE
        avertedAE_Estimate{1} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2013-14
        avertedAE_Estimate{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15
        avertedAE_High95{1} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2013-14
        avertedAE_High95{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15

        %% Calculate SD for Cases averted assuming Normal distribution of uncertainty
        for i=1:size(avertedAE_Estimate,2)
            avertedAE_SD{i} = cellfun(@(a,b)(a-b)/1.96, ...
                                    avertedAE_High95{i}, avertedAE_Estimate{i},...
                                        'UniformOutput', false);
        end
        for i=1:size(avertedAE_Estimate,2)
            pdfAEAverted{i} = cellfun(@(a,b) makedist('Normal','mu',a','sigma',b'),...
                                    avertedAE_Estimate{i},...
                                    avertedAE_SD{i},...
                                    'UniformOutput', false);
            out.AE{i} = cellfun(@(p,nsamples) random(p, [1,nsamples]),...
                                    pdfAEAverted{i},...
                                    num2cell(repmat(NSamples, 1, size(pdfAEAverted{i},2))),...
                                    'UniformOutput', false);
        end
    
    
    
   
    
    
end

function out = readinCostData(NSamples)

    %%%%%%%%%%%%%%% ALL COSTS %%%%%%%%%%%%%
    
    % 1) Updated to 2014 costs
    % 2) 

    %%%%%%%%%%%% GP COSTS %%%%%%%%%%%%%%%%%
    %%%%TRIANGLE distribution
    
    costGPperconsultation_Estimate = 46;
    costGPperconsultation_Low = 28;
    costGPperconsultation_High = 67;
    
    costPrescription_Estimate = 2.30;
    costPrescription_Low = 1.38;
    costPrescription_High = 3.79;
    
    pdfGPcosts = makedist('Triangular','a',costGPperconsultation_Low + costPrescription_Low,...
                                       'b',costGPperconsultation_Estimate + costPrescription_Estimate,...
                                       'c',costGPperconsultation_High + costPrescription_High);
                                   
    %%%%%%%%%% Hospital Costs %%%%%%%%%%%%%%%%
    %%%% Triangle distribution
    costNonPaedHosp_Estimate = 1181.24;
    costNonPaedHosp_Low = 896.50;
    costNonPaedHosp_High = 1343.44;
    
    costPaedHosp_Estimate = 921.47;
    costPaedHosp_Low = 622.27;
    costPaedHosp_High = 1078.81;
    
    
    pdfNonPaedHospcosts = makedist('Triangular','a',costNonPaedHosp_Low,...
                                       'b',costNonPaedHosp_Estimate,...
                                       'c',costNonPaedHosp_High);
    pdfPaedHospcosts = makedist('Triangular','a',costPaedHosp_Low,...
                                       'b',costPaedHosp_Estimate,...
                                       'c',costPaedHosp_High);
                                   
                                   
    %%%%%%%%%%% A&E Costs %%%%%%%%%%%%%%
    %%%% Uniform distribution
    costAE_Estimate = 116.54;
    costAE_Low = 104.88;
    costAE_High = 128.19;
    
    pdfAEcosts = makedist('Uniform','lower',costAE_Low,...
                                    'upper',costAE_High);

    
    %% SAMPLE from all distributions
    rng('default')
    out.GP = random(pdfGPcosts, [1,NSamples]);
    out.HospNonPaed = random(pdfNonPaedHospcosts, [1,NSamples]);
    out.HospPaed = random(pdfPaedHospcosts, [1,NSamples]);
    out.AE = random(pdfAEcosts, [1,NSamples]);
    
end
