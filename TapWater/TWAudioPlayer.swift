import AVFoundation

class TWAudioPlayer: AVAudioPlayer {
    // Init
    private static let chimePlayer: TWAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource(
            "chime",
            withExtension: "mp3"
        )!
        return try! TWAudioPlayer(contentsOfURL: url)
    }()
}

// MARK: Play sounds

extension TWAudioPlayer {
    class func playChime() {
        if chimePlayer.playing {
            chimePlayer.stop()
        }
        chimePlayer.prepareToPlay()
        chimePlayer.play()
    }
}
