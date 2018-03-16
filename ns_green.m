function ns_green(on,ljHandle,LJ_ioPUT_DIGITAL_BIT)
%Sends power to the LJ port input, while true is sent in. Turns other
%lights off.
global NS_T_R
global NS_T_Y
global NS_T_G
global NS_C_R
global NS_C_W
global EW_T_R
global EW_T_Y
global EW_T_G
global EW_C_R
global EW_C_W
global TRAIN_SW
global CW_SW

    if on
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, EW_T_R, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, EW_T_Y, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, EW_T_G, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, EW_C_R, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, EW_C_W, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, NS_T_R, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, NS_T_Y, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, NS_T_G, 1, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, NS_C_R, 0, 0);
     Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, NS_C_W, 1, 0);
    end
end
