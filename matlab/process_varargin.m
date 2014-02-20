function [keyvalue] = process_varargin(func_name, okargs, default_value, vararg)

n=length(vararg);
n_ok=length(okargs);
for i=1:n_ok
    keyvalue{i}=[];
end
for j=1:2:n
      pname = vararg{j};
      k = strmatch(lower(pname), okargs);
      if isempty(k)
          error('%s: Unknown parameter name: %s.',func_name, pname);
      end
      if length(k)>1
          error('%s: Ambiguous parameter name: %s.', func_name, pname);
      end

      if (j+1 > n)
          error('%s: missing value for parameter name: %s.',func_name, pname);
      end
      pval = vararg{j+1};
      keyvalue{k} = pval;
end

for i=1:n_ok
    if isempty(keyvalue{i})
        keyvalue{i} = default_value{i};
    end
end
end
