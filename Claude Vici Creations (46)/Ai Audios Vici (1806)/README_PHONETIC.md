# Audio to Phonetic Transcription Tool

This tool converts audio files to phonetic pronunciation using the International Phonetic Alphabet (IPA).

## What it does

1. Takes a `.wav` audio file as input
2. Converts speech to text using Google Speech Recognition
3. Converts the text to phonetic pronunciation (IPA notation)

## How to use

### Simple usage:

```bash
./run_phonetic.sh your_audio_file.wav
```

### Process multiple files:

```bash
./run_phonetic.sh file1.wav file2.wav file3.wav
```

### Save results to a file:

```bash
./run_phonetic.sh audio.wav -o results.txt
```

### Spanish audio:

```bash
./run_phonetic.sh audio.wav -l spa-Latn
```

## Examples with your files

Process a single audio file:
```bash
./run_phonetic.sh AaronColoradoElectric.wav
```

Process all .wav files in the directory (just a few):
```bash
./run_phonetic.sh *.wav | head -50
```

Save results:
```bash
./run_phonetic.sh AaronColoradoElectric.wav -o transcription_results.txt
```

## Supported Languages

- `eng-Latn` = English (default)
- `spa-Latn` = Spanish
- `fra-Latn` = French
- `deu-Latn` = German

## Output Format

The tool will display:

```
==========================================================
TRANSCRIBED TEXT:
==========================================================
[The text that was spoken in the audio]

==========================================================
PHONETIC PRONUNCIATION (IPA):
==========================================================
[The IPA phonetic representation]
==========================================================
```

## Requirements

- Python 3
- Internet connection (for Google Speech Recognition API)
- Audio files in `.wav` format

All dependencies are already installed in the virtual environment.

## Troubleshooting

If you get a permission error, make sure the script is executable:
```bash
chmod +x run_phonetic.sh
```

If the tool can't understand the audio:
- Make sure the audio is clear and not too noisy
- Check that it's a `.wav` file
- Try a shorter audio clip

## Quick Start

Test it right now with one of your existing files:

```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici"
./run_phonetic.sh AaronColoradoElectric.wav
```
