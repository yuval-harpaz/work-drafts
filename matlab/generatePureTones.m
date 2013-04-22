function generatePureTones(freq,amp,Awgt,slope)
% freq is a vector of desired frequencies
% amp is 0 to 1
% for A-weighting Awgt=true; better over 1000Hz to avoid clipping
% slope is linear increase and decrease of amp to void clicks, length in s.

if ~exist('Awgt','var')
    Awgt=false;
end
if isempty(Awgt)
    Awgt=false;
end
if ~exist('slope','var')
    slope=0.1;
elseif isempty(slope)
    slope=0.1
end
    
A=1; % no Aweighting by default
samplingRate = 22000;
lenSound = 0.5;
T = 1/samplingRate;
t = 0:T:lenSound-T;
pow=3.1623;
startF=50;

try
    if isempty(freq)
        freq = round([startF startF*pow startF*pow^2 startF*pow^3 startF*pow^4]);
    end
catch %#ok<*CTCH>
    freq = round([startF startF*pow startF*pow^2 startF*pow^3 startF*pow^4]);
end
try
    if isempty(amp)
        amp=1;
    end
catch %#ok<*CTCH>
    amp=1;
end
ampstr='';
if ~(amp==1)
    ampstr=[num2str(amp),'_'];
end

%% making slope

slpSamp=samplingRate*slope;
slpDif=1/(samplingRate*slope);
lin=0:slpDif:1-slpDif;
nil=fliplr(lin);
slpLen=length(lin);
if slpLen>samplingRate*lenSound/2;
    error('slope to big')
end
for ii = 1 : length(freq)
    if Awgt
        A=aweight(freq(ii));
    end
    soundVec = amp.*(sin(2*pi*freq(ii)*t)./A)';
    soundVec(1:slpLen)=soundVec(1:slpLen).*lin';
    soundVec(end-slpLen+1:end)=soundVec(end-slpLen+1:end).*nil';
    figure;plot(t,soundVec);
    title([num2str(freq(ii)),'Hz']);
    sound(soundVec, samplingRate);
    % add square wave
    squareLen = round(0.015*samplingRate); 
    soundVec(:,2) = 0;
    soundVec(2:squareLen,2) = 1;
    wavwrite(soundVec, samplingRate, sprintf('%s%sHz',strrep(ampstr,'.',''),num2str(freq(ii))))
end