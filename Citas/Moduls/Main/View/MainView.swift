//
//  MainView.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

import UIKit

class MainView: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var keys: UIBarButtonItem!
    @IBOutlet weak var selected: UISegmentedControl!
    
    var cantidadLlaves: Int = 3
    var context = CIContext(options: nil)
    var presenter: MainPresenterProcol?
    static var listUsers: [UserEntity] = []
    let standarUserDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.standarUserDefault.string(forKey: "llaves") == nil {
            self.standarUserDefault.set(3, forKey: "llaves")
        }
        self.configView()
    }

    private func configView() {
        self.keys.title = "\(self.standarUserDefault.integer(forKey: "llaves")) 🔑"
        self.presenter?.getUser()
    }

    private func startViewData(users: [UserEntity]) {
        MainView.listUsers = users
        self.collection.reloadData()
    }

    @IBAction func selectGender(_ sender: Any) {
        let selection = selected.selectedSegmentIndex
        self.presenter?.getGenderUser(genero: selection, usuarios: MainView.listUsers)
    }

    @IBAction func addKeys(_ sender: Any) {
        let vwc = UIAlertController(
            title: "Comprar llaves",
            message: "¿Desea comprar llaves?",
            preferredStyle: .alert)
        vwc.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        vwc.addTextField()
        let btnAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
            // codigo para comprar llaves
            if let cantidad = vwc.textFields![0].text {
                self.standarUserDefault.set(cantidad, forKey: "llaves")
            }
        })
        vwc.addAction(btnAceptar)
        self.present(vwc, animated: true)
    }
}

extension MainView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if MainView.listUsers[indexPath.row].enable {
            // Se llama al usuario desbloqueado
            let obj = MainRouter()
            guard let viewC = obj.pushScreen() as? PerfilUserViewController else {
                return
            }
            // vc.modalPresentationStyle = .fullScreen
            self.present(viewC, animated: true, completion: nil)
        } else {
            if self.standarUserDefault.integer(forKey: "llaves") > 0 {
                // here
                let alert = UIAlertController(title: "Demo V.I.P.I.R.", message: "¿Está usted segur@ que desea ver a este usuario?", preferredStyle: .alert)
                let noAlert = UIAlertAction(title: "Cancelar", style: .cancel)
                let yesAlert = UIAlertAction(title: "Confirmar", style: .default, handler: { (_: UIAlertAction!) in
                    self.noHideUser(index: indexPath.row)
                })
                alert.addAction(noAlert)
                alert.addAction(yesAlert)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Lo sentimos, ya no cuenta con llaves para ver más ususarios.",
                    preferredStyle: .alert
                )
                let btnAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainView.listUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var user: UserEntity?
        user = MainView.listUsers[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Celda", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.lblUltimaVez.text = "1 hr ago"
        cell.lblAge.text = "Edad: \(user!.age)"

        if let enable = user?.enable {
            if enable {
        cell.imgUno.image = UIImage(named: user?.image ?? "")
            cell.imgSecond.isHidden = true
            // cell.imgUno.alpha = 1
        } else {
            cell.imgUno.image = UIImage(named: user?.image ?? "")
            cell.imgSecond.isHidden = false
            blurEffect(bcg: cell.imgUno)
            cell.imgSecond.image = UIImage(named: "candado")
            // cell.imgUno.alpha = 0.4
        }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collection.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size + 150)
    }

    func noHideUser(index: Int) {
        MainView.listUsers[index].enable = true
        // self.cantidadLlaves = self.cantidadLlaves - 1
        // self.keys.title = "\(self.cantidadLlaves) 🔑"
        self.collection.reloadData()
        let auxLlaves = self.standarUserDefault.integer(forKey: "llaves")
        self.standarUserDefault.set(auxLlaves - 1, forKey: "llaves")
        self.keys.title = "\(auxLlaves - 1) 🔑"
    }
}

// Recibe la data del presenter, que a su vez lo recibio del intercator
extension MainView: MainViewProtocols {
    func showError() { }

    func showSuccess() { }

    func createdTable(user: [UserEntity]) {
        self.startViewData(users: user)
    }
}
