# "Ağla Fenerbahçem Ağla" — 20 s cinematic music-video picture cut

Output: `artifacts/video.mp4` (delivered separately as `video/mp4`, not committed).

## Specs (verified with ffprobe)

| Property | Value |
|---|---|
| Duration | 20.000 s |
| Video | H.264 High, yuv420p, 1920×1080 (16:9), 24 fps, CRF 18 |
| Audio | AAC-LC, 48 kHz stereo, **digital silence** |
| Container | MP4, `+faststart` (moov at front, plays in browsers) |
| Size | ~34 MiB |

## Audio choice

The brief says the Suno song is added afterwards, with no generated music or dialogue. The file has
a silent AAC stereo track so that it meets the "H.264 + AAC" browser requirement and the song can be
swapped in later (for example `ffmpeg -i video.mp4 -i song.mp3 -map 0:v -map 1:a -c:v copy -c:a aac -shortest out.mp4`).

## Structure

Five 5-second clips were generated with Replicate (ByteDance Seedance 1 Pro / Pro-Fast, 1080p, 16:9),
each trimmed to 4.4 s and joined with 0.5 s cross-dissolves (5 × 4.4 − 4 × 0.5 = 20.0 s). There is a 0.4 s fade-in
from black and a 0.6 s fade-out. Each scene therefore lands at about 0–4, 4–8, 8–12, 12–16 and 16–20 s.

| Time | Scene | Model | Content |
|---|---|---|---|
| 0–4 s | 1 | seedance-1-pro | Aerial view of a floodlit stadium by the water with Istanbul lights, heavy rain, stands in yellow/navy, descending to a close-up of a soaked, silent supporter in a scarf |
| 4–8 s | 2 | seedance-1-pro-fast | Club office: one suited president leaves with a box, another sits down, then a new coach in a yellow/navy tracksuit walks in smiling |
| 8–12 s | 3 | seedance-1-pro-fast | Star-signing presentation: yellow/navy striped jersey, arms raised, fireworks, cheering stands, then the fireworks die away |
| 12–16 s | 4 | seedance-1-pro-fast | Yellow/navy supporters hold their heads in disbelief while red-shirted rivals celebrate behind them under gold confetti with a trophy |
| 16–20 s | 5 | seedance-1-pro-fast | Exaggerated close-up of a sobbing supporter clutching a yellow/navy scarf in the rain, with a crying crowd behind him |

Rebuild: `scripts/assemble.sh c1 c2 c3 c4 c5 artifacts/video.mp4` (set `FFMPEG="imd-media ffmpeg"` where that wrapper is required).
The prompts are in `prompts.md`.

## Limitations

- **Not 4K.** The models output 1920×1088. This was cropped to 1920×1080. "4K" in the brief is met only as a look, not as the resolution.
- **Small garbled lettering.** Despite "no text / no logos" in the prompts, the model puts small pseudo-letters and crest-like badges on some jerseys, ad boards and banners (most visible in scenes 3 and 4). No real club crest or sponsor name was kept. A take with a real sponsor name on shirts and one with a visible drone in shot were rejected and regenerated.
- **Stadium is generic.** It is not an accurate reconstruction of Şükrü Saracoğlu (Kadıköy). There are no official club marks.
- **Scene 2 is a slow montage.** The office scene shows the president/coach swap in one continuous shot, not rapid cuts. Seasons passing is only suggested.
- **Scene 5 pull-back.** The clip ends on the crying crowd, with only a slight move back rather than a full reveal of the stadium.
- **Generic faces.** The people are AI-generated and not meant to depict any real president, coach or player. Faces were checked on sampled frames and looked natural, but every frame was not reviewed.
- **Not a quality certificate.** The structural checks (codec, duration, size) do not establish visual quality.
