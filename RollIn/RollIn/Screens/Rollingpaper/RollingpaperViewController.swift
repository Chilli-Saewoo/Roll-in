//
//  RollingpaperViewController.swift
//  RollIn
//
//  Created by 한택환 on 2022/10/22.
//

import UIKit
import Firebase

final class RollingpaperViewController: UIViewController {
    private let rollingpaperView = RollingpaperView()
    private let ref = Database.database().reference()
    var notes: [Note] = []
    var recievedNotes: [String : [String : AnyObject]] = [:] {
        didSet {
            var newNotes: [Note] = []
            for recievedNote in recievedNotes {
                let addedDateString = recievedNote.value["timestamp"] as? String ?? ""
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
                formatter.timeZone = TimeZone(identifier: "UTC")
                let dateObject = formatter.date(from: addedDateString) ?? Date()
                let newNote = Note(id: recievedNote.key,
                                   timeStamp: dateObject,
                                   sender: recievedNote.value["sender"] as? String ?? "",
                                   image: recievedNote.value["image"] as? Int ?? 0,
                                   message: recievedNote.value["message"] as? String ?? "")
                newNotes.append(newNote)
            }
            self.notes = newNotes.sorted(by: <)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setRollingpaperView()
        observeUserNotes()
    }
    
    private func observeUserNotes() {
        guard let userId = UserDefaults.userId else { return }
        self.ref.child("users").child(userId).child("notes").observe(.value) { snapshot in
            self.recievedNotes = snapshot.value as? [String : [String : AnyObject]] ?? [:]
        }
    }
}

private extension RollingpaperViewController {
    func setRollingpaperView() {
        view.addSubview(rollingpaperView)
        rollingpaperView.frame = view.frame
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI
struct RollingpaperVCPreview: PreviewProvider {
    static var previews: some View {
        RollingpaperViewController().toPreview()
    }
}
#endif
