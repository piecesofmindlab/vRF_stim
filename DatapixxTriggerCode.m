
% This initiates Datapixx communication and sets which output bit will trigger the
% experiment.

Datapixx('Open');
Datapixx('StopAllSchedules');
Datapixx('RegWrRd'); 
Datapixx('SetDinDataDirection', hex2dec('1F0000'));
Datapixx('SetDinDataOut', hex2dec('1F0000'));
Datapixx('SetDinDataOutStrength', 1);   % Set brightness of buttons

% Fire up the logger
Datapixx('EnableDinDebounce');      % Filter out button bounce
%Datapixx('DisableDinDebounce');    % Uncomment this line to log gruesome details of button bounce
Datapixx('SetDinLog');              % Configure logging with default values
Datapixx('StartDinLog');
Datapixx('RegWrRd');
% Get initial state of all the digital input bits
initialValues = Datapixx('GetDinValues');

% Set input bit assigned to trigger
% This should be the 10th bit for the trigger, but can be checked with DatapixDinBasicsDemo
% Set between 0-3 to check trigger with button box
tbit = 10;

% Get initial trigger bit value

    if (bitand(initialValues, 2^tbit) > 0)
        trigInit = 1;
    else
        trigInit = 0;
    end

% Reminder to self, test whether this is necessary
if (exist('OCTAVE_VERSION'))
    fflush(stdout);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the while loop that will hold up the experiment until the first
% triggger is received

% Start variable
trig = trigInit;

while trig == trigInit;
    Datapixx('RegWrRd');
    status = Datapixx('GetDinStatus');
    if (status.newLogFrames > 0)
        [data tt] = Datapixx('ReadDinLog');
        for i = 1:status.newLogFrames
                if (bitand(data(i), 2^tbit) > 0)
                    trig = 1;
                else
                    trig = 0;
                end

        end
        if (exist('OCTAVE_VERSION'))
            fflush(stdout);
        end
    end
end


