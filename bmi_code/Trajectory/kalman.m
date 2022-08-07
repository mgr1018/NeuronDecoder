% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% KALMAN

function [x, y, modelParameters] = kalman(test_data, modelParameters)

    if (modelParameters.dataAv)
        testVect = gaussianFilter(test_data.spikes(:,:));
    end

    % Kalman Filtering
    spikeLength = length(test_data.spikes);
    
    A = modelParameters.A{modelParameters.K};
    W = modelParameters.W{modelParameters.K};
    H = modelParameters.H{modelParameters.K};
    Q = modelParameters.Q{modelParameters.K};
    P = modelParameters.P;
    
    if (spikeLength==320)
        % Initialise Kalman Filter when new trial starts
        estimate = zeros(4,1);
        
        estimate(1:2,1) = test_data.startHandPos(1:2,:);
    else
        estimate = modelParameters.estimate;
    end

    % Discrete Kalman filter time update
    estimate(:) =  A * estimate(:);

    P = (A * P * transpose(A)) + W;

    % Using the prior estimate and firing rate update estimate
    
    % Gain Matrix
    K = P * transpose(H) * pinv(H * P * transpose(H) + Q);
    % Update estimate
    estimate(:) = estimate(:) + K*(sum(testVect(:,(end-60):(end-40)),2) - H * estimate(:));
    % Compute error covariance matrix
    P = (eye(size(A,1)) - K * H) * P;

    
    x = estimate(1,1);
    y = estimate(2,1);

    modelParameters.P = P;
    modelParameters.estimate = estimate;
end