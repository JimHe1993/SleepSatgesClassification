% 打包数据并做简单的滤波处理
% by Jim 2018.10.11
function data_pkg = load_data(file_id)
    file_name = ['./data/slp', num2str(file_id), '_recm.mat'];
    data = load(file_name);
    
    %导出PSG数据
    ecg = data.slp48_recm(1, :);
    resp_chest = data.slp48_recm(2, :);
    eog = data.slp48_recm(3, :);
    EEG_C4A1 = data.slp48_recm(4, :);
    chin_emg = data.slp48_recm(5, :);
    %导出PSG数据
    
    %提取PSG信号特征预处理
    eog = filter(EOG822_10Hz, eog);
    EEG_C4A1 = filter(EEG822_15Hz, EEG_C4A1);
    chin_emg = filter(EMG822_40Hz, chin_emg);
    %提取PSG信号特征预处理
    
    %预处理完成后数据封装
    data_pkg.ecg = ecg;
    data_pkg.resp_chest = resp_chest;
    data_pkg.eog = eog;
    data_pkg.chin_emg = chin_emg;
    data_pkg.EEG_C4A1 = EEG_C4A1;
    data_pkg.sample_rate = 250;%采样率
    data_pkg.file_id = file_id;
    %预处理完成后数据封装
end