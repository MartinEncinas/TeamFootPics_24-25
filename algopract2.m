clear;
totalSum = 0;
totVel = 0;
totalCount = 0;
for q =  10:60
    
    %load("IQSWLoop40V_April9_7_5perTrail" + q + ".mat");
    %load("IQSWLoop50V_April9_7_5perTrail" + q + ".mat");
    load("IQSWLoopV50_April9_30perTrail" + q + ".mat");
    %load("IQSWLoop_April9_15perTrail" + q + ".mat");
    %load("IQSWLoop_April9_30perTrail" + q + ".mat");
    %load("IQSWLoop_March27Trial" + q + ".mat");
    %load("IQSWLoop_March27_7_5per" + q + ".mat");
    %load("IQSWLoop_March27_15per" + q + ".mat");
    
    for i = 1:49
        %differences = sqrt(IQframes(:,:, i+1).^2 + IQframes(:,:, i).^2) ;
        differences = ((((IQframes(:,:, i+1)))) - (((IQframes(:,:, i))))) ;
        diffArray(:,:,i) = log((differences)) ;
    end
    for i = 1:49
        noiseArray(:,:,i) = wdenoise(abs(diffArray(:,:,i)), 7);
    end
    diffArray2 = medfilt3((noiseArray));
    %Can run this only if prompted
    f = figure;
        disp("Trail " + q);
        currVel = 0;
        sumModulus = 0;
        modFound = 0;
        prevInd = 10000;
        prevVel = 0;
        prevIdx = 0;
        maxYoung = 0;
        for idx = 2 : 15
            
            imagesc(squeeze((diffArray2(:,:,idx))));
            colormap("gray");
            colorbar;
            
            pause(0.05);
            S = mean((diffArray(:, 1:80, idx)) , 1);
            R = mean((diffArray2(:,80:160, idx)), 1);

            
            
            
            %disp((max(S)));
            %disp(idx);
            %disp(max(S(:, 1:80)) / 1.926e4  );
            %disp((max(S) / 1.926e4)^2  * 1.150);
            %youngMod = (3.45*(((max(S)) / 1.926e4)^2));
            %plot(S(:,1:80));

            
            indValL = find(S(:,1:80)==max(S(:,1:80)));
            %disp(indVal);
            if idx == 2
                prevInd = indValL;
                prevIdx = idx;
            elseif indValL < prevInd
                
                %disp(prevInd - indValL);
                %currVel = ((prevInd - indVal)*(1540/(SW.Trans.frequency  * 10^6))) * 1e4 ;
                currVel = ((prevInd - indValL)*(1540/(7.24  * 10^6 ))) * 1e4 / (idx - prevIdx) ;
                %if prevVel == 0
                %    prevVel = currVel;
                %    disp(3.45 * currVel^2);
                %else
                if currVel < prevVel && currVel <= 10 && currVel >= 0
                    disp("-------");
                    disp("velocity : " + currVel);
                    disp("YM : " + 3.45*(currVel)^2);
                    sumModulus = sumModulus + (3.45*(currVel)^2);
                    modFound = modFound + 1;
                    totVel = totVel + currVel;
                    totalSum = totalSum + (3.45*(currVel)^2);
                    totalCount = totalCount + 1;
                    prevVel = currVel;
                    
                end
                prevVel = currVel;
                prevIdx = idx;
                prevInd = indValL;
            end
            


            %disp(youngMod);
            %if ((max(S)) / 1e4) > 1 && ((max(S)) / 1e4) < 10
            %    maxYoung = max(maxYoung, youngMod);
            %    totalSum = totalSum + youngMod;
            %    totalCount = totalCount + 1;
            %end
            %keyboard;
            %mov(midx) = getframe(gcf);
            %midx = midx+1;
            %pause;
        end
    
    %disp(maxYoung);
    
    
    if modFound >= 1
        disp("----------------");
        
        disp("Average Modulus : " + (sumModulus / modFound)); 
        
        
    end
    
    
    %heldSum = heldSum + maxYoung;
    %disp(sqrt(heldSum / index) );
    %disp(heldSum / 13);
    close;
    disp("-----------------------------");
    disp("Current Average Modulus over all data : " + (totalSum / totalCount)); 
    disp("Average Velocity over all data: " + (totVel / totalCount));
    %disp("Current Average Modulus over all data : " + (totalSum / totalCount)); 
end

