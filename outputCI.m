
function X = outputCI(arraysigma2,m)

      %% Log-normal
      %mu = @(mo, sigma2) log(mo) + sigma2;
      %arraymu = cell2mat(arrayfun(mu, repmat(m, 1, size(arraysigma2,2)), arraysigma2, 'UniformOutput', false));
%       lower = logninv(0.025, arraymu, arraysigma2);
%       upper = logninv(0.975, arraymu, arraysigma2);
%       
%       hold on;
%       plot(arraysigma2, lower)
%       plot(arraysigma2, upper)
%       plot([arraysigma2(1),arraysigma2(end)], [2876, 2876])
%       plot([arraysigma2(1),arraysigma2(end)], [8131, 8131])
%       
      
      %% Gamma
%       theta = @(mo, kay) mo / (kay-1);
%       arraytheta = cell2mat(arrayfun(theta, repmat(m, 1, size(arrayk,2)), arrayk, 'UniformOutput', false));
%       lower = logninv(0.025, arraytheta, arrayk);
%       upper = logninv(0.975, arraytheta, arrayk);
%       hold on;
%       plot(arrayk, lower)
%       plot(arrayk, upper)
%       plot([arrayk(1),arrayk(end)], [2876, 2876])
%       plot([arrayk(1),arrayk(end)], [8131, 8131])
      
    
      
      
      
%     r = @(pr, mo) (1-pr)*mo/pr;
%     NSamples = 100;
%     sample = @(p) nbinrnd(r(p,m), p, [1, NSamples]);
%     
%     samples = arrayfun(sample, arrayp, 'UniformOutput', false);
%     sorted = sort(cell2mat(samples'),2);
%     lower = sorted(:,floor(0.025*NSamples));
%     upper = sorted(:,ceil(0.975*NSamples));
%     o = sprintf('%g\t%g\n', lower, upper);
%     disp(o)
%     hold on;
%     plot(arrayp, lower)
%     plot(arrayp, upper)
%     % X = nbininv(0.025, r(p,m), p);
%     plot([arrayp(1),arrayp(end)], [23232, 23232])
%     plot([arrayp(1),arrayp(end)], [17977, 17977])
end