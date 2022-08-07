% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022 

% SVM training 

function modelParameters = trainSVM(training_data, modelParameters)

    % (1) Average neuron spikes across time

    allAngle = {};
    for k = 1:modelParameters.numDir
        allTrial = [];
        for i = 1:modelParameters.numTrials
            timeAve = [];
            for n = 1:modelParameters.numNeurons
                timeAve = [timeAve; sum(training_data(i, k).spikes(n,1:320))];
            end
            allTrial = [allTrial, timeAve];
        end
        allAngle{k} = allTrial; % all neurons averaged across time for that direction, each column is a trial
    end
    
    % (2) Reformat Data to build SVM model

    Xtrain = [allAngle{1}';allAngle{2}';allAngle{3}';allAngle{4}';allAngle{5}';allAngle{6}';allAngle{7}';allAngle{8}']; % each column is a neuron, each row is a trial
    Ytrain(1:70,1) = 1; % angle = 1
    Ytrain(71:140,1) = 2; % angle = 2
    Ytrain(141:210,1) = 3; % angle = 3
    Ytrain(211:280,1) = 4; % angle = 4
    Ytrain(281:350,1) = 5; % angle = 5
    Ytrain(351:420,1) = 6; % angle = 6
    Ytrain(421:490,1) = 7; % angle = 7
    Ytrain(491:560,1) = 8; % angle = 8

    Mdl = fitcecoc(Xtrain,Ytrain); % SVM model

    modelParameters.svmModel = Mdl;
end