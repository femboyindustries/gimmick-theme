import subprocess
import os
import sys

def convert_mp4_to_ogg(directory):
    if not os.path.isdir(directory):
        print(f"The directory {directory} does not exist.")
        sys.exit(1)
    
    files = os.listdir(directory)
    mp4_files = [file for file in files if file.endswith('.mp4')]
    
    for mp4_file in mp4_files:
        full_path_to_mp4 = os.path.join(directory, mp4_file)
        padded_mp4_file = f"{os.path.splitext(mp4_file)[0]}_padded.mp4"
        full_path_to_padded_mp4 = os.path.join(directory, padded_mp4_file)
        padding_cmd = ['ffmpeg', '-i', full_path_to_mp4, '-vf', 'tpad=stop_mode=clone:stop_duration=0.5', full_path_to_padded_mp4]
        try:
            subprocess.run(padding_cmd, check=True)
        except subprocess.CalledProcessError:
            print(f"Failed to add padding to {mp4_file}")
            continue

        os.remove(full_path_to_mp4)
        os.rename(full_path_to_padded_mp4, full_path_to_mp4)

        ogg_file = f"{os.path.splitext(mp4_file)[0]}.ogg"
        full_path_to_ogg = os.path.join(directory, ogg_file)
        cmd = ['ffmpeg', '-i', full_path_to_mp4, '-vn', '-acodec', 'libvorbis', full_path_to_ogg]
        try:
            subprocess.run(cmd, check=True)
        except subprocess.CalledProcessError:
            print(f"Failed to convert {mp4_file}")
            continue

if __name__ == "__main__":
    convert_mp4_to_ogg(os.path.dirname(os.path.realpath(__file__)))
