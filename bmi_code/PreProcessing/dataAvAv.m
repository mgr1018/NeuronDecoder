% Brain Machine Interfaces - Neural Decoder
% Date : 03/2022
% TEAM Prime_Mates
% Imperial College London 2022 

% AVERAGE DATA OVER TIME AND TRIALS: 98*1

function modelParameters = dataAvAv(data, modelParameters)
   % Average neuron spikes across time and trials for each angle
    
    for k = 1:modelParameters.numDir
        trainVects = zeros(modelParameters.numNeurons, 1);
        allTrial = [];
        for i = 1:modelParameters.numTrials
            timeAve = [];
            for n = 1:modelParameters.numNeurons
                timeAve = [timeAve; sum(data(i, k).spikes(n,1:320))];
            end
            allTrial = [allTrial, timeAve];
        end
        trainVects(:, 1)= mean(allTrial, 2); % 98x1 vector, each neuron averaged across time and trials
        
        modelParameters.trainVects{k} = trainVects;
    end
end