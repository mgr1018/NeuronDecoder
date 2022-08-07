
function modelParameters = linearfilterTrain(trainingData, modelParameters)

%     load('monkeydata_training.mat');
%     % Set random number generator
%     rng(2013);
%     ix = randperm(length(trial));
%     
%     % Select training and testing data (you can choose to split your data in a different way if you wish)
%     trainingData = trial(ix(1:50),:);
%     testData = trial(ix(51:end),:);
    
    % training model

        % Initializing vectors
        xx = zeros(1000,size(trainingData,1));
        yy = zeros(1000,size(trainingData,1));
        coeffsx = zeros (1000,2,8); %time, coeffs,angle
        coeffsy = zeros (1000,2,8); %time, coeffs,angle
        spk_train = zeros(1000,size(trainingData,1),8);
        maxneurons = zeros(1,8);
    
        for angle = 1:8

            %selecting the one neuron which induces the more spikes for a specific angle 
            %the spikes from this neuron will be used to find the linear
            %model
            [neurons,means] = tunningCurves(angle);
            maxneuron = neurons(find(means == max(means)));  
            maxneurons(angle) = maxneuron;

            for trialNum = 1:size(trainingData,1)

                        spk_train(1:length(trainingData(trialNum, angle).spikes(maxneuron,:)),trialNum,angle) = trainingData(trialNum, angle).spikes(maxneuron,:);
                        spk_train(:,trialNum,angle) = smoothdata(spk_train(:,trialNum,angle)); % rate of spiking over time for each trial and angle
                        xx(1:length(trainingData(trialNum, angle).handPos(1,:)),trialNum) = trainingData(trialNum, angle).handPos(1,:);
                        yy(1:length(trainingData(trialNum, angle).handPos(2,:)),trialNum) = trainingData(trialNum, angle).handPos(2,:);
            end
            
                for t = 1:length(trainingData(trialNum, angle).spikes)

                        % creating linear models for each time t and angle
                        mdlx = fitlm(squeeze(spk_train(t,:,angle)),xx(t,:),'linear');%linear model of x vs rate at time t
                        mdly = fitlm(squeeze(spk_train(t,:,angle)),yy(t,:),'linear');%linear model of y vs rate at time t

                        coeffsx(t,1,angle) = table2array(mdlx.Coefficients(1,1));%first coeff of linear model of x
                        coeffsx(t,2,angle) = table2array(mdlx.Coefficients(2,1));%second coeff of linear model of x
                        coeffsy(t,1,angle) = table2array(mdly.Coefficients(1,1));%first coeff of linear model of y
                        coeffsy(t,2,angle) = table2array(mdly.Coefficients(2,1));%second coeff of linear model of y
    
                end
    
        end
        modelParameters.cx = coeffsx;
        modelParameters.cy = coeffsy;
        modelParameters.maxneurons = maxneurons;
    
end



% %% Plotting Estimations
% meanSqError = 0;
% n_predictions=0;
% figure
% for angle = 1:8
% 
%     %find the neuron with max spikes for a specific angle. The spikes for
%     %this specific neuron are used to decode mvmt
%      [neurons,means] = tunningCurves(angle);
%      mxn = neurons(find(means == max(means))); 
% 
%     for tri=1:size(testData,1)
% 
%         %setting time-scale. If we plot over the whole length of the spike
%         %data, the model is bad at predicting movement at the end. If we
%         %limit the prediction to 600 ms or so, the model is better
%       
%         if length(testData(tri, angle).handPos(1,:))>600
%             t = 1:600;
%         else
%              t = 1:length(testData(tri, angle).handPos(1,:));
%         end
%         
%         %decode positions x and y for each trial
%         dec_x = smoothdata(coeffsx(t,1,angle)' + coeffsx(t,2,angle)'.* testData(tri,angle).spikes(mxn,t));
%         dec_y =  smoothdata(coeffsy(t,1,angle)' + coeffsy(t,2,angle)'.* testData(tri,angle).spikes(mxn,t));
%         decodedPos = [dec_x;dec_y]';
% 
%         plot(testData(tri, angle).handPos(1,:),testData(tri, angle).handPos(2,:),'b');hold on %plot real trajectories
%         plot(dec_x ,dec_y,'r'); %plot estimates
% 
%         %calculate MSE
%         datapos = testData(tri,angle).handPos(1:2,t);
%         meanSqError = meanSqError + norm(datapos' - decodedPos)^2;
%         n_predictions = n_predictions+length(testData(tri,angle).handPos(1,:));
% 
%     end
% end
% legend('real positions','decoded positions')
% xlabel('x')
% ylabel('y')
% 
% RMSE = sqrt(meanSqError/n_predictions)


    
