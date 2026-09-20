function stegoImage = embedSecret(coverImage, secretImage, pin, logFcn)

    samplingFactor = 2;

    if nargin < 4
        logFcn = @(message) [];
    end


    secretSampled = secretImage( ...
        1:samplingFactor:end, ...
        1:samplingFactor:end, :);

    sampledHeight = size(secretSampled,1);
    sampledWidth = size(secretSampled,2);
    sampledChannels = size(secretSampled,3);

    logFcn('Sampling completed.');

    header = uint32([sampledHeight sampledWidth sampledChannels]);
    headerBytes = typecast(header,'uint8');
    headerBytes = headerBytes(:);

    levels = 16;

    secretQuantized = uint8( ...
        round(double(secretSampled) / 255 * (levels - 1)) ...
        * (255 / (levels - 1)));

    logFcn('Quantization completed.');

    seed = str2double(pin);

    rng(seed,'twister');

    pnSequence = uint8( ...
        randi([0 255],size(secretQuantized)));

    encryptedSecret = bitxor( ...
        secretQuantized, ...
        pnSequence);

    logFcn('PN scrambling completed.');

    cover = coverImage;

    encryptedVector = encryptedSecret(:);

    dataBytes = [headerBytes; encryptedVector];

    secretBits = zeros(numel(dataBytes) * 8,1,'uint8');

    for k = 1:8
        secretBits(k:8:end) = bitget(dataBytes,9-k);
    end

    numBits = numel(secretBits);

    coverVector = cover(:);

    if numBits > numel(coverVector)
        error('Secret image is too large for the selected cover image.');
    end

    coverVector(1:numBits) = bitset( ...
        coverVector(1:numBits), ...
        1, ...
        secretBits);

    stegoImage = reshape(coverVector,size(cover));

    logFcn('LSB embedding completed.');

end

%[appendix]{"version":"1.0"}
%---
