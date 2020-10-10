textprogressbar('Loop Rate (ms): ');
tic
currentPeakTimeMs = 100;
while true
    elapsedTimeMs = floor(toc*1000);
    textprogressbar(elapsedTimeMs);
    if(elapsedTimeMs > currentPeakTimeMs)
        currentPeakTimeMs = elapsedTimeMs;
        textprogressbar('Detected New Max Loop Time');
        textprogressbar('Loop Rate (ms): ');
    end
    tic
        
    %The function(s) you want to measure here:
    pause(0.098);
    
end