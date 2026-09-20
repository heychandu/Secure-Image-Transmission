function recoveredSecret = extractSecret(stegoImage, pin, logFcn)

    if nargin < 3
        logFcn = @(message) [];
    end

    stegoVector = stegoImage(:);

    extractedBits = bitget(stegoVector,1);

    logFcn('LSB extraction completed.');

    headerBits = extractedBits(1:96);

    headerBytes = zeros(12,1,'uint8');

    for k = 1:8
        bits = headerBits(k:8:end);

        headerBytes = bitor( ...
            headerBytes, ...
            bitshift(uint8(bits),8-k));
    end

    header = typecast(headerBytes,'uint32');

    sampledHeight = double(header(1));
    sampledWidth = double(header(2));
    sampledChannels = double(header(3));

    numDataBytes = ...
        sampledHeight * sampledWidth * sampledChannels;

    dataStart = 97;
    dataEnd = dataStart + numDataBytes * 8 - 1;

    if dataEnd > numel(extractedBits)
        error('Stego image does not contain enough embedded data.');
    end

    dataBits = extractedBits(dataStart:dataEnd);

    encryptedData = zeros(numDataBytes,1,'uint8');

    for k = 1:8
        bits = dataBits(k:8:end);

        encryptedData = bitor( ...
            encryptedData, ...
            bitshift(uint8(bits),8-k));
    end

    encryptedData = reshape( ...
        encryptedData, ...
        [sampledHeight sampledWidth sampledChannels]);

    seed = str2double(pin);

    rng(seed,'twister');

    pnSequence = uint8( ...
        randi([0 255], ...
        [sampledHeight sampledWidth sampledChannels]));

    recoveredSecret = bitxor( ...
        encryptedData, ...
        pnSequence);

    recoveredSecret = uint8(recoveredSecret);

    logFcn('PN descrambling completed.');

    recoveredSecret = imresize( ...
        recoveredSecret, ...
        2, ...
        'bilinear');

    logFcn('Image reconstruction completed.');

end