% Brain Machine Interfaces - Neural Decoder
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% POSITION ESTIMATOR TRAINING FUNCTION


function [modelParameters] = positionEstimatorTraining(training_data)

tic;

% Parameters
modelParameters = getParameters;
modelParameters.numTrials = size(training_data,1);
modelParameters.numDir = 8;
modelParameters.numNeurons = 98;

% ---------------------- PreProcessing ---------------------------------
if (modelParameters.badNeurons)
    fprintf('\n \nAverage neuron spikes across time and trials for each angle')
    [training_data, modelParameters] = badNeurons(training_data, modelParameters);
end

if (modelParameters.dataAvAv)
    fprintf('\n \nAverage neuron spikes across time and trials for each angle')
    modelParameters = dataAvAv(training_data, modelParameters);
end

if (modelParameters.dataAv)
    fprintf('\n \nAverage neuron spikes across trials for each angle and smooth')
    modelParameters = dataAv(training_data, modelParameters);
end
% ---------------------- Classifiers -----------------------------------
if (modelParameters.svm)
    modelParameters = trainSVM(training_data, modelParameters);
end

if(modelParameters.kNN)
   modelParameters = trainKNN(training_data, modelParameters);
end
% ---------------------- Trajectory ------------------------------------
if (modelParameters.mean)
    fprintf('\n \nTrajectory: Mean Trajectory \n\n')
    modelParameters = trainMeanTrajectory(training_data,modelParameters);
end

if (modelParameters.nearest)
    fprintf('\n \nTrajectory: Nearest Trajectory to Iinitial Position \n\n')
    modelParameters = trainMeanTrajectory(training_data,modelParameters);
end

if (modelParameters.kalman)
   modelParameters = trainKalman(training_data, modelParameters); 
end
if (modelParameters.linear)
   modelParameters = linearfilterTrain(training_data, modelParameters); 
end

disp("Total time of training:");

toc;


end