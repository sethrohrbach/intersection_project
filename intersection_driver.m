%loads the labjack stuff
clear global
clc
% Load LabJack UD library and initialize LabJack constants
ljud_LoadDriver
ljud_Constants
% Open the first found LabJack U3
[Error, ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error) % Check for and display any errors
% Set all pin assignments to the factory default condition
[Error] = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
Error_Message(Error)
%Channels used:
% East-West:   Traffic Lights: Red: FI07 (Bit 7)
%                              Yellow: FI05 (Bit 5)
%                              Green: FI01 (Bit 1)
%              Crosswalks:     Red: EI07 (Bit 14)
%                              White: EI14 (Bit 13)
% North-South: Traffic Lights: Red: FI06 (Bit 6)
%                              Yellow: FI04 (Bit 4)
%                              Green: FI00 (Bit 0)
%              Crosswalks:     Red: EI04 (Bit 12)
%                              White: EI13 (Bit 11)
% Crosswalk Switch:            FI02 (Bit 2)
% Train Switch:                FI03 (Bit 3)
%We make them global so we can adjust if needed.
global NS_T_R
NS_T_R = 6;
global NS_T_Y
NS_T_Y = 4;
global NS_T_G
NS_T_G = 0;
global NS_C_R
NS_C_R = 12;
global NS_C_W
NS_C_W = 11;

global EW_T_R
EW_T_R = 7;
global EW_T_Y
EW_T_Y = 5;
global EW_T_G
EW_T_G = 1;
global EW_C_R
EW_C_R = 14;
global EW_C_W
EW_C_W = 13;

global TRAIN_SW
TRAIN_SW = 2;
global CW_SW
CW_SW = 3;


%turning all the lights off just in case one is on at the start...
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 0, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 1, 0, 0);
%2 & 3 = switch ports
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 3, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 4, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 5, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 6, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 7, 0, 0);
%expansions 
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 11, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 12, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 13, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 14, 0, 0);



exit = 1; %to end the loop
speed = 1; %initializing speed variable


while exit == 1 %runs till an option is selected
    
    debug_state = debug_menu;   
    
    if debug_state == 9
        exit = 0;
        state_mode = 0; %all modules off
    elseif debug_state == 1
        exit = 0;
        state_mode = 1; %all modules on
    elseif debug_state == 2
        exit = 0;
        state_mode = 2; %just crosswalk module
    elseif debug_state == 3
        exit = 0;
        state_mode = 3; %just traffic light module on
    elseif debug_state == 4
        exit = 0;
        state_mode = 4; %just train module on
    elseif debug_state == 5
        exit = 0;
        speed = 2;
    elseif debug_state == 6
        exit = 0;
        speed = 4;
    elseif debug_state == 7
        exit = 0;
        speed = 10;
    end
end

green_time = 15*(1/speed); %we can set our delays here
yellow_time = 5*(1/speed);
red_time = 20*(1/speed); %used for crosswalk interrupts
interrupt_delay = 8*(1/speed); %how long the yellow lights go on if a button is pushed
train_time = 30*(1/speed);

train_interrupt = 0;
cw_interrupt = 0; %initializing buttons

%core driver loop for the lights
while state_mode == 1
%             %train & crosswalk buttons here - for reference here only.
%             they had to get embedded in the timers.
%             [Error train_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,TRAIN_SW,0,0); % Read switch
%             Error_Message(Error)
%             [Error cw_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,CW_SW,0,0); % Read switch
%             Error_Message(Error)
%     
%             if (train_button == 0)  % Check if switch button was pressed
%             train_interrupt = 1 %tells script to interrupt for train
%             disp('Train Incoming!')
%             timer_end = timer_end + 100;%will send it back to the start of the loop
%             elseif (cw_button == 0)  % Check if switch button was pressed
%             cw_interrupt = 1;  %toggles state
%             disp('Pedestrian Crossing Requested')
%             end
       
       
        
        
        
      
    while train_interrupt == 1
        tic
        timer_start = toc;
        timer_end = toc;
        while timer_end < timer_start + interrupt_delay
            train2_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
        while timer_end < timer_start + (interrupt_delay + train_time) && timer_end > timer_start + interrupt_delay
            train2(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
        train_interrupt = 0; %ends the train interrupt, returns to main loop
    end
    
    while cw_interrupt == 1
        tic
        timer_start = toc;
        timer_end = toc;
        while timer_end < timer_start + interrupt_delay
            ew_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
        while timer_end < timer_start + red_time && timer_end > timer_start + interrupt_delay
            ns_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
        cw_interrupt = 0; %ends the crosswalk interrupt, returns to main loop
    end
    

        
    
    
    tic
    timer_start = toc;
    timer_end = toc;
    
    %Starting with East-West traffic & pedx
    
    while timer_end < timer_start + green_time
        ew_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
            %train & crosswalk buttons here
            [Error train_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,TRAIN_SW,0,0); % Read switch
            Error_Message(Error)
            [Error cw_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,CW_SW,0,0); % Read switch
            Error_Message(Error)
    
            if (train_button == 0)  % Check if switch button was pressed
            train_interrupt = 1; %tells script to interrupt for train
            disp('Train Incoming!')
            timer_end = timer_end + 100;%will send it back to the start of the loop
            elseif (cw_button == 0)  % Check if switch button was pressed
            cw_interrupt = 1;  %toggles state
            disp('Pedestrian Crossing Requested')
            timer_end = timer_end + 100;%will send it back to the start of the loop
            end

        end
    
    while timer_end < timer_start + (green_time + yellow_time) && timer_end > timer_start + green_time
        ew_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
            [Error train_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,TRAIN_SW,0,0); % Read switch
            Error_Message(Error)
            if (train_button == 0)  % Check if switch button was pressed
            train_interrupt = 1; %tells script to interrupt for train
            disp('Train Incoming!')
            timer_end = timer_end + 100;%will send it back to the start of the loop
            end
    end
   
    %North-South part here        
    while timer_end < timer_start + (2*green_time + yellow_time) && timer_end > timer_start + (green_time + yellow_time)
        ns_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
            %train button here
            [Error train_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,TRAIN_SW,0,0); % Read switch
            Error_Message(Error)
            if (train_button == 0)  % Check if switch button was pressed
                train_interrupt = 1; %tells script to interrupt for train
                disp('Train Incoming!')
                timer_end = timer_end + 100;%will send it back to the start of the loop
            end
        

    end
    
    while timer_end < timer_start + (2*green_time + 2*yellow_time) && timer_end > timer_start +(2*green_time + yellow_time)
        ns_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
        %train button here
            [Error train_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,TRAIN_SW,0,0); % Read switch
            Error_Message(Error)
            if (train_button == 0)  % Check if switch button was pressed
                train_interrupt = 1; %tells script to interrupt for train
                disp('Train Incoming!')
                timer_end = timer_end + 100;%will send it back to the start of the loop
            end
    end         
end

while state_mode == 2 %crosswalks       
    
    while cw_interrupt == 1
        tic
        timer_start = toc;
        timer_end = toc;
        while timer_end < timer_start + interrupt_delay
            ew_cw_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
        while timer_end < timer_start + red_time && timer_end > timer_start + interrupt_delay
            ns_cw_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
        cw_interrupt = 0; %ends the crosswalk interrupt, returns to main loop
    end
    
    tic
    timer_start = toc;
    timer_end = toc;
    %Starting with East-West pedx
    
    while timer_end < timer_start + green_time
        ew_cw_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
            %crosswalk button here
            [Error cw_button]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,CW_SW,0,0); % Read switch
            Error_Message(Error)
            if (cw_button == 0)  % Check if switch button was pressed
            cw_interrupt = 1;  %toggles state
            disp('Pedestrian Crossing Requested')
            timer_end = timer_end + 100;%will send it back to the start of the loop
            end
        end
    
    while timer_end < timer_start + (green_time + yellow_time) && timer_end > timer_start + green_time
        ew_cw_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
    end
   
    %North-South part here        
    while timer_end < timer_start + (2*green_time + yellow_time) && timer_end > timer_start + (green_time + yellow_time)
        ns_cw_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
    end
    
    while timer_end < timer_start + (2*green_time + 2*yellow_time) && timer_end > timer_start +(2*green_time + yellow_time)
        ns_cw_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
    end         
end
    
while state_mode == 3 %traffic lights      
    tic
    timer_start = toc;
    timer_end = toc;
    %Starting with East-West traffic
    while timer_end < timer_start + green_time
        ew_t_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
        end
    
    while timer_end < timer_start + (green_time + yellow_time) && timer_end > timer_start + green_time
        ew_t_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
    end
   
    %North-South part here        
    while timer_end < timer_start + (2*green_time + yellow_time) && timer_end > timer_start + (green_time + yellow_time)
        ns_t_green(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
    end
    
    while timer_end < timer_start + (2*green_time + 2*yellow_time) && timer_end > timer_start +(2*green_time + yellow_time)
        ns_t_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
        timer_end = toc;
    end         
end

while state_mode == 4 %train choo choo
        tic
        timer_start = toc;
        timer_end = toc;
        while timer_end < timer_start + interrupt_delay
            train2_yellow(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
        while timer_end < timer_start + (interrupt_delay + train_time) && timer_end > timer_start + interrupt_delay
            train2(1,ljHandle,LJ_ioPUT_DIGITAL_BIT)
            timer_end = toc;
        end
end











    % DEPRECATED - Original code if you want to look at or grade it or
    % whatever. No functionality here.
%    state_mode = 1; %idk why this is here i dont think i need it?
%    mod_state = state_mode;
%    
%     while state_mode ~= 0 % calls on the modules as per state input.
%         if state_mode == 1
%             train_state = train_module(speed,mod_state,ljHandle);
%             crosswalk_state = Crosswalk(speed,mod_state,ljHandle);
%             if train_state == 3 %these checks are for if crosswalk or train modules are running, lets the other modes know they are being interrupted
%                 mod_state = train_state;
%                 train_state = train_module(speed,mod_state,ljHandle);
%                 Crosswalk(speed,mod_state,ljHandle)
%                 trafficlights(speed,mod_state,ljHandle)
%             elseif crosswalk_state == 3
%                 mod_state = crosswalk_state;
%                 crosswalk_state = Crosswalk(speed,mod_state,ljHandle);
%                 train_module(speed,mod_state,ljHandle)
%                 trafficlights(speed,mod_state,ljHandle)
%             end
%         elseif state_mode == 2
%             Crosswalk(speed,mod_state,ljHandle)
%         elseif state_mode == 3
%             trafficlights(speed,mod_state,ljHandle)
%         elseif state_mode == 4
%             train_module(speed,mod_state,ljHandle); %we're not saving the output state for debug mode - dont need to tell other modules to interrupt
%         end
%     end
% 









    

function debug_state = debug_menu()%calls a menu with modes and speeds
    debug_state = menu('Select a runmode or speed:','Run','Crosswalk Module','Traffic Light Module','Train Module','Speed = 2x','Speed = 4x','Speed = 10x','Exit');

end
