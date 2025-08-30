import { create } from "zustand";

interface AudioPlayer {
  play: (sound: string) => void;
  stop: (sound: string) => void;
};

export const useAudioStore = create<AudioPlayer>(() => {
  const audioRefs: { [key: string]: HTMLAudioElement } = {};

  const sounds: { [key: string]: string } = {
    
  };

  Object.keys(sounds).forEach((sound) => {
    audioRefs[sound] = new Audio(sounds[sound]);
  });

  return {
    play: (sound: string) => {
      const audio = audioRefs[sound];
      if (audio) {
        audio.currentTime = 0;
        audio.volume = 0.5;
        audio.play()
      } else {
        console.warn(`Sound "${sound}" not found`);
      };
    },
    stop: (sound: string) => {
      const audio = audioRefs[sound];
      if (audio) {
        audio.pause();
        audio.currentTime = 0;
      } else {
        console.warn(`Sound "${sound}" not found`);
      };
    }
  };
});