//
//  SceneDelegate.swift
//  HW17MaxZhuravlev
//
//  Created by Максим Журавлев on 24.05.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //        window?.windowScene = windowScene
        //        window?.makeKeyAndVisible()
        //
        //        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC1") as? ViewController {
        //        let navigationViewController = UINavigationController(rootViewController: viewController)
        //            window?.rootViewController = navigationViewController
        //        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        if UserDefaults.standard.string(forKey: "password") == nil {
            showSecurityAlert()
        } else {
            showDeniedAlert()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

//MARK: - Exstension для SceneDelegate
extension SceneDelegate: UISceneDelegate {
    
    //MARK: - Алерт для установки пароля, если он не установлен
    
    func showSecurityAlert() {
        //сворачиваю все презентованные окна, чтобы мог запуститьться мой алерт, если открыт какой-либо презент
        window?.rootViewController?.dismiss(animated: true)
        
        //Alert для установки пароля
        let securityAlert = UIAlertController(title: "Security", message: "Do you want to set a password?", preferredStyle: .alert)
        window?.rootViewController?.present(securityAlert, animated: true)
        
        //TextField для ввода пароля
        securityAlert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Password"
        }
        
        //Кнопка Set password
        let setPasswordButton = UIAlertAction(title: "Set password", style: .default) { [self] _ in
            let passwordTextField = (securityAlert.textFields?[0] ?? UITextField()) as UITextField
            
            //Проверка на пустые поля
            guard passwordTextField.hasText, let password = passwordTextField.text else {
                let emptyFieldAlert = UIAlertController(title: "Error", message: "Text field is empty", preferredStyle: .alert)
                self.window?.rootViewController?.present(emptyFieldAlert, animated: true)
                let okEmptyFieldAlertButton = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.showSecurityAlert()
                }
                emptyFieldAlert.addAction(okEmptyFieldAlertButton)
                return
            }
            //Сохраняю в UserDefaults
            UserDefaults.standard.set("\(password)", forKey: "password")
        }
        
        //Кнопка cancel
        let cancelSecurityButton = UIAlertAction(title: "Cancel", style: .destructive)
        securityAlert.addAction(setPasswordButton)
        securityAlert.addAction(cancelSecurityButton)
    }
    
    //MARK: - Алерт для ввода пароля, если он установлен
    func showDeniedAlert() {
        window?.rootViewController?.dismiss(animated: true)
        
        //Alert для поверки пароля
        let accessDeniedAlet = UIAlertController(title: "Access denied", message: "Enter your password", preferredStyle: .alert)
        window?.rootViewController?.present(accessDeniedAlet, animated: true)
        
        //TextField для ввода пароля
        accessDeniedAlet.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Password"
        }
        //кнопка Ок
        let okAccessDeniedAletButton = UIAlertAction(title: "Ok", style: .default) { [self] _ in
            
            let checkPasswordTextField = (accessDeniedAlet.textFields?[0] ?? UITextField()) as UITextField
            
            //Если пароль не введен и нажать Ок
            if !checkPasswordTextField.hasText {
                
                //Alert пустого пароля
                let emptyTextFieldAlert = UIAlertController(title: "Error!", message: "Введите парроль!", preferredStyle: .alert)
                window?.rootViewController?.present(emptyTextFieldAlert, animated: true)
                //Кнопка Ок
                let okemptyTextFieldAlertButton = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.showDeniedAlert()
                }
                emptyTextFieldAlert.addAction(okemptyTextFieldAlertButton)
            }
            
            guard checkPasswordTextField.hasText, let checkPassword = checkPasswordTextField.text else {return}
            
            //Сравниваю сохраненный пароль с введенным
            guard let passwordString = UserDefaults.standard.string(forKey: "password") else {return}
            if checkPassword == passwordString{
                accessDeniedAlet.dismiss(animated: true)
            } else {
                let wrongPasswordAlert = UIAlertController(title: "Error!", message: "Wrong password", preferredStyle: .alert)
                window?.rootViewController?.present(wrongPasswordAlert, animated: true)
                
                let okWrongPasswordAlertButton = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.showDeniedAlert()
                }
                wrongPasswordAlert.addAction(okWrongPasswordAlertButton)
            }
        }
        accessDeniedAlet.addAction(okAccessDeniedAletButton)
    }
}
