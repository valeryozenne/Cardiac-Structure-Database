clc;
clear all;
close all;

%%

fid = fopen("32_dir.txt","r");

data = textscan(fid,'%s');
data = data{1,1};
data_real = data(3:3:end);
data_real = strrep(data_real,'(','');
data_real = strrep(data_real,')','');
data_real = split(data_real,',');

data_real_mat = str2double((data_real));
colonne_1000 = 1000*ones(1,size(data_real_mat,1))';

data_real_mat = [data_real_mat colonne_1000];
fclose(fid);
data_real_mat(:,1) = -data_real_mat(:,1);
data_real_mat(:,3) = -data_real_mat(:,3);

fid = fopen("direction.txt","w+");
for i = 1:size(data_real_mat,1)
    fprintf(fid,'%d %d %d %d \n',data_real_mat(i,:));
end

fclose(fid);

fid = fopen("direction_b0.txt","w+");
data_real_mat_0 = 0 *ones(1,4);
for i = 1:size(data_real_mat,1)
    fprintf(fid,'%d -%d %d %d \n',data_real_mat(i,:));
end

fclose(fid);