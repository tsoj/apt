# Installation

1. Download the song (you need to have yt-dlp and ffmpeg installed for this step):
```bash
# Go into the directory in which `home_folder` lies (i.e. if you type `ls` this README.md and `home_folder` show up
yt-dlp --extract-audio --audio-format wav -o ./apt-sound-orig.wav "https://www.youtube.com/watch?v=wFeEbjLJDmI"
ffmpeg -ss 6.7 -i ./apt-sound-orig.wav -acodec copy ./home_folder/.local/share/sounds/apt-sound.wav
```
2. Review code of `home_folder/.apt_sound.sh`, because there is no guarantee that it won't blow up your system.
3. Copy the contents of the folder `home_folder` into your home directory.
4. Add the line `source ~/.apt_sound.sh` to your `.bashrc`.
5. Profit.


Download the song only if it's not illegal to do so ...
