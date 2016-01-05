function atlPlot(month,year)
% month = 8;
if ~exist('month','var')
    month=datestr(date,5);
end
if ~ischar(month)
    month=num2str(month);
end
if length(month)==1
    month=['0',month];
end
if ~exist('year','var')
    year=datestr(date,10);
end
if ~ischar(year)
    year=num2str(year);
end
cd ~/Documents/ATL/
[~,w]=unix(['wget -O atl.dat --user=qd --password=79653 ftp://132.71.85.91/StorageCard/DAT_Files/ATL-Log-',year,'-',month,'.dat']);

unix(['grep DT#',year,' atl.dat > atl.txt'])
table=importdata('atl.txt');
table=table.data;
%time=table.textdata;
date0=1438646400; %2015-08-04-00:00:00
midnight=date0:60*60*24:table(end,1);
midnight=midnight(midnight>table(1,1));
X=[midnight;midnight];
Y=zeros(1,length(midnight));
Y(2,:)=160;

figure;
plot(table(:,1),table(:,3),'g')
hold on
plot(table(:,1),table(:,4),'y')
plot(table(:,1),table(:,7),'r')
plot(table(:,1),table(:,9),'b')
line(X,Y,'color','k')
legend('psi','L/min','K','L','midnight')
plot(table(:,1),table(:,9),'b')

