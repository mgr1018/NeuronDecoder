function [modelParameters] = positionEstimatorTraining(training_data) 
    % (1) Average neuron spikes across time and trials for each angle
    trainVects = [];
    for angle = 1:8
        allTrial = [];
        for trialNum = 1:length(training_data)
            timeAve = [];
            for neuron = 1:98
                timeAve = [timeAve; sum(training_data(trialNum, angle).spikes(neuron,1:320))];
            end
            allTrial = [allTrial, timeAve];
        end
        trainVects(:, angle)= mean(allTrial, 2); % 98x1 vector, each neuron averaged across time and trials
    end
    
    % (2) Kalman Filtering - with previous angle selection.
    l = length(training_data);
    time = 30;

    for k = 1:8
        
        X = zeros(6,time);
        
        for t=1:time
           for n = 1:l
               if length(training_data(n,k).handPos) < (t*20)+320
                   X(1,t) = X(1,t) + training_data(n,k).handPos(1,end);
                   X(2,t) = X(2,t) + training_data(n,k).handPos(2,end);
               else
                   X(1,t) = X(1,t) + training_data(n,k).handPos(1,(t*20)+320);
                   X(2,t) = X(2,t) + training_data(n,k).handPos(2,(t*20)+320);
               end
           end
           X(1,t) = X(1,t)/l;
           X(2,t) = X(2,t)/l;
           if t > 1
               X(3,t) = (X(1,t) - X(1,t-1))/20;
               X(4,t) = (X(2,t) - X(2,t-1))/20;
               X(5,t) = (X(3,t) - X(3,t-1))/20;
               X(6,t) = (X(4,t) - X(4,t-1))/20;
           end
        end
  


        Z = zeros(98,time);

        for t = 1:time
           for i = 1:98
               for n = 1:l
                   if length(training_data(n,k).spikes) < (t*20)+320
                   Z(i,t) = Z(i,t) + sum(training_data(n,k).spikes(i,(t*20)+280:end));
                   else
                   Z(i,t) = Z(i,t) + sum(training_data(n,k).spikes(i,(t*20)+280:(t*20)+300));
                   end
               end
               Z(i,t) = Z(i,t)/l;
           end
        end




        A = X(:,2:time)*transpose(X(:,1:time-1))/(X(:,1:time-1)*transpose(X(:,1:time-1)));
        H = Z(:,:)*transpose(X(:,:))/(X(:,:)*transpose(X(:,:)));
        W = (X(:,2:time)-A*X(:,1:time-1))*transpose(X(:,2:time)-A*X(:,1:time-1))/(time-1);
        Q = (Z(:,:)-H*X(:,:))*transpose(Z(:,:)-H*X(:,:))/time;

        % (3) Save as output parameter struct
        modelParameters.trainVects = trainVects;
        modelParameters.A{k} = A;
        modelParameters.H{k} = H;
        modelParameters.W{k} = W;
        modelParameters.Q{k} = Q;
        modelParameters.Z    = Z;
        modelParameters.P    = 1;
        
    end
end
