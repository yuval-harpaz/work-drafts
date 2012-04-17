% practice data processing

% cd to verbGen folder
% in this experiment there are two types of trials. silent verb generation
% for written words (Hebrew, trigger = 202) and a control task where 3-7
% crosses where displayed on screen and subjets had to mentally declare
% "odd" or "even".

% HINT use the syllabus to see which scripts to use
% create a new script, you can save it in ~/Documents/MATLAB. copy parts
% from the scripts of course1-4 to your script.
https://docs.google.com/spreadsheet/ccc?key=0An6Gz6j3w5USdHpvdFFHOEhKb0dNUlFuMFJNalRjZUE
%% 1. clean the data with createCleanFile.
% clean 50Hz, building vibrations and heartbeat artifacts. 
%
% while the script is running (~15min) start working on item 2.
%% 2. read the data for verb generaton trials
% for every trial read 200ms before the trigger to 600ms after. note that 
% these are visual stimuli, specify visafter option where needed.
% 