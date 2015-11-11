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
        Hospmode_dummy{2} = num2cell(ones(size(Hospmode_dummy{1},1), size(Hospmode_dummy{1},2)));
        
        Hospsd_dummy{1} = {0.065417723, 0.208731265, 0.173753163, 0.13261478, 0.099295009, 0.051650206, 0.032362849, 0.044206961, 0.059129581};
        Hospsd_dummy{2} = num2cell(zeros(size(Hospsd_dummy{1},1), size(Hospsd_dummy{1},2)));
        
        HospPersonYears{1} = {732000, 720620, 710233, 701269, 709087, 23000000, 14000000, 6400000, 9200000};
        HospPersonYears{2} = num2cell(zeros(size(HospPersonYears{1},1), size(HospPersonYears{1},2)));
      
        
        HospActualCases{1} = {15101, 10078, 4524, 2986, 2402, 11782, 70781, 71082, 134079};
        HospActualCases{2} = num2cell(zeros(size(HospActualCases{1},1), size(HospActualCases{1},2)));
        
%         avertedHosp_Estimate{1} = {5256, 4648, 1565, 710, 333, 1020, 6043, 9484, 21368}; %2013-14
%         avertedHosp_Low{1} = {5256, 4648, 1565, 710, 333, 1020, 6043, 9484, 21368}; %2013-14
%         avertedHosp_High{1} = {5256+0.1, 4648+0.1, 1565+0.1, 710+0.1, 333+0.1, 1020+0.1, 6043+0.1, 9484+0.1, 21368+0.1}; %2013-14
% 
% 
%         avertedHosp_Estimate{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15
%         avertedHosp_Low{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15
%         avertedHosp_High{2} = {0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1, 0+0.1}; %2014-15

        %% Calculate SD for visits averted assuming Normal distribution of uncertainty
        for i=1:size(Hospmode_dummy,2)
                
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
        ProportionInCPRD = 0.08;
        ProportionPopInEngland = 0.84;
        GPmode_dummy{1} = {-1.36137645, -1.738916945, -2.520525062, -2.996739092, -3.246836852, -4.028460663, -4.007384731, -3.993230143, -3.342896289};
        GPmode_dummy{2} = {-1.368797231, -1.755635651, -2.563747092, -3.04123573, -3.268440549, -4.055081803, -4.028559812, -4.002914847, -3.358629438};
        GPsd_dummy{1} = {0.056924495, 0.069679675, 0.050590595, 0.054111487, 0.053059953, 0.036012384, 0.027917069, 0.028615737, 0.028373334};
        GPsd_dummy{2} = {0.068639396, 0.083987727, 0.061055832, 0.065617601, 0.06478381, 0.043650061, 0.033735067, 0.034645132, 0.034260565};
        
        GPPersonYears{1} = {40877.76336, 46710.64767, 47559.52638, 48026.57646, 48004.21887, 454309.2848, 1507825.266, 1065563.95, 716828.9912};
        GPPersonYears{2} = {28212.43542, 31299.3811, 33047.99453, 33457.21563, 33806.98159, 319098.5529, 1031372.073, 739965.6088, 504331.9267};
        
        GPActualCases{1} = {8929.880879, 6447.596613, 3330.184625, 2113.478344, 1614.25273, 7473.587628, 26007.18197, 18104.13818, 23897.377};
        GPActualCases{2} = {6068.608639, 4275.095711, 2369.407343, 1469.733886, 1124.841659, 5074.648823, 17253.40137, 12001.54031, 16614.57836};
%         avertedGP_Estimate{1} = {1305, 1403, 389, 241, 156, 502, 65, 30, -620}; %2013-14
%         avertedGP_Estimate{2} = {755, 714, 28, 91, 69, 304, -611, -204, -1507}; %2014-15
%         avertedGP_High95{1} = {2708, 2607, 826, 524, 380, 1218, 1768, 1279, 877}; %2013-14
%         avertedGP_High95{2} = {1992, 1725, 400, 337, 270, 942, 823, 858, -251}; %2014-15
%         avertedGP_Low95{1} = {64, 356, -2, -11, -43, -154, -1535, -1142, -2026}; %2013-14
%         avertedGP_Low95{2} = {-302, -130, -294, -120, -102, -265, -1933, -1181, -2664}; %2014-15

        %% Calculate SD for visits averted assuming Normal distribution of uncertainty
        for i=1:size(GPmode_dummy,2)
                
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
            out.GP{i} = cellfun(@(personyears,d, actualcases, ppopn, PiD) ppopn .* (personyears .* exp(d) - actualcases)./PiD,...
                                    GPPersonYears{i},...
                                    GPdummySamples{i},...
                                    GPActualCases{i},...
                                    num2cell(repmat(ProportionPopInEngland,1,size(GPmode_dummy{1},2))),...
                                    num2cell(repmat(ProportionInCPRD,1,size(GPmode_dummy{1},2))),...
                                    'UniformOutput', false);                    
            
        end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% ED Visits averted %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% NEED TO GET ALEX ELLIOT'S FIGURES FOR THESE
        avertedAE_Estimate{1} = {4578.73,	0,0,0, 5658.22,	-516.81,	-2868.68,	0, 605.27}; %2013-14 <1, 1-4, 5-14, 15-64, 65+ cf <1, 1, 2, 3, 4, 5-14, 15-44, 45-64, 65+
        
        avertedAE_Estimate{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15
        avertedAE_SD{1} = {660.37,    0,    0,  0, 1398.37,	372.28,	743.59,   0, 484.29}; %2013-14
        avertedAE_SD{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15
%         avertedAE_High95{1} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2013-14
%         avertedAE_High95{2} = {0, 0, 0, 0, 0, 0, 0, 0, 0}; %2014-15

        %% Calculate SD for Cases averted assuming Normal distribution of uncertainty
%         for i=1:size(avertedAE_Estimate,2)
%             avertedAE_SD{i} = cellfun(@(a,b)(a-b)/1.96, ...
%                                     avertedAE_High95{i}, avertedAE_Estimate{i},...
%                                         'UniformOutput', false);
%         end
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
    
    costGPperconsultation_Estimate = 38;
    costGPperconsultation_Low = 23;
    costGPperconsultation_High = 56;
    
    costPrescription_Estimate = 2.30;
    costPrescription_Low = 1.38;
    costPrescription_High = 3.79;
    
    pdfGPcosts = makedist('Triangular','a',costGPperconsultation_Low + costPrescription_Low,...
                                       'b',costGPperconsultation_Estimate + costPrescription_Estimate,...
                                       'c',costGPperconsultation_High + costPrescription_High);
                                   
    %%%%%%%%%% Hospital Costs %%%%%%%%%%%%%%%%
    %%%% Triangle distribution
    costNonPaedHosp_Estimate = 433.96;
    costNonPaedHosp_Low = 335.72;
    costNonPaedHosp_High = 493.35;
    
    costPaedHosp_Estimate = 695.57;
    costPaedHosp_Low = 529.98;
    costPaedHosp_High = 787.72;
    
    
    pdfNonPaedHospcosts = makedist('Triangular','a',costNonPaedHosp_Low,...
                                       'b',costNonPaedHosp_Estimate,...
                                       'c',costNonPaedHosp_High);
    pdfPaedHospcosts = makedist('Triangular','a',costPaedHosp_Low,...
                                       'b',costPaedHosp_Estimate,...
                                       'c',costPaedHosp_High);
                                   
                                   
    %%%%%%%%%%% A&E Costs %%%%%%%%%%%%%%
    %%%% Uniform distribution
    costAE_Estimate = 123.71;
    costAE_Low = 100.30;
    costAE_High = 142.96;
    
    		
    
    pdfAEcosts = makedist('Uniform','lower',costAE_Low,...
                                    'upper',costAE_High);

    
    %% SAMPLE from all distributions
    rng('default')
    out.GP = random(pdfGPcosts, [1,NSamples]);
    out.HospNonPaed = random(pdfNonPaedHospcosts, [1,NSamples]);
    out.HospPaed = random(pdfPaedHospcosts, [1,NSamples]);
    out.AE = random(pdfAEcosts, [1,NSamples]);
    
end
