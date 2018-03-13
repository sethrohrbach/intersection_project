clc
clear

% %loads the labjack stuff
% clf % Clears the figure window
% clear global
% 
% % Load LabJack UD library and initialize LabJack constants
% ljud_LoadDriver
% ljud_Constants
% 
% % Open the first found LabJack U3
% [Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
% Error_Message(Error) % Check for and display any errors
%  
% % Set all pin assignments to the factory default condition
% [Error] = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
% Error_Message(Error)

%test

exit = 1; %to end the loop
speed = 1; %initializing speed variable


while exit == 1 %runs till exit is selected
    
    debug_state = debug_menu;   
    
    if debug_state == 9
        exit = 0;
        state_mode = 0; %all modules off
    elseif debug_state == 1
        state_mode = 1; %all modules on
    elseif debug_state == 2
        state_mode = 2; %just crosswalk module
    elseif debug_state == 3
        state_mode = 3; %just traffic light module on
    elseif debug_state == 4
        state_mode = 4; %just train module on
    elseif debug_state == 5
        speed = 2;
    elseif debug_state == 6
        speed = 4;
    elseif debug_state == 7
        speed = 10;
    elseif debug_state == 8
        speed = 1;
    end
    
   state_mode = 1; %initializing
   mod_state = 1; 
   
    while state_mode ~= 0 % calls on the modules as per state input.
        if state_mode == 1
            train_state = train_module(speed,mod_state);
            crosswalk_state = Crosswalk(speed,mod_state);
            if train_state == 3 %these checks are for if crosswalk or train modules are running, lets the other modes know they are being interrupted
                mod_state = train_state;
                train_state = train_module(speed,mod_state);
                Crosswalk(speed,mod_state)
                trafficlights(speed,mod_state)
            elseif crosswalk_state == 3
                mod_state = crosswalk_state;
                crosswalk_state = Crosswalk(speed,mod_state);
                train_module(speed,mod_state)
                trafficlights(speed,mod_state)
            end
        elseif state_mode == 2
            Crosswalk(speed,mod_state)
        elseif state_mode == 3
            trafficlights(speed,mod_state)
        elseif state_mode == 4
            whatever = train_module(speed,mod_state); %we're not saving the output state for debug mode - dont need to tell other modules to interrupt
        end
    end
end










    

function debug_state = debug_menu()%calls a menu with modes and speeds
    debug_state = menu('Select a runmode or speed:','Run','Crosswalk Module','Traffic Light Module','Train Module','Speed = 2x','Speed = 4x','Speed = 10x','Speed = 1x','Exit');

end
