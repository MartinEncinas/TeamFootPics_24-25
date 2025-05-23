
    disp("Setting up please hold...");
    load("IQSWLoop_April9_15perTrail10.mat");

    serialportObj = serialport("COM4", 57600);
    pause(1);
    global inKey;
    inKey = 'C';
    maxVal = 1;
    step = 0;
    disp("Setup Complete!");
    %GUI scan initialization will not work unless we wait for serialport to setup
    vals = {'M 3.5 / W 5.0','M 4.0 / W 5.5', 'M 4.5 / W 6.0', 'M 5.0 / W 6.5', 'M 5.5 / W 7.0', 'M 6.0 / W 7.5', 'M 6.5 / W 8.0', ...
            'M 7.0 / W 8.5', 'M 7.5 / W 9.0', 'M 8.0 / W 9.5', 'M 8.5 / W 10.0', 'M 9.0 / W 10.5', 'M 9.5 / W 11.0', 'M 10.0 / W 11.5', ...
            'M 10.5 / W 12.0', 'M 11.0 / W 12.5', 'M 11.5 / W 13.0','M 12.0 / W 13.5', 'M 12.5 / W 14.0', 'M 13.0 / W 14.5','M 13.5 / W 15.0','M 14.0 / W 15.5'};
    keySet = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22'};
    keyVal = {'H', 'I', 'J', 'K', 'L', 'M' ,' N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '!', '@', '#'};
    map = containers.Map(keySet, keyVal);
    resultsGUI.fh = figure('MenuBar', 'none', ...
        'Name', 'Scan Image', ...
        'Resize', 'off', ...
        'Visible', 'off', ...
        'Position', [100 100 500 500]);
    SWEDisp.fh = figure('Resize','off', ...
                    'Visible', 'off', 'Position', [400 300 1000 300]);
   

   
   scanResults.fh = figure('MenuBar', 'none', ...
        'Name', 'Scan Results', ...
        'Resize', 'off', ...
        'Visible', 'off', ...
        'Position', [700 500 400 300]);
%Column 1

   scanResults.c1_1 = uicontrol('Style', 'text', ...
        'String','Scan Results', ...
        'Position', [0 250 100 25]);
   scanResults.c1_2 = uicontrol('Style', 'text', ...
        'String', 'Proximal', ...
        'Position', [0 200 100 25]);
   scanResults.c1_3 = uicontrol('Style', 'text', ...
        'String', 'Medial', ...
        'Position', [0 150 100 25]);
   scanResults.c1_4 = uicontrol('Style', 'text', ...
        'String', 'Distal', ...
        'Position', [0 100 100 25]);
   scanResults.c1_5 = uicontrol('Style', 'text', ...
        'String', 'Overall', ...
        'Position', [0 50 100 25]);

%column 2
 
   scanResults.c2_1 = uicontrol('Style', 'text', ...
        'String', '1st Vel', ...
        'Position', [75 225 50 25]);
   scanResults.c2_2 = uicontrol('Style', 'text', ...
        'String', '4th Vel', ...
        'Position', [75 175 50 25]);
   scanResults.c2_3 = uicontrol('Style', 'text', ...
        'String', '7th Vel', ...
        'Position', [75 125 50 25]);
   scanResults.c2_4 = uicontrol('Style', 'text', ...
        'String', 'Avg Vel', ...
        'Position', [75 75 50 25]);
%column 2 Data

   scanResults.c2_5 = uicontrol('Style', 'text', ...
        'String', '2.5', ...
        'Position', [75 200 50 25]);
   scanResults.c2_6 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [75 150 50 25]);
   scanResults.c2_7 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [75 100 50 25]);
   scanResults.c2_8 = uicontrol('Style', 'text', ...
        'String', '4.5', ...
        'Position', [75 50 50 25]);



%column 3

   scanResults.c3_1 = uicontrol('Style', 'text', ...
        'String', '2nd Vel', ...
        'Position', [125 225 50 25]);
   scanResults.c3_2 = uicontrol('Style', 'text', ...
        'String', '5th Vel', ...
        'Position', [125 175 50 25]);
   scanResults.c3_3 = uicontrol('Style', 'text', ...
        'String', '8th Vel', ...
        'Position', [125 125 50 25]);
   scanResults.c3_4 = uicontrol('Style', 'text', ...
        'String', 'Risk Level', ...
        'Position', [125 75 50 25]);
%column 3 data

   scanResults.c3_5 = uicontrol('Style', 'text', ...
        'String', '2.5', ...
        'Position', [125 200 50 25]);
   scanResults.c3_6 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [125 150 50 25]);
   scanResults.c3_7 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [125 100 50 25]);
   scanResults.c3_8 = uicontrol('Style', 'text', ...
        'String', 'High', ...
        'Position', [125 50 50 25]);


%Column 4

   scanResults.c4_1 = uicontrol('Style', 'text', ...
        'String', '3rd Vel', ...
        'Position', [175 225 50 25]);
   scanResults.c4_2 = uicontrol('Style', 'text', ...
        'String', '6th Vel', ...
        'Position', [175 175 50 25]);
   scanResults.c4_3 = uicontrol('Style', 'text', ...
        'String', '9th Vel', ...
        'Position', [175 125 50 25]);
%column 4 Data

   scanResults.c4_4 = uicontrol('Style', 'text', ...
        'String', '2.5', ...
        'Position', [175 200 50 25]);
   scanResults.c4_5 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [175 150 50 25]);
   scanResults.c4_6 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [175 100 50 25]);


%Column 5

   scanResults.c5_1 = uicontrol('Style', 'text', ...
        'String', 'Avg Vel', ...
        'Position', [225 225 50 25]);
   scanResults.c5_2 = uicontrol('Style', 'text', ...
        'String', 'Avg Vel', ...
        'Position', [225 175 50 25]);
   scanResults.c5_3 = uicontrol('Style', 'text', ...
        'String', 'Avg Vel', ...
        'Position', [225 125 50 25]);
%column 4 Data

   scanResults.c5_4 = uicontrol('Style', 'text', ...
        'String', '2.5', ...
        'Position', [225 200 50 25]);
   scanResults.c5_5 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [225 150 50 25]);
   scanResults.c5_6 = uicontrol('Style', 'text', ...
        'String', '3.5', ...
        'Position', [225 100 50 25]);



%Column 6
   scanResults.c6_1 = uicontrol('Style', 'text', ...
        'String', 'Risk Level', ...
        'Position', [275 225 50 25]);
   scanResults.c6_2 = uicontrol('Style', 'text', ...
        'String', 'Risk Level', ...
        'Position', [275 175 50 25]);
   scanResults.c6_3 = uicontrol('Style', 'text', ...
        'String', 'Risk Level', ...
        'Position', [275 125 50 25]);

%column 6 Data

   scanResults.c6_4 = uicontrol('Style', 'text', ...
        'String', 'High', ...
        'Position', [280 200 50 25]);
   scanResults.c6_5 = uicontrol('Style', 'text', ...
        'String', 'High', ...
        'Position', [280 150 50 25]);
   scanResults.c6_6 = uicontrol('Style', 'text', ...
        'String', 'High', ...
        'Position', [280 100 50 25]);
   

    resultsGUI.fh = figure('MenuBar', 'none', ...
        'Name', 'Scan Results', ...
        'Resize', 'off', ...
        'Visible', 'off', ...
        'Position', [500 500 200 200]);

    



    
    gui2.fh = figure('MenuBar','none', ...
        'Name', 'Weight Capture', ...
        'NumberTitle','off', ...
        'Resize','off', ...
        'Visible','off', ...
        'Position', [500 500 200 200]);
    gui2.t2 = uicontrol('Style', 'text', ...
        'String','Current Weight Distribution :', ...
        'Position', [50 130 100 25]);
    gui2.t1 = uicontrol('Style', 'text', ...
        'String', '', ...
        'Position', [50 100 100 25]);
    gui2.b1 = uicontrol('Style', 'push', ...
        'String','Initiate Scan', ...
        'Position', [50 50 100 25], ...
        'Callback', {@weightCont,  gui2.fh, serialportObj});  




    s.fh = figure('MenuBar','none', ...
        'Name', 'Automated Scanner Controller', ...
        'NumberTitle','off', ...
        'Resize','off', ...
        'Position', [500 500 200 200]);
    
    s.t2 = uicontrol('Style', 'text', ...
        'String','Select patient foot size :', ...
        'Position', [50 130 100 25]);

    s.t1 = uicontrol('Style', 'popupmenu', ...
        'String', vals, ...
        'Position', [50 100 100 25], ...
        'Callback', {@selection, map});

    
    s.b1 = uicontrol('Style', 'push', ...
        'String','Continue', ...
        'Position', [50 50 100 25], ...
        'Callback', {@sizeCont,  map, s.t1, s.fh, gui2.fh, serialportObj});  
    
    while(1)

        switch inKey
            case 'C'
                %currVal = 1;
                currVal = read(serialportObj,1,"uint8");
                if(currVal > maxVal)
                    maxVal = currVal;
                else
                    currRatio = (currVal/maxVal);
                end
                weightUpdate(gui2.t1, currRatio);
                drawnow;
            case 'G'
                %stall state
                pause(0.5);
                valuestuff = read(serialportObj,1, "uint8");
                disp(valuestuff);
                inKey = valuestuff;
                inKey = 'E';
            case 'D'
                for i = 1:47
                    %differences = sqrt(IQframes(:,:, i+1).^2 + IQframes(:,:, i).^2) ;
                    differences1 = ((((IQframes(:,:, i+2)))) - (((IQframes(:,:, i))))) ;
                    diffArray_step2(:,:,i) = log10((differences1)+1) ;
                end
                for i = 1:47
                    noiseArray2(:,:,i) = wdenoise(abs(diffArray_step2(:,:,i)), 7);
                end
                diffArray_step2 = medfilt3((noiseArray2));
                SWEDisp.fh.Visible = 'on';
                
                for idx = 2 : 15
                    imagesc(squeeze((diffArray_step2(:,:,idx))));
                    xlabel("mm");
                    ylabel("Depth");
                    
                    colormap("gray");
                    colorbar;
                    pause(.1);
                end
                SWEDisp.fh.Visible = 'off';
                step = step + 1;
                disp(step);
                inKey = 'G';
                writeline(serialportObj, 'G');
            case 'E'
                resultsGUI.fh.Visible = 'on';
                img = imread('Anatomy-of-the-plantar-aspect-of-the-foot-demonstrating-the-bands-of-the-plantar-fascia_Q640.jpg'); % Replace 'peacock.jpg' with your image
                imshow(img);
                h1 = drawcircle('Center',[215 390],'Radius',5,'Color', [0, 1 , 0],'InteractionsAllowed','none');
                h2 = drawcircle('Center',[215 375],'Radius',5,'Color',[.1,.9,0], 'InteractionsAllowed','none');
                h3 = drawcircle('Center',[215 360],'Radius',5,'Color',[.2,.8,0], 'InteractionsAllowed','none');
                h4 = drawcircle('Center',[215 345],'Radius',5,'Color',[.3,.7,0], 'InteractionsAllowed','none');
                h5 = drawcircle('Center',[215 330],'Radius',5,'Color', [.4, .6 , 0],'InteractionsAllowed','none');
                h6 = drawcircle('Center',[215 315],'Radius',5,'Color',[.5,.5,0], 'InteractionsAllowed','none');
                h7 = drawcircle('Center',[215 300],'Radius',5,'Color',[.6,.4,0], 'InteractionsAllowed','none');
                h8 = drawcircle('Center',[215 285],'Radius',5,'Color',[.7,.3,0], 'InteractionsAllowed','none');
                h9 = drawcircle('Center',[215 270],'Radius',5,'Color',[.8,.2,0], 'InteractionsAllowed','none');
                pause(.1);
                scanResults.fh.Visible = 'on';
                break;
        
        end
        pause(0.01);
    end

    function weightCont(source, event,  figure, SerialObj)
        global inKey; 
        inKey = 'D';

        figure.Visible = 'off';
        
    end







function sizeCont(source, event, map, field, figure, nextFig, SerialObj)
    
    disp(char(map(string(field.Value))));
    figure.Visible = 'off';
    writeline(SerialObj, (map(string(field.Value))));
    nextFig.Visible = 'on';

end




function selection(src,event, map)
        
    disp(['Selection: ' + char(map(string(src.Value)))]);
end

function weightUpdate(label, val)
    label.String = val;
end

