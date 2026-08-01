"""One-off generator for the app's placeholder sound effects.

Run with: python scripts/generate_sfx.py
Produces assets/sfx/correct.wav and assets/sfx/incorrect.wav (synthesized
tones, no external audio sources involved).
"""

import math
import struct
import wave

SAMPLE_RATE = 44100


def _envelope(i, n, fade=0.15):
    fade_samples = int(n * fade)
    if i < fade_samples:
        return i / fade_samples
    if i > n - fade_samples:
        return (n - i) / fade_samples
    return 1.0


def tone(freqs, duration, volume=0.35):
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        seg = min(int(t / (duration / len(freqs))), len(freqs) - 1)
        freq = freqs[seg]
        value = math.sin(2 * math.pi * freq * t) * volume * _envelope(i, n)
        samples.append(int(value * 32767))
    return samples


def write_wav(path, samples):
    with wave.open(path, "w") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(SAMPLE_RATE)
        f.writeframes(struct.pack("<%dh" % len(samples), *samples))


write_wav("assets/sfx/correct.wav", tone([880, 1318], 0.28))
write_wav("assets/sfx/incorrect.wav", tone([220, 175], 0.30))

print("wrote assets/sfx/correct.wav and assets/sfx/incorrect.wav")
