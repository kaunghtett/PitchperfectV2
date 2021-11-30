//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Min Kaung Htet on 17/11/2021.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    func changeUI(label: String, recordState: Bool) {
        stopButton.isEnabled = !recordState
        recordButton.isEnabled = recordState
        recordLabel.text = label
    }
    
    @IBAction func recordAction(_ sender: Any) {
       changeUI(label: "Recording In Progress",recordState: false)
       
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
              let recordingName = "recordedVoice.wav"
              let pathArray = [dirPath, recordingName]
              let filePath = URL(string: pathArray.joined(separator: "/"))
            
        
              let session = AVAudioSession.sharedInstance()
              try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

              try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
              audioRecorder.prepareToRecord()
              audioRecorder.record()
        print("Recrod Tab")
    }
    
    @IBAction func stopAction(_ sender: Any) {
        changeUI(label: "Tap to Record",recordState: true)
      
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

