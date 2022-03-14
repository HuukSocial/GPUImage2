import UIKit
import HuukGPUImage2

class ViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    @IBOutlet private weak var slider: UISlider!
    
//    var movie:MovieInput!
//    var filter:Pixellate!
    
    private let skinSmoothFilter = HighPassSkinSmoothingFilter()
    private let lookup = ImageLUTFilter(named: "lookup")
    private var pictureInput: PictureInput!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        self.skinSmoothFilter.amount = 1
        self.skinSmoothFilter.radius = HighPassSkinSmoothingRadius(pixels: 1 * 16)
        let image = UIImage(named: "SampleImage")
        self.pictureInput = PictureInput(image: image!)
        self.pictureInput.processImage()
        
        self.pictureInput --> self.lookup --> self.skinSmoothFilter --> self.renderView
        
//        let bundleURL = Bundle.main.resourceURL!
//        let movieURL = URL(string:"sample_iPod.m4v", relativeTo:bundleURL)!
//
//        do {
//            movie = try MovieInput(url:movieURL, playAtActualSpeed:true)
//            filter = Pixellate()
//            movie --> filter --> renderView
//            movie.runBenchmark = true
//            movie.start()
//        } catch {
//            print("Couldn't process movie with error: \(error)")
//        }

//            let documentsDir = try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask, appropriateForURL:nil, create:true)
//            let fileURL = NSURL(string:"test.png", relativeToURL:documentsDir)!
//            try pngImage.writeToURL(fileURL, options:.DataWritingAtomic)
    }
    
    @IBAction func didchange(_ sender: UISlider) {
//        self.skinSmoothFilter.amount = sender.value
//        self.skinSmoothFilter.radius = HighPassSkinSmoothingRadius(pixels: sender.value * 16)
//        self.pictureInput.processImage()
    }
}


