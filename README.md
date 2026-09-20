# DSP-Based Secure Image Transmission Using Pseudo Noise Sequence and LSB Image Steganography

<p align="center">

  <img src="https://img.shields.io/badge/MATLAB-R2026a-orange?style=for-the-badge&logo=mathworks" alt="MATLAB">

  <img src="https://img.shields.io/badge/Digital%20Signal%20Processing-DSP-blue?style=for-the-badge" alt="DSP">

  <img src="https://img.shields.io/badge/MATLAB%20App%20Designer-GUI-green?style=for-the-badge" alt="MATLAB App Designer">

  <img src="https://img.shields.io/badge/Release-v10.0-purple?style=for-the-badge" alt="Version">

</p>

<p align="center">
  <b>A MATLAB-based DSP system for secure image transmission using sampling, quantization, PIN-seeded pseudo-random scrambling, XOR processing, and LSB steganography.</b>
</p>


---

##  Overview

This project presents a **Digital Signal Processing (DSP)-based secure image transmission system** that combines signal-processing techniques with image steganography.

The system processes a secret image through:

- Sampling
- Quantization
- PIN-seeded pseudo-random sequence generation
- XOR scrambling
- LSB image embedding

The processed secret data is then embedded into a cover image to generate a **stego image**.

The stego image can be saved and transferred to a receiver. At the receiver side, the hidden information is extracted, descrambled using the same PIN, and reconstructed to obtain the recovered secret image.

The complete system is implemented using **MATLAB App Designer** with separate Sender and Receiver interfaces.

---

#  Objectives

The primary objectives of this project are:

- To demonstrate practical DSP processing on image signals.
- To reduce secret-image data through sampling.
- To apply quantization to the sampled image.
- To generate a PIN-seeded pseudo-random sequence.
- To scramble secret-image data using XOR.
- To hide processed data using LSB steganography.
- To simulate secure image transmission using a saved stego image.
- To extract the hidden information at the receiver.
- To perform PN-based descrambling.
- To reconstruct the recovered image using interpolation.
- To provide an interactive MATLAB GUI for the complete transmission process.

---

## Author

**Chandu R**
GitHub: [@heychandu](https://github.com/heychandu)
