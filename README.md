# matlab_lint

These files are intented to help lint matlab funcitons and scripts. They can be used with special-measure

```
%% here is an example

ff = rDir(pwd); % get directory info
[~,ext] = strtok({ff.name},'.'); % these are file extensions
ff = ff(strcmp(ext,'.m')); %only want the m-files
for j = 1:length(ff)
   tmp = matlab_lint(ff(j).name);
   if ~isempty(fieldnames(tmp))
        ff(j).passed = isempty(tmp.problems);
        ff(j).problems = tmp.problems;
   else % returns empty if can't open file
      ff(j).passed = 0;
      fprintf('empty\n')
   end
end

bad_files = ff(~[ff.passed]);
```

will return a struct array with entires:

**name**: 'my_file.m'  
**date**: '01-Jan-2015'  
**bytes**: 1024  
**isdir**: 0  
**datenum**: 73569e+05  
**problems**: {'improper doc string'}  

