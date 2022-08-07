% Brain Machine Interfaces - Neural Decoder
% Date : 03/2022
% TEAM Prime_Mates
% Imperial College London 2022 

% USE MEAN TRAJECTORY FOR A GIVEN ANGEL

function modelParameters = trainMeanTrajectory(data, modelParameters)
% Calculate Mean X and Y pos across training trials for each angle
    meanXtrain = [];
    meanYtrain = [];
    for k = 1:modelParameters.numDir
        Xtrain = [];
        Ytrain = [];
        for i = 1:modelParameters.numTrials
            Xtrain(i, 1:length(data(i, k).handPos)) = data(i, k).handPos(1,:); 
            Ytrain(i, 1:length(data(i, k).handPos)) = data(i, k).handPos(2,:); 
        end

        allXtrain = Xtrain;
        allYtrain = Ytrain;

        for t = 1:length(Xtrain)
            meanXtrain(t) = mean(nonzeros(Xtrain(:, t)));
            meanYtrain(t) = mean(nonzeros(Ytrain(:,t)));
        end

        modelParameters.meanX{k} = meanXtrain;
        modelParameters.meanY{k} = meanYtrain;
        modelParameters.allXtrain{k} = Xtrain;
        modelParameters.allYtrain{k} = Ytrain;
    end  
end

