%means is the mean spike rate of all the neurons corresponding to the
%preferred direction.

function [neurs, means] = tunningCurves(angle)
    load('monkeydata_training.mat');
    
    neurs = [];
    means = [];
    prefDir = zeros(98,2);

    for i = 1:98
        avFR = zeros(100,8);
        for k = 1:8
            for n = 1:100
                avFR(n,k) = sum(trial(n,k).spikes(i,1:320));
            end
        end
    
        S = std(avFR);
        M = mean(avFR);
        
        [~, prefDir(i,1)] = max(M);
         if ((prefDir(i,1)) == angle)
             neurs = [neurs, i];
             means = [means, max(M)];
         end
    
%         subplot(10,10,i)
%         errorbar(M,S,'LineWidth',2)
%         ylim([0 25])
%         xlim([1 8])
    end
end
