package util;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.logging.Logger;

public class AudioConverterUtil {
    private static final Logger LOGGER = Logger.getLogger(AudioConverterUtil.class.getName());

    /**
     * Convert .webm to .wav (16kHz, mono, PCM) suitable for Azure Speech Services.
     * Requires FFmpeg to be installed and available in the system PATH.
     */
    public static File convertWebmToWav(File webmFile) throws Exception {
        String wavPath = webmFile.getAbsolutePath().replace(".webm", ".wav");
        if (wavPath.equals(webmFile.getAbsolutePath())) {
            wavPath += "_converted.wav";
        }
        File wavFile = new File(wavPath);
        
        try {
            ProcessBuilder pb = new ProcessBuilder(
                "ffmpeg", "-y", "-i", webmFile.getAbsolutePath(),
                "-ar", "16000", "-ac", "1", "-c:a", "pcm_s16le",
                wavFile.getAbsolutePath()
            );
            
            pb.redirectErrorStream(true);
            Process process = pb.start();
            
            // Read output to prevent buffer blocking
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    // LOGGER.info(line); // Optional: log ffmpeg output
                }
            }
            
            int exitCode = process.waitFor();
            
            if (exitCode != 0) {
                throw new Exception("FFmpeg conversion failed with exit code: " + exitCode);
            }
            
            return wavFile;
        } catch (Exception e) {
            LOGGER.severe("Error converting audio: " + e.getMessage());
            throw e;
        }
    }
}
