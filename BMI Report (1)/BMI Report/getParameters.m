% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% MENU TO SELECT CLASSIFIERS AND TRAJECTORY DECODERS

function modelParameters = getParameters

    modelParameters.P = 1;
    % ---------------------- PreProcessing -----------------------------------
    modelParameters.badNeurons = false;
    modelParameters.dataAvAv = false;
    modelParameters.dataAv = true;
    % ---------------------- Classifiers -----------------------------------
    % Comparison to mean trajectory - MSE and MAE
    modelParameters.mse = false; % requires dataAvAv or dataAv
    modelParameters.mae = false; % requires dataAvAv or dataAv
    % Support Vector Machines - SVM
    modelParameters.svm = true;
    % k-Nearest-Neighbour - kNN
    modelParameters.kNN = false;
    % ---------------------- Trajectory ------------------------------------
    % Mean Trajectory
    modelParameters.mean = false;
    % Nearest trial x/y initial position
    modelParameters.nearest = false;
    % Kalman Filter
    modelParameters.kalman = false; % requires dataAv
    % Linear Filter
    modelParameters.linear = true; % requires dataAv

end