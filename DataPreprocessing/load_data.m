% ������ݲ����򵥵��˲�����
% by Jim 2018.10.11
function data_pkg = load_data(file_id)
    file_name = ['./data/slp', num2str(file_id), '_recm.mat'];
    data = load(file_name);
    
    %����PSG����
    ecg = data.slp48_recm(1, :);
    resp_chest = data.slp48_recm(2, :);
    eog = data.slp48_recm(3, :);
    EEG_C4A1 = data.slp48_recm(4, :);
    chin_emg = data.slp48_recm(5, :);
    %����PSG����
    
    %��ȡPSG�ź�����Ԥ����
    eog = filter(EOG822_10Hz, eog);
    EEG_C4A1 = filter(EEG822_15Hz, EEG_C4A1);
    chin_emg = filter(EMG822_40Hz, chin_emg);
    %��ȡPSG�ź�����Ԥ����
    
    %Ԥ������ɺ����ݷ�װ
    data_pkg.ecg = ecg;
    data_pkg.resp_chest = resp_chest;
    data_pkg.eog = eog;
    data_pkg.chin_emg = chin_emg;
    data_pkg.EEG_C4A1 = EEG_C4A1;
    data_pkg.sample_rate = 250;%������
    data_pkg.file_id = file_id;
    %Ԥ������ɺ����ݷ�װ
end