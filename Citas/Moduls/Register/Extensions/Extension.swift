//
//  Extension.swift
//  Citas
//
//  Created by 1058889 on 27/09/22.
//

import Foundation.NSUserDefaults
import FirebaseAuth

extension RegisterViewController: RegisterViewProtocols { }

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwdField.becomeFirstResponder()
        } else if textField == passwdField {
            registerButtonTapped()
        }
        return true
    }
}

// MARK: RegisterViewController - UIImagePicker
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (_   : UIAlertAction!) in
                })
                
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            } else {
                self?.presentCamera()
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        // UIImagePickerController.InfoKey.original
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        self.imageView.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController {
    @objc public func registerButtonTapped() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwdField.resignFirstResponder()
        guard let firstName = firstNameField.text, let lastName = lastNameField.text, let email = emailField.text, let pwd = passwdField.text, !firstName.isEmpty, !lastName.isEmpty,
              !email.isEmpty, !pwd.isEmpty else {
            alertUserLoginError(message: "Complete por favor todos los campos requeridos.")
            return
        }
        
        if !email.validarEmail() {
            alertUserLoginError(message: "Ingrese un Email válido!")
            return
        }
        
        if passwdField.isInvalid() {
            alertUserLoginError(message: "Por favor valide la seguridad de su contraseña.\n Su contraseña debe contener una longitud minima de 8 carácteres, una letra mayúscula y un número.")
            return
        }
        
        spinner.show(in: view)

        // Firebase Log In

        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }

            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }

            guard !exists else {
                // user already exists
                strongSelf.alertUserLoginError(
                    message: "Looks like a user account for that email address already exists."
                )
                return
            }

            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pwd, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error cureating user")
                    return
                }

                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")

                let chatUser = User(firstName: firstName,
                                          lastName: lastName,
                                          emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // upload image
                        guard let image = strongSelf.imageView.image,
                            let data = image.pngData() else {
                                return
                        }
                        let filename = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage maanger error: \(error)")
                            }
                        })
                    }
                })

                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}
