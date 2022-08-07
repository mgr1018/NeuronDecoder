% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% AVERAGE DATA OVER TRIALS: 98*1000

function modelParameters = dataAv(data, modelParameters)
   % Average neuron spikes across trials for each angle and smooth with
   % Gaussian Filter
    for k = 1:modelParameters.numDir
        trainVects = zeros(modelParameters.numNeurons, 1000);
        for n = modelParameters.numNeurons
            oneNeuron = zeros(modelParameters.numTrials, 1000);
            for i = 1:modelParameters.numTrials
                    filtered = gaussianFilter(data(i,k).spikes(n,:));
                    % filtered = filtered(1:10:end);
                    oneNeuron(i, 1:length(filtered)) = filtered;
            end
            trainVects(n,:) = mean(oneNeuron);
        end
        modelParameters.trainVects{k} = trainVects;
    end
    
end