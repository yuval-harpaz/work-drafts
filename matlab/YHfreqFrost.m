
% 1. prepare a spreadsheet column with words in 's ('רכבת').
% 2. copy and ctrl v it to {}stim in stim.mat.
% 3. load stim.mat

%clear all
%load stim

nameFrost=stim(:,1);
nameFrost=strrep(nameFrost,'א','%E0');
nameFrost=strrep(nameFrost,'ב','%E1');
nameFrost=strrep(nameFrost,'ג','%E2');
nameFrost=strrep(nameFrost,'ד','%E3');
nameFrost=strrep(nameFrost,'ה','%E4');
nameFrost=strrep(nameFrost,'ו','%E5');
nameFrost=strrep(nameFrost,'ז','%E6');
nameFrost=strrep(nameFrost,'ח','%E7');
nameFrost=strrep(nameFrost,'ט','%E8');
nameFrost=strrep(nameFrost,'י','%E9');
nameFrost=strrep(nameFrost,'ך','%EA');
nameFrost=strrep(nameFrost,'כ','%EB');
nameFrost=strrep(nameFrost,'ל','%EC');
nameFrost=strrep(nameFrost,'ם','%ED');
nameFrost=strrep(nameFrost,'מ','%EE');
nameFrost=strrep(nameFrost,'ן','%EF');
nameFrost=strrep(nameFrost,'נ','%F0');
nameFrost=strrep(nameFrost,'ס','%F1');
nameFrost=strrep(nameFrost,'ע','%F2');
nameFrost=strrep(nameFrost,'ף','%F3');
nameFrost=strrep(nameFrost,'פ','%F4');
nameFrost=strrep(nameFrost,'ץ','%F5');
nameFrost=strrep(nameFrost,'צ','%F6');
nameFrost=strrep(nameFrost,'ק','%F7');
nameFrost=strrep(nameFrost,'ר','%F8');
nameFrost=strrep(nameFrost,'ש','%F9');
nameFrost=strrep(nameFrost,'ת','%FA');
s1='<td>�</td>';
s2='<td>��</td>';
s3='<td>���</td>';
s4='<td>����</td>';
s5='<td>�����</td>';
s6='<td>������</td>';
s7='<td>�������</td>';
s8='<td>��������</td>';
s9='<td>���������</td>';
s10='<td>����������</td>';
s11='<td>�����������</td>';
s12='<td>������������</td>';
%lookfor={'<td>��</td>','<td>���</td>','<td>����</td>','<td>�����</td>','<td>������</td>','<td>�������</td>',...
%    '<td>��������</td>','<td>���������</td>','<td>����������</td>','<td>�����������</td>','<td>������������</td>','<td>�������������</td>','<td>��������������</td>','<td>���������������</td>','<td>����������������</td>','<td>�����������������</td>'};

for i=1:size(nameFrost,1)
pagename=['http://word-freq.mscc.huji.ac.il/wordfreq.asp?search=',nameFrost{i,1}(1,1:end)];
[s res]=urlread(pagename);
str=['LF=s',num2str(length([stim{i,1}])),';'];
eval(str);
str1=['k=strfind(s, ''',LF,''');'];
eval(str1);
if ~isempty(k)
    k=k+30+length([stim{i,1}]);
    k1=k+strfind(s(1,k:k+15), '<');
    k1=k1(1,1)-2;
    stim(i,2)={s(1,k:k1)};
    i
else
    warning ('the exact string was not found');
    i
end

end
save stimf.mat stim
clear
load stimf