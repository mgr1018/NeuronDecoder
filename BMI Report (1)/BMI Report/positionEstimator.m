% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% POSITION ESTIMATOR FUNCTION

function [x, y, mP] = positionEstimator(test_data, mP)

    % ---------------------- PreProcessing ---------------------------------
    if (mP.badNeurons)
        
        [test_data, mP] = badNeurons(test_data, mP);
    end

    spikeLength = size(test_data.spikes,2);

    % ---------------------- Classifiers -----------------------------------
    if (spikeLength == 320)
        if(mP.mse)
            mP = mse(test_data, mP);
        elseif(mP.mae)
            mP = mae(test_data, mP);
        elseif(mP.kNN)
            mP = kNN(test_data,mP);
        elseif(mP.svm)
            mP = svm(test_data,mP);
        end
    end

    % ---------------------- Trajectory ------------------------------------
    if (mP.mean)
        [x, y] = meanTrajectory(test_data,mP);
    elseif(mP.nearest)
        [x, y] = nearestTrajectory(test_data,mP);
    elseif(mP.kalman)
        [x, y, mP] = kalman(test_data,mP);
    elseif(mP.linear)
        [x, y] = linearfilter(test_data,mP);
    end

end