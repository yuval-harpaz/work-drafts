function writeport64(trigval,trigdur)
% give it trigger value (1:255 but better use even numbers)
% stops automatically after 70ms unless you specify 
% duration (in ms or empty for infinitly)
% taken from outp.m
% examples
%
% writeport64(254,200)
%
% writeport64(100)
%
% writeport64(212,[])
% writeport64(0)
%
if ~exist('trigdur','var')
    trigdur=70;
end
global cogent;
tic
io64(cogent.io.ioObj,888,trigval);
if ~trigval==0 && ~isempty(trigdur)
    while toc<(trigdur/1000)
        ;
    end
    try
        io64(cogent.io.ioObj,888,0);
    catch
        config_io;
        io64(cogent.io.ioObj,888,0);
    end
end