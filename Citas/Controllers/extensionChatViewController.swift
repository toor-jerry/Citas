//
//  extensionChatViewController.swift
//  Citas
//
//  Created by 1058889 on 26/09/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import AVFoundation
import AVKit

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let messageId = createMessageId(),
            let conversationId = conversationId,
            let name = self.title,
            let selfSender = selfSender else {
                return
        }

        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"

            // Upload image

            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Photo: \(urlString)")

                    guard let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus") else {
                            return
                    }

                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)

                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .photo(media))

                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in

                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("failed to send photo message")
                        }

                    })

                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
        else if let videoUrl = info[.mediaURL] as? URL {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"

            // Upload Video

            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Video: \(urlString)")

                    guard let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus") else {
                            return
                    }

                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)

                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .video(media))

                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in

                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("failed to send photo message")
                        }

                    })

                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
    }

}

extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageId() else {
                return
        }

        print("Sending: \(text)")

        let mmessage = Message(sender: selfSender,
                               messageId: messageId,
                               sentDate: Date(),
                               kind: .text(text))

        // Send Message
        if isNewConversation {
            // create convo in database
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage, completion: { [weak self]success in
                if success {
                    print("message sent")
                    self?.isNewConversation = false
                    let newConversationId = "conversation_\(mmessage.messageId)"
                    self?.conversationId = newConversationId
                    self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                    self?.messageInputBar.inputTextView.text = nil
                }
                else {
                    print("faield ot send")
                }
            })
        }
        else {
            guard let conversationId = conversationId, let name = self.title else {
                return
            }

            // append to existing conversation data
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: mmessage, completion: { [weak self] success in
                if success {
                    self?.messageInputBar.inputTextView.text = nil
                    print("message sent")
                }
                else {
                    print("failed to send")
                }
            })
        }
    }

    public func createMessageId() -> String? { // private
        // date, otherUesrEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)

        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"

        print("created message id: \(newIdentifier)")

        return newIdentifier
    }

}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }

        fatalError("Self Sender is nil, email should be cached")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            // our message that we've sent
            return .link
        }

        return .secondarySystemBackground
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {

        let sender = message.sender

        if sender.senderId == selfSender?.senderId {
            // show our image
            if let currentUserImageURL = self.senderPhotoURL {
                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            }
            else {
                // images/safeemail_profile_picture.png

                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                    return
                }

                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
                let path = "images/\(safeEmail)_profile_picture.png"

                // fetch url
                StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
                    switch result {
                    case .success(let url):
                        self?.senderPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                })
            }
        }
        else {
            // other user image
            if let otherUsrePHotoURL = self.otherUserPhotoURL {
                avatarView.sd_setImage(with: otherUsrePHotoURL, completed: nil)
            }
            else {
                // fetch url
                let email = self.otherUserEmail

                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
                let path = "images/\(safeEmail)_profile_picture.png"

                // fetch url
                StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
                    switch result {
                    case .success(let url):
                        self?.otherUserPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                })
            }
        }

    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .location(let locationData):
            let coordinates = locationData.location.coordinate
            let vc = LocationPickerViewController(coordinates: coordinates)
            
            vc.title = "Location"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerViewController(with: imageUrl)
            navigationController?.pushViewController(vc, animated: true)
        case .video(let media):
            guard let videoUrl = media.url else {
                return
            }
            
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
            present(vc, animated: true)
        default:
            break
        }
    }
}
