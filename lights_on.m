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


forever = 1;
while forever == 1
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 0, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 1, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 2, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 3, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 4, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 5, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 6, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, 7, 1, 0);
end
