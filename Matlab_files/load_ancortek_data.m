function sdr = load_ancortek_data(filename)

    % Constants
    c = 299792458;   % speed of ligth [m/s]

    % Data
    radar_data = load(filename);
    fields = fieldnames(radar_data);
    sp = signal_properties(radar_data);
    
    indices = find(~cellfun(@isempty, regexp(fields, '(DATA)\d', 'match')));
    sp.NCh = length(indices);
    
    DataMatrix = zeros(sp.NCh, sp.NPulses, sp.NRanges);
    for i=1:sp.NCh
        key = fields(indices(i));
        IFdata = radar_data.(key{1});
        DataMatrix(i, :, :) = transpose(reshape(IFdata - mean(IFdata), sp.NRanges, sp.NPulses));
    end
    sdr.props = sp;
    sdr.datamatrix = DataMatrix;

end