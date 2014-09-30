function dispProg
N=10;
reverseStr = [];
for i = 1:N
    pause(0.1)
    %msg = sprintf('Processed %d/%d', i, N);
    str=['process ',num2str(i),' of ',num2str(N)];
    disp([reverseStr,str]);
    reverseStr = repmat(sprintf('\b'), 1, length(str)+1);
end
%msg = sprintf('Processed %d/%d', i, N);
fprintf(reverseStr)

