function [peaks, Ipeaks] = findPeaks(x,th, deadT, Stat)
% find all peaks in x
% [peaks, Ipeaks] = findPeaks(x,th);
%
% x      - column vector
% th     - consider only peaks which are above  th*std
% deadT  - minimal number of samples between succesive peaks.  When closer
%          choose the bigest. [default 0];
% Stat   - which statistic to use: 'std' or 'mad' [default 'std]
%
% peaks  - values of peaks
% Ipeaks - indices in x where the peaks are

% Uses:
%     meanWnan
%     stdWnan

% nov-2007 MA
%  UPDATES
% Jan-2010 mean and std are ignoring NaNs.  MA
% Jul-2010 Default deadt is 0.  MA
% Mar-2011 Peak of plataus are also peaks!!(were ignored previousl!) MA
% Dec-2011 Stat added to allow using MAD.  MA

%% initialize
if ~exist('th','var'), th=0; end
if isempty(th), th=0; end
if ~exist('deadT','var'), deadT=0; end
if isempty(deadT), deadT=0; end
if ~exist('Stat','var'), Stat=[]; end
if isempty(Stat), Stat='std'; end
Normal = strcmpi(Stat,'STD');
[r,c] = size(x);
if (r<c), x=x'; end

%% find peaks and plataus
dx = diff(x);
% d2x = diff(dx)<0;
% changeDir = dx(1:end-1).*dx(2:end)<0;
% Ipeaks = find(changeDir&d2x)+1;

% new approach to detect also plataus
J=find(dx~=0)';
P=dx(J)>0;
N=dx(J)<0;
% K = find(P(1:end-1) & N(2:end));
Ipeaks = J(P(1:end-1) & N(2:end)) +1;
% if at the peaks there are several identical values choose the middle
for ii = 1:length(Ipeaks)
    platau = 0;
    thisP = x(Ipeaks(ii));
    thisI = Ipeaks(ii);
    for jj = thisI:length(Ipeaks)
        if x(jj)==thisP
            platau = platau+1;
        else
            break
        end
    end
    Ipeaks(ii) = thisI +floor(platau/2);
end

%% lint the peaks according to size and dead time
peaks = x(Ipeaks);
if th>0
    if Normal
        sd =stdWnan(x);
        mn=meanWnan(x);
    else
        y = x(~isnan(x));
        mn = median(y);
        sd = mad(y);
    end
    smallP = find(peaks<(mn+th*sd));
    peaks(smallP)=[];
    Ipeaks(smallP)=[];
end
if deadT>1
    eliminate = true;  % initial start
    while sum(eliminate>0)
        eliminate = false(size(Ipeaks));
        ii = 2;
        oldI = Ipeaks(1);
        oldP = peaks(1);
        while ii<=length(Ipeaks)
            if (Ipeaks(ii)-oldI)<=deadT
                if peaks(ii)>oldP
                    eliminate(ii-1)=true;
                    oldI = Ipeaks(ii);
                    oldP = peaks(ii);
                else
                    eliminate(ii)=true;
                end
            else
                oldI = Ipeaks(ii);
                oldP = peaks(ii);
            end
            ii = ii+1;
        end
        peaks(eliminate)=[];
        Ipeaks(eliminate)=[];
    end
end
return
