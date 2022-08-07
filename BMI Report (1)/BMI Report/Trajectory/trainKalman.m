% Brain Machine Interfaces - Neural Decoder
% Date : 03/2022
% TEAM Prime_Mates
% Imperial College London 2022 

% KALAMN FILTER 

function modelParameters = trainKalman(training_data, modelParameters)
%  Kalman Filtering - with previous angle selection.
    l = length(training_data);

    time = 11;

    for k = 1:8
        
        X = zeros(4,time);
        
        for t=1:time
           for i = 1:l
               if length(training_data(i,k).handPos) < (t*20)+320
                   X(1,t) = X(1,t) + training_data(i,k).handPos(1,end);
                   X(2,t) = X(2,t) + training_data(i,k).handPos(2,end);
               else
                   X(1,t) = X(1,t) + training_data(i,k).handPos(1,(t*20)+320);
                   X(2,t) = X(2,t) + training_data(i,k).handPos(2,(t*20)+320);
               end
           end
           X(1,t) = X(1,t)/(l);
           X(2,t) = X(2,t)/(l);
           if t > 1
               X(3,t) = (X(1,t) - X(1,t-1))/20;
               X(4,t) = (X(2,t) - X(2,t-1))/20;
               % X(5,t) = (X(3,t) - X(3,t-1))/20;
               % X(6,t) = (X(4,t) - X(4,t-1))/20;
           end
        end
  


        Z = zeros(modelParameters.numNeurons,time); 

        for t = 1:time
           for n = 1:modelParameters.numNeurons

               Z(n,t) = sum(modelParameters.trainVects{k}(n,((t+2)*20)+280:((t+2)*20)+300));
               %for i = 1:l
                   %if length(training_data(i,k).spikes) < (t*20)+320
                   %Z(n,t) = Z(n,t) + sum(training_data(i,k).spikes(n,(end - 20):end));
                   %else
                   %Z(n,t) = Z(n,t) + sum(training_data(i,k).spikes(n,(t*20)+280:(t*20)+300));
                   %end
               %end
               %Z(n,t) = Z(n,t)/l;
           end
        end




        A = X(:,2:time)*transpose(X(:,1:time-1))/(X(:,1:time-1)*transpose(X(:,1:time-1)));
        H = Z(:,:)*transpose(X(:,:))/(X(:,:)*transpose(X(:,:)));
        W = (X(:,2:time)-A*X(:,1:time-1))*transpose(X(:,2:time)-A*X(:,1:time-1))/(time-1);
        Q = (Z(:,:)-H*X(:,:))*transpose(Z(:,:)-H*X(:,:))/time;

        % Save as output parameter struct
        modelParameters.A{k} = A;
        modelParameters.H{k} = H;
        modelParameters.W{k} = W;
        modelParameters.Q{k} = Q;
        modelParameters.P    = 1;
        
    end
end