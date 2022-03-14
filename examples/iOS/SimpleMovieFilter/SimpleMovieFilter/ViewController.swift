import UIKit
import GPUImage
import CoreAudio
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    @IBOutlet weak var progress: UILabel!
    
    private var movieInput: MovieInput?
    private var movieOutput: MovieOutput?
    
    var movie:MovieInput!
    var filter:Pixellate!
//    var speaker:SpeakerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var isFistPlay = false;
    private func firstPlay () -> Bool {
//        if isFistPlay {
//            return false
//        }
//        isFistPlay = true
//        let bundleURL = Bundle.main.resourceURL!
//        let movieURL = URL(string:"sample.m4v", relativeTo:bundleURL)!
//        let movieURL1 = URL(string:"sample1.mp4", relativeTo:bundleURL)!
//        let movieURL2 = URL(string:"sample2.mp4", relativeTo:bundleURL)!
//
//        do {
//            let audioDecodeSettings = [AVFormatIDKey:kAudioFormatLinearPCM,
//                                       AVSampleRateKey: NSNumber(value: 44100.0),
//                                       AVLinearPCMBitDepthKey: NSNumber(value: 16),
//                                       AVLinearPCMIsNonInterleaved: NSNumber(value: false),
//                                       AVLinearPCMIsFloatKey: NSNumber(value: false),
//                                       AVLinearPCMIsBigEndianKey: NSNumber(value: false)] as [String : Any]
//
//            movie = try MovieInput(urls: [movieURL2,movieURL,movieURL1], playAtActualSpeed:true, loop:true, audioSettings:audioDecodeSettings)
////            speaker = SpeakerOutput()
////            movie.audioEncodingTarget = speaker
//
//            filter = Pixellate()
//            movie --> filter --> renderView
//            movie.runBenchmark = false
//
//            movie.start(atTime: CMTime(seconds: 50, preferredTimescale: 1000))
//            return true
////            speaker.start()
//        } catch {
//            print("Couldn't process movie with error: \(error)")
//            isFistPlay = false
//            return false
//        }
        return false
    }
    
    @IBAction func pause() {
        movie.pause()
//        speaker.cancel()
    }
    
    @IBAction func cancel() {
        movie.cancel()
//        speaker.cancel()
    }
    
    @IBAction func play() {
        if !firstPlay() {
            movie.start()
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func merge() {
        let bundleURL = Bundle.main.resourceURL!
//        let movieURL1 = URL(string:"sample1.mp4", relativeTo:bundleURL)!
//        let movieURL2 = URL(string:"sample2.mp4", relativeTo:bundleURL)!
//        let movieURL3 = URL(string:"sample3.mp4", relativeTo:bundleURL)!
        let movieURL4 = URL(string:"sample4.mp4", relativeTo:bundleURL)!
        let movieURL5 = URL(string:"sample5.mp4", relativeTo:bundleURL)!
        
        do {
            let inputOptions = [AVURLAssetPreferPreciseDurationAndTimingKey:NSNumber(value:true)]
            let asstes = [movieURL4, movieURL5].map({
                AVURLAsset(url: $0, options: inputOptions)
            })
            
            guard let videoTrack = asstes.first!.tracks(withMediaType:AVMediaType.video).first else { return }
            let audioTrack = asstes.first!.tracks(withMediaType:AVMediaType.audio).first
            
            let audioDecodingSettings: [String:Any]?
            let audioEncodingSettings: [String:Any]?
            let audioSourceFormatHint: CMFormatDescription? = nil
            
            audioDecodingSettings = [AVFormatIDKey:kAudioFormatLinearPCM] // Noncompressed audio samples
            var acl = AudioChannelLayout()
            memset(&acl, 0, MemoryLayout<AudioChannelLayout>.size)
            acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo
            audioEncodingSettings = [
                AVFormatIDKey:kAudioFormatMPEG4AAC,
                AVNumberOfChannelsKey:2,
                AVSampleRateKey:AVAudioSession.sharedInstance().sampleRate,
                AVChannelLayoutKey:NSData(bytes:&acl, length:MemoryLayout<AudioChannelLayout>.size),
                AVEncoderBitRateKey:96000
            ]
            
            movieInput = try MovieInput(assets: asstes, videoComposition:nil, playAtActualSpeed:false, loop:false, audioSettings:audioDecodingSettings)
            
            let videoEncodingSettings:[String:Any] = [
                AVVideoCompressionPropertiesKey: [
                    AVVideoExpectedSourceFrameRateKey:videoTrack.nominalFrameRate,
                    AVVideoAverageBitRateKey:videoTrack.estimatedDataRate,
                    AVVideoProfileLevelKey:AVVideoProfileLevelH264HighAutoLevel,
                    AVVideoH264EntropyModeKey:AVVideoH264EntropyModeCABAC,
                    AVVideoAllowFrameReorderingKey:videoTrack.requiresFrameReordering],
                AVVideoCodecKey:AVVideoCodecType.h264]
            
            let destinationUrl = getDocumentsDirectory().appendingPathComponent("Merge_Allvideo.mp4")
            print(destinationUrl)
            
            try? FileManager().removeItem(at: destinationUrl)
            movieOutput = try MovieOutput(URL: destinationUrl, size: Size(width: 480, height: 320), fileType: AVFileType.mp4, liveVideo: false, videoSettings: videoEncodingSettings, videoNaturalTimeScale: videoTrack.naturalTimeScale, audioSettings: audioEncodingSettings, audioSourceFormatHint: audioSourceFormatHint)
            movieInput?.synchronizedEncodingDebug = true
            
            if(audioTrack != nil) { movieInput!.audioEncodingTarget = movieOutput }
            movieInput!.synchronizedMovieOutput = movieOutput
            
            
            
            movieInput! --> movieOutput!
            movieInput?.completion = {
                self.movieOutput?.finishRecording {
                    self.movieInput?.audioEncodingTarget = nil
                    self.movieInput?.synchronizedMovieOutput = nil
                    self.movieInput?.removeAllTargets()
                    self.movieInput = nil
                    self.movieOutput = nil
                    DispatchQueue.main.async {
                        print("Encoding finished: \(destinationUrl)")
                    }
                }
            }
            
            movieInput?.progress = { [weak self] progressVal in
                DispatchQueue.main.async {
                    self?.progress.text = String(progressVal)                    
                }
            }
            
            movieOutput?.startRecording { started, error in
                if(!started) {
                    print("ERROR: MovieOutput unable to start writing with error: \(String(describing: error))")
                    return
                }
                self.movieInput?.start()
                print("Encoding started")
            }
            
        } catch {
            print("mergeFilter Crash: \(error)")
        }
        
    }
}

