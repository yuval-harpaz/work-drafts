function [mData, vData,N] = meanAround(Data, whereCycle, iBefore, iAfter,...
    toFlipUD, toShiftLR, onPeak)
% compute the average around whereCycle
%   [mData, vData] = meanAround(Data, whereCycle, iBefore, iAfter,... 
%            toFlipUD, toShiftLR, onPeak);
%
% Data       - a raw vector with data to be cleaned
% whereCycle - list of indices into Data where the cycles are
% iBefore    - how many points before
% iAfter     - howmany points after
% toFlipUD   - 'flip' if to flip data so as to maintain the same general
%              shape, [default 'noFlip']
% toShiftLR  - n means try to shift the data left or right by n samples
%              till there is maximal overlap with the mean.  notSpecified
%              or [] or 0 mean donot shift.
% onPeak     - 'peak' or 'slope'. 'peak' means flip if the peak at
%              whereCycle is positive, 'slope' means flip if slope is
%              positive.  [default 'slope']
%
% mData      - the cleaned data, vector of length(1+iBefore+iAfter)
% vData      - the variance around the mean
% Notes
%  iBefore must be positive

% Nov-2009  MA
%   UPDATES
% JAN-2010 variance around mean added
% JUL-2010 flipping option added
% Dec-2011 flipping by peak improved, errors on mData, vData, and n -fixed
%          stil errors on toShift! MA
% Mar-2012 N is added to output  MA

%% initialize
if ~exist('toFlipUD','var'), toFlipUD=[];end
if isempty(toFlipUD), toFlipUD='noFlip'; end
if ~exist('toShiftLR','var'), toShiftLR=[];end
if isempty(toShiftLR)
    toShiftLR = 0;
end
if toShiftLR==0
    toShift = false;
else
    toShift = true;
end
toFlip = strcmpi(toFlipUD, 'FLIP');
if ~exist('onPeak','var'), onPeak=[];end
if isempty(onPeak), onPeak='slope'; end
onSlope = strcmpi(onPeak, 'SLOPE');

mData = zeros(1,1+iBefore+iAfter);
vData = mData;
allData = zeros(length(whereCycle),1+iBefore+iAfter);
nn=0;
whereCycle = round(whereCycle);

%% logical tests
if size(Data,1)~=1
    error('MATLAB:MEGanalysis:wrongParameters','Data must be a raw vector')
end
if max(whereCycle)>length(Data)
    error('MATLAB:MEGanalysis:wrongParameters','Indices in whereCycle too big')
end

%% scale up
factor = max(abs(Data));
Data = Data/factor;

%% statistics of all complete cycles
for cycle = 1:length(whereCycle)
    zData = whereCycle(cycle);
    dBack = zData-iBefore;
    dFore = zData+iAfter;
    if dBack>0 && dFore<=length(Data);
        thisPiece = Data(dBack:dFore);
        mData = mData +thisPiece;
        vData = vData +thisPiece.*thisPiece;
        nn = nn+1;
        allData(cycle,:) = Data(dBack:dFore);
    end
end

%% flip for maximal similarity
if toFlip
    tmpM = mData-mean(mData);
    mData(:)=0;
    vData(:)=0;
    nn=0;
    for cycle = 1:length(whereCycle)
        zData = whereCycle(cycle);
        dBack = zData-iBefore;
        dFore = zData+iAfter;
        if dBack>0 && dFore<=length(Data);
            thisPiece = Data(dBack:dFore);
            if onSlope % make all slopes in the same direction
                if sum(tmpM.*(thisPiece-mean(thisPiece)))<0
                    thisPiece = -thisPiece;  % flip UpDown
                end
            else  % make all peaks negative
                pp = thisPiece((iBefore-1):(iBefore+3));
                I = find(abs(pp)==max(abs(pp)),1);
                pval = pp(I)>0;
%                 pval = thisPiece(iBefore+1) - ...
%                     0.5*(thisPiece(iBefore-1) + thisPiece(iBefore+3));
                if pval>0, thisPiece = -thisPiece; end
            end
            mData = mData +thisPiece;
            vData = vData +thisPiece.*thisPiece;
            nn = nn+1;
            allData(cycle,:) = thisPiece;
        end
    end
end  % end of toFlip

%% shift left right till maximal similarity
if toShift  
    tmpM = mData-mean(mData);
    mData(:)=0;
    vData(:)=0;
    nn=0;
    pLength = length(tmpM)-1;
    for cycle = 1:length(whereCycle)
        zData = whereCycle(cycle);
        dBack = zData-iBefore;
        dFore = zData+iAfter;
        if dBack>0 && dFore<=length(Data);
            thisPiece = Data(dBack:dFore);
            if toFlip
                if sum(tmpM.*(thisPiece-mean(thisPiece)))<0
                    flipIt = true;  % flip UpDown
                else
                    flipIt = false;
                end
            end
            dBack = zData-iBefore-toShiftLR;
            dFore = zData+iAfter+toShiftLR;
            fit = nan(1,2*toShiftLR+1);
            if dBack>0 && dFore<=length(Data) % extended piece in range
                thisPiece = Data(dBack:dFore);
                if flipIt
                    thisPiece = -thisPiece;
                end
                thisPiece = thisPiece-mean(thisPiece);
                for ii=1:length(fit)
                    fit(ii) = abs(sum(mData.*thisPiece(ii:ii+pLength)));
                end  % end of trying all pieces
                maxShift = find(fit==max(fit),1);
                thisPiece = thisPiece(maxShift:maxShift+pLength);
            else  % use it without shifts
                dBack = zData-iBefore;
                dFore = zData+iAfter;
                thisPiece = Data(dBack:dFore);
                if flipIt
                    thisPiece = -thisPiece;
                end
                thisPiece = thisPiece-mean(thisPiece);
            end  % end of extended piece in range of data
            mData = mData +thisPiece;
            vData = vData +thisPiece.*thisPiece;
            nn = nn+1;
            allData(cycle,:) = thisPiece;
        end
    end  % end of going over all pieces
end % end of toShift

%% wrap up
mData = mData/nn;
vData = (vData-nn*mData.*mData)/(nn-1);
mData = factor*mData;
vData = factor*factor*vData;
N = nn;

return

