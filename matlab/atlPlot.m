
cd ~/Documents/ATL/
[~,w]=unix('wget -O atl.dat --user=qd --password=79653 ftp://132.71.85.91/StorageCard/DAT_Files/ATL-Log-2015-08.dat');

!grep DT#2015 atl.dat > atl.txt
table=importdata('atl.txt');
%time=table.textdata;
figure;
plot(table(:,1),table(:,3),'g')
hold on
plot(table(:,1),table(:,4),'y')
plot(table(:,1),table(:,7),'r')
plot(table(:,1),table(:,9),'b')
legend('psi','L/min','K','L')
