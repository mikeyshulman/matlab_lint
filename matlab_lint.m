function results = matlab_lint(fname)
%function results = matlab_lint(fname)
% take in filename, fname (default will raise uigetfile) and check it for
% conformity. 
% returns results = struct of nice stats

if ~exist('fname','var') || isempty(fname)
   fname = uigetfile(); 
end

fid = fopen(fname);
if fid < 0
    fprintf('cannot open file %s\n', fname)
    results = struct();
    return
end
%read the file line by line into a cell array
text_lines = {fgetl(fid)};
while ischar(text_lines{end})
    text_lines{end+1} = fgetl(fid);%#ok<AGROW>
end
fclose(fid);

if length(text_lines)<=1
   fprintf('empty file %s\n',fname);
   results = struct();
    return 
end

%lens = cellfun(@length,text_lines);
code_lines = [];
comment_lines = [];

for j = 1:length(text_lines)-1
    tmp = strtrim(text_lines{j});
    if ~isempty(tmp)
        if tmp(1) =='%' % first non space is '%'
            comment_lines = [comment_lines,j];%#ok<AGROW>
        else
            code_lines = [code_lines,j];%#ok<AGROW>
        end
    end
end

problems = {};
% is it a function? if so, does it have the proper documentation
is_func = ~isempty(strfind(text_lines{code_lines(1)},'function'));% its a function
if  is_func
    func_declare = text_lines{code_lines(1)}; %function declaration
    func_declare(isspace(func_declare))='';
    %now find the first comment line after the function declaration
    comment_ind = comment_lines(find(comment_lines>code_lines(1),1));
    if isempty(comment_ind)
       comment_ind = code_lines(1)+1; 
    end
    comments = text_lines{comment_ind};
    comments(isspace(comments))='';
    if isempty(strfind(comments,func_declare))
        text_lines(1+comment_ind:end+1) = text_lines(comment_ind:end);
        text_lines{comment_ind} = ['% ',text_lines{code_lines(1)}];
        problems{end+1} = 'improper doc string';
    end
end

%now make sure function name matches file name
if is_func
   [~,partial_fname] = fileparts(fname);
   func_declare = text_lines{code_lines(1)}; %function declaration
   func_declare = strrep(func_declare,'function','');
   func_declare(isspace(func_declare))=''; %remove spaces
   %remove output arguments
   
   if ~isempty(strfind(func_declare,'=')) % strip away before '=' 
      func_declare =  func_declare(1+strfind(func_declare,'='):end); 
   end   
   %now remove input arguments
   if ~isempty(strfind(func_declare,'(')) % strip away before '=' 
      func_declare =  func_declare(1:strfind(func_declare,'(')-1); 
   end
   
   if ~strcmp(partial_fname,func_declare)
      problems{end+1} = 'function and file names do not match'; 
   end
end

new_text = '';
for j = 1:length(text_lines)
    new_text = [new_text,sprintf('%s\n',text_lines{j})]; %#ok<AGROW>
end

%pass back results
results.is_func = is_func;
results.problems = problems;
results.code_lines = length(code_lines);
results.comment_lines = length(comment_lines);
results.new_text = new_text;
results.builtin_linter = checkcode(fname);

end