

function state_out = train_module(timer,state_in)

%loads the labjack stuff
clf % Clears the figure window
clear global

% Load LabJack UD library and initialize LabJack constants
ljud_LoadDriver
ljud_Constants

% Open the first found LabJack U3
[Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error) % Check for and display any errors
 
% Set all pin assignments to the factory default condition
[Error] = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
Error_Message(Error)


    %here we're going to define which FIO we're using so we can adjust it
    %later
    SWITCH_PORT = 4;
    LED_RED_1 = 5;
    LED_RED_2 = 6;
    LED_RED_3 = 7;
    LED_RED_4 = 8;
    module_on = 0;%initializing switch variable

    while state_in == 1 || state_in == 2
        
        [Error button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,SWITCH_PORT,0,0); % Read switch
        Error_Message(Error)
    
        if (button == 0)  % Check if switch button was pressed
        pause(0.2) % Yes, so wait for button to be released
        module_on = 1;  %toggles state
        end
        tic
        if module_on == true
            timer_start = toc;
            timer_end = toc;
            while timer_end < (1/timer)*(30) + timer_start %keeps lights on until 30 seconds have passed by comparing tic times. timer variable lets us take in debug multipliers.
                if (timer_start - timer_end) < 1 && timer_start - timer_end > 2 %% makes the lights flash every other second
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_1, 1, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_2, 1, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_3, 1, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_4, 1, 0);
                elseif (timer_start - timer_end) >= 1 && timer_start - timer_end <= 2 %i need to get a division in there to make it odd / even
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_1, 0, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_2, 0, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_3, 0, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_4, 0, 0);
                end
                timer_end = toc;
                state_out = 3; %this outputs so the other modules know they are being interrupted
            end
            module_on = 0; %turns the switch off after 30 seconds
            state_out = 1; %resets the output state so the other modules resume
        end
        
        end
end
    

            










  

