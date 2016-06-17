//
//  ViewController.swift
//  HelloWorld
//
//  Created by Andrew Raharjo on 6/16/16.
//  Copyright © 2016 Andrew Raharjo. All rights reserved.
//

import UIKit
import AVFoundation

//Performing the Delegate to the Controller - recordingStop
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    //initialize audioRecorder
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func recordAudio(sender: AnyObject) {
        print("Recording Pressed ")
        recordLabel.text = "Recording in Progress"
        stopRecordingButton.enabled = true
        recordButton.enabled = false
        
        //start Audio session
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop Recording")
        recordLabel.text = "Tap to Record"
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        
        //stop audio recording session
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.enabled = false
    }
    //
    //Delegation allows one class to do the work for another. The class knows what methods will exist in
    //the delegate because they both agree on a contract, the protocol
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print ("Finish audio recording and saved")
        //start the play with check the flag
        if (flag == true){
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else if (flag == false){
            print ("Saving recording Failed")
        } else {
            print ("Error in recording")
        }
    }
    
    //Prepare for segue, the problem - we need to find the url for storing the wav
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordAudioURL = recordedAudioURL
        }
    }

}

