function [x, y, modelParameters] = positionEstimator(test_data, modelParameters)
    % (1) Calculate MSE between test and train vectors to check which of k=1:8 it is
    % function compareTestTrain(trainVects,testVects)
    testVect = zeros(98,1);
    for neuron = 1:98
        testVect(neuron,1) = sum(test_data.spikes(neuron,1:320));
    end

    % Compare to each training vector and find closest one
    MSE = zeros(1,8);
    for angle = 1:8
        MSE(1,angle) = mean((modelParameters.trainVects(:, angle) - testVect).^2);  % MSE between train and test vector
    end
    [~, k] = min(MSE);
    
    % (2) Kalman Filtering
    spikeLength = length(test_data.spikes);
    
    A = modelParameters.A{k};
    W = modelParameters.W{k};
    H = modelParameters.H{k};
    Q = modelParameters.Q{k};
    Z = modelParameters.Z;
    P = modelParameters.P;
    
    if (spikeLength==320)
        % Initialise Kalman Filter when new trial starts
        modelParameters.endTime = 1;
        estimate = zeros(6,1);
        temp_estimate = zeros(6,1);
        estimate(1:2,1) = test_data.startHandPos(1:2,:);
    else
        K = modelParameters.K;
        modelParameters.endTime = modelParameters.endTime + 1;
        estimate = modelParameters.estimate;
    end

    % (2.1) Discrete Kalman filter time update

    temp_estimate(:) =  A * estimate(:);
    if temp_estimate(1,1) == 0 && temp_estimate(2,1) == 0
        estimate(:) = estimate(:);
    else
        estimate(:) = temp_estimate(:);
    end
    P = (A * P * transpose(A)) + W;

    % (2.2) Using the prior estimate and firing rate update estimate
    
    % Gain Matrix
    K = P * transpose(H) * pinv(H * P * transpose(H) + Q);
    % Update estimate
    estimate(:) = estimate(:) + K*(Z(:,modelParameters.endTime) - H * estimate(:));
    % Compute error covariance matrix
    P = (eye(size(A,1)) - K * H) * P;

    
    x = estimate(1,1);
    y = estimate(2,1);
    
    modelParameters.P = P;
    modelParameters.K = K;
    modelParameters.estimate = estimate;
end