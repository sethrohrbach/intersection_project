function state_out = train_module(timer,state_in,ljHandle)
ljud_LoadDriver
ljud_Constants




    %here we're going to define which FIO we're using so we can adjust it
    %later
    SWITCH_PORT = 2;
    LED_RED_1_EW_TRAFFIC = 7;
    LED_RED_2_NS_TRAFFIC = 6;
    LED_RED_3_EW_PEDX = 3;
    LED_RED_4_NS_PEDX = 4;
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
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_1_EW_TRAFFIC, 1, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_2_NS_TRAFFIC, 1, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_3_EW_PEDX, 1, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_4_NS_PEDX, 1, 0);
                elseif (timer_start - timer_end) >= 1 && timer_start - timer_end <= 2 %i need to get a division in there to make it odd / even
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_1_EW_TRAFFIC, 0, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_2_NS_TRAFFIC, 0, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_3_EW_PEDX, 0, 0);
                    Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, LED_RED_4_NS_PEDX, 0, 0);
                end
                timer_end = toc;
                state_out = 3; %this outputs so the other modules know they are being interrupted
            end
            module_on = 0; %turns the switch off after 30 seconds
            state_out = 1; %resets the output state so the other modules resume
        end
        
        end
    end
    

            






























