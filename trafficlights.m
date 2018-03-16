function state_out = trafficlights(state_in,timer,ljHandle)


ljud_LoadDriver
ljud_Constants




r1 = 1; %variables for the LEDs - lets us adjust the actual port at any time
r2 = 2;
y1 = 3;
y2 = 4;
g1 = 5;
g2 = 6;


while state_in = 2; %interrupt state - lets the other ones overwrite it
    %might need code for quick end based on crosswalk
end

%tic

tic = 0; 
while state_in = 1  
    [Error state]= ljud_eGet(ljHandle, LJ_ioGET_DIGITAL_BIT,4,0,0);
    Error_Message(Error)

    
% switch ( on and off)
%     if (state == 0)  
%         pause(1) 
%         disp('switch is pressed')
%         tic = tic + 1;
%         fprintf('t =  %d s', tic)
%         
%         Switch
%         
%         switchkey = mod(tic,2)
%         if switchkey == 0
%            display('press to start') 
%         else 





%Tiemr
x = -1;         
turn = -1

%while timer_end < timer_start + (1/timer)*(pause duration)
tic
timer_start = toc;
timer_end = toc;
for k = 1:1:inf          

tic
timer_start = toc;
timer_start = toc;
%for k2 = 1:1:18 %every 21 seconds and for 15 seconds
while timer_end < (timer_start + 18) *(1/timer)
    turn = 1  %two traffic lights are red
    timer_end = toc;
end

tic
timer_start = toc;
timer_end = toc;
%for k2 = 1:1:3  %every 33 seconds and for 3 seconds
while timer_end < (timer_start + 3) *(1/timer) 
    turn = 2 %two traffic lights are yellow
    timer_end = toc;
end

tic
timer_start = toc;
timer_end = toc;
%for k2 = 1:1:15 %every 18 seconds and for 18 seconds
while timer_end < (timer_start + 15) *(1/timer)   
    turn = 3  %two traffic lights are green
    timer_end = toc;
end
end
            
            if turn == 1
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, r1, 1, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, y1, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, g1, 0, 0)
            
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, r2, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, y2, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, g2, 1, 0)

            end
            if turn == 2
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, r1, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, y1, 1, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, g1, 0, 0)
            
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, r2, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, y2, 1, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, g2, 0, 0)
 
            end
            if turn = 3
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, r1, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, y1, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, g1, 1, 0)
            
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, r2, 1, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, y2, 0, 0)
            Error = ljud_ePut (ljHandle, LJ_ioPUT_DIGITAL_BIT, g2, 0, 0)
            

            end
        end  
    end
end

end