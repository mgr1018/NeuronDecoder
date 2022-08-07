% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022 

% kNN training 

function modelParameters = trainKNN(training_data, modelParameters)
    % kNN Approach
    trainTrials = zeros(modelParameters.numTrials,modelParameters.numNeurons);
    trainAngles = zeros(modelParameters.numTrials,1);
    j = 0;
    for k = 1:modelParameters.numDir
        for i = 1:modelParameters.numTrials
            timeAve = zeros(modelParameters.numNeurons,1);
            for n = 1:modelParameters.numNeurons
                timeAve(n,1) = sum(training_data(i, k).spikes(n,1:320)); % average first 320 timesteps
            end
            j = j+1;
            trainTrials(j,:) = timeAve; % Get numTrials x 98 array 
            trainAngles(j,1) = k; % Get numTrials x 1 array of which of 1-8 directions it is
        end
    end
    kNNModel = fitcknn(trainTrials,trainAngles,'NumNeighbors',28,'Standardize',1);
    modelParameters.kNNModel = kNNModel;
    
end