
%% pdf4D method for reading (and writing) 4D-Neuroimaging data

% see detailed instructions on http://biomag.wikidot.com/msi-matlab

% change directory (cd) to where the data is
% in the classroom double click on the desktop (not in matlab) to mount the shared forlder megdata
% then in matlab cd .gvfs; see the megdata icon in the Current Folder
% window. double click on it and go on with the script. cd oddball


% create a pdf (processed data file, no acrobat reader) object
% check the channel index for channel A245 or any other channel
% read the channel from sample 1 to 10173 (about 10s)

pdf=pdf4D('c,rfhp0.1Hz'); 
chan='A70';
chi=channel_index(pdf,chan,'name');
data1 = read_data_block(pdf,[1 1018],chi);

% read the same channel of the cleaned file.
cleanpdf=pdf4D('xc,hb,lf_c,rfhp0.1Hz'); 
data2=read_data_block(cleanpdf,[1 1018],chi);

%% plot the channel for original and cleaned files
timeline=0:(1/1017.25):1;
plot(timeline,data1,'r')
hold on
plot(timeline,data2,'b')
xlabel ('Time in Seconds');
ylabel('Amplitude, Tesla');
title(['channel ',chan])
legend ('original','cleaned')

%% calculate and plot power spectrum
[data1PSD, freq] = allSpectra(data1,1017.25,1,'FFT');
[data2PSD, freq] = allSpectra(data2,1017.25,1,'FFT');
figure;plot (freq(1,1:120),data1PSD(1,1:120),'r')
hold on;
plot (freq(1,1:120),data2PSD(1,1:120),'b')
xlabel ('Frequency Hz');
ylabel('SQRT(PSD), T/sqrt(Hz)');
title('Mean PSD for A245');
