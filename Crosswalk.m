% -------------------------------------------------------------------------
% ECE 102 Engineering Computation
% Crosswalk lighting system
%
% This program controls the crosswalk of an intersection.
%
%   CODE EDITED BY:
%   Derrick Genther 
%      
% -------------------------------------------------------------------------

clc
clear global

% Load LabJack UD library and initialize LabJack constants
ljud_LoadDriver
ljud_Constants
 
% Open the first found LabJack U3
[Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error)
 
% Set all pin assignments to the factory default condition
Error = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET,0,0,0);
Error_Message(Error)

function [buttonPressed] = Crosswalk(crosswalkState, timer);
    
    % Initialize pins and timers
    crossSwitchPin = 2;
    DoubleWhitePin = 5;
    DoubleRedPin = 6;
    SingleWhitePin = 3;
    SingleRedPin = 4;
    WhiteTime = 10*(1/timer);
    WhiteRedTime = 8*(1/timer);
    WhiteRedInterrupt = 5*(1/timer);
    RedTime = 18*(1/timer);
    trainTime = 30*(1/timer);
    timer_start = tic;
    timer_end = tic;
    

    while crosswalkState == 1|| crosswalkState == 2|| crosswalkState == 0
        [Error state]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,crossSwitchPin,0,0); % Read switch
        Error_Message(Error)

        %BUTTON PRESS
        if (state == 0)  % Check if switch button was pressed
            pause(0.1) % Yes, so wait for button to be released
            
            if crosswalkState == 2      %When Single cross is active
                buttonPressed = 2;
                tic;
                timer_start = toc;
                while timer_end < WhiteRedInterrupt + timer_start
                    timer_end = toc;
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 1, 0);%%%%%%%%%
                
                    if timer_start - timer_end >= 1 && timer_start - timer_end =< 2 %% flip flops based on difference of time so the light flashes
                     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 0, 0);
                    elseif timer_start - timer_end < 1 && timer_start - timer_end > 2
                     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 1, 0);
                    end                    
                end
            
                tic;
                timer_start = toc;
                while timer_end < RedTime + timer_start
                    timer_end = toc;
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleWhitePin, 0, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 1, 0);
                end
            elseif crosswalkState == 1  %When Double cross is active
                
            end
            buttonPressed = 0;
        end
        %END BUTTON PRESS

        if crosswalkState == 1                                                          %State 1 = Double cross active
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleRedPin, 1, 0);    %Turn off single crosswalk
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleWhitePin, 0, 0);
            
            tic;
            timer_start = toc;
            while timer_end < WhiteTime + timer_start
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleWhitePin, 1, 0);  %Turn on double crosswalk
                timer_end = toc;
            end
            
            tic;
            timer_start = toc;
            while timer_end < WhiteRedTime + timer_start
                timer_end = toc;
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 1, 0); %%%%%%%%%
                
                    if timer_start - timer_end >= 1 && timer_start - timer_end =< 2 %% flip flops based on difference of time so the light flashes
                     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 0, 0);
                    elseif timer_start - timer_end < 1 && timer_start - timer_end > 2
                     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 1, 0);
                    end                    
            end
            
            tic;
            timer_start = toc;
            while timer_end < RedTime + timer_start
                timer_end = toc;
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleWhitePin, 0, 0);
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 1, 0);
            end
                
        elseif crosswalkState == 2                                                      %State 2 = Single cross active
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleRedPin, 1, 0);    %Turn off double crosswalk
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleWhitePin, 0, 0);
            
            tic;
            timer_start = toc;
            while timer_end < WhiteTime + timer_start
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleWhitePin, 1, 0);  %Turn on single crosswalk
                timer_end = toc;
            end
            
            tic;
            timer_start = toc;
            while timer_end < WhiteRedTime + timer_start
                timer_end = toc;
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleRedPin, 1, 0);%%%%%%%%%%
                
                    if timer_start - timer_end >= 1 && timer_start - timer_end =< 2 %% flip flops based on difference of time so the light flashes
                     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleRedPin, 0, 0);
                    elseif timer_start - timer_end < 1 && timer_start - timer_end > 2
                     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleRedPin, 1, 0);
                    end                    
            end
            
            tic;
            timer_start = toc;
            while timer_end < RedTime + timer_start
                timer_end = toc;
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleWhitePin, 0, 0);
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleRedPin, 1, 0);
            end

        elseif crosswalkState == 3                                                      %State 3 = both cross red
            tic;                                                                        %TRAIN INTERRUPT
            timer_start = toc;
            timer_end = toc;
            while timer_end < trainTime + timer_start
                timer_end = toc;
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, DoubleWhitePin, 0, 0);  %Turn off double crosswalk
                Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, SingleWhitePin, 0, 0);  %Turn off single crosswalk
            end
            crosswalkState = 2;
        end
    end
end