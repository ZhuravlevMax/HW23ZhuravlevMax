//
//  ViewController.swift
//  HW17MaxZhuravlev
//
//  Created by Максим Журавлев on 24.05.22.
//

import UIKit
import SnapKit
import SDCAlertView

class ViewController: UIViewController {
    // массива урлов разделен на картинки и папки и удаляем урл по индекспасу
    //на дидсет все оформление: эд батон...
    //енам для удаления папок и работы кнопок
    //MARK: -привязка аутлетов
    @IBOutlet weak var catalogTableView: UITableView!
    @IBOutlet weak var barAddButtonItem: UIButton!
    @IBOutlet weak var barChekButtonItem: UIButton!
    @IBOutlet weak var barDeleteButtonItem: UIButton!
    
    @IBOutlet weak var switcherControl: UISegmentedControl!
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    
    @IBOutlet weak var collectionCell: UIView!
    
    //MARK: -создание переменных
    let fileManager = FileManager.default
    var titleNewFolder: String?
    var titleNextFolder: String?
    
    //стартовый URL
    private var startCatalogURL: URL!
    
    //массив для хранения IndexPath
    var indexPathArray: [IndexPath] = []

    //Словарь для работы с объектами по типу
    var contentTypeDictionary: [ContentTypeEnum : [ContentFile]] = [:]
    //переменная для работы с переключателем
    var selectPositionSwitcher: Int = 0
    
    //сюда буду заносить названия папок в директории
    var arrayContent: [URL] = []
    
    //Словарь для файлов, будет 2 экземпляра: один для папок, другой для файлов
    class ContentFile {
        var fileUrl: URL// свойство для хранения ссылок
        var fileType: ContentTypeEnum //Енум для выбора типа: файл или папка
        var isSelect: Bool
        
        init (fileUrl: URL, fileType: ContentTypeEnum, isSelect: Bool ) {
            self.fileUrl = fileUrl
            self.fileType = fileType
            self.isSelect = isSelect
        }
        
    }
        
    enum ContentTypeEnum: Int{
        case folder = 0
        case image
    }
    
    //enum для состояния объекта
    enum EditState {
        case navigate
        case select
    }

    var editState: EditState = .navigate {
        
        didSet {
            barAddButtonItem.isEnabled = editState == .navigate
            barDeleteButtonItem.isHidden = editState == .navigate
            barDeleteButtonItem.isEnabled = editState == .navigate
            barChekButtonItem.isSelected = editState == .select
            
            if editState == .navigate {
                contentTypeDictionary.keys.forEach {
                    contentTypeDictionary[$0]?.forEach({ $0.isSelect = false
                    })
                }
            }
        }
    }
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Если тайтл не прилетает с прошлого VC - значит это стартовый VC и будет иметь тайтл Catalog Browser
        if title == "" {
            title = "Catalog Browser"
        }
        
        //изменяем имя тайтла на то, которое прилетело с предыдущего VC
        title = titleNewFolder
        
        //Добавляю для работы с ячейками tableView и collectionTableView
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
        
        collectionTableView.delegate = self
        collectionTableView.dataSource = self
        
        //указываю какое положение должен занимать свитчер
        switcherControl.selectedSegmentIndex = selectPositionSwitcher
        
        //регистрирую ячейки
        catalogTableView.register(UINib(nibName: "CatalogTableViewCell", bundle: nil), forCellReuseIdentifier: CatalogTableViewCell.key)
        catalogTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: ImageTableViewCell.key)
        
        collectionTableView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.key)
        collectionTableView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.key)
        
        barDeleteButtonItem.isHidden = true
        //Видимость таблицы в зависимости от положения свитчера
        selectPositionSwitcher == 0 ? (catalogTableView.isHidden = false) : (catalogTableView.isHidden = true)
        
        //MARK: - работа с объектами в каталоге
        
        //Проверяю какие папки внутри каталога и вношу в массив
        if startCatalogURL == nil {
            startCatalogURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            print(startCatalogURL)
        }
        
        do {
            //массив для хранения всех урлов объектов в каталоге
            arrayContent = try fileManager.contentsOfDirectory(at: startCatalogURL, includingPropertiesForKeys: .none)
            
            //массив всех объектов каталога без папки DS_Store
            let filteredArrayContent = arrayContent.filter {
                !$0.lastPathComponent.hasSuffix(".DS_Store")
            }
            //фильтру массив на массив папко и массив картинок
            let folderArray = filteredArrayContent.filter({ $0.hasDirectoryPath})
            let imageArray = filteredArrayContent.filter({ !$0.hasDirectoryPath})


                contentTypeDictionary[.folder] = folderArray.map({ContentFile(fileUrl: $0, fileType: .folder, isSelect: false)})
                contentTypeDictionary[.image] = imageArray.map({ContentFile(fileUrl: $0, fileType: .folder, isSelect: false)})
//            contentTypeDictionary.updateValue(contentFolderArray, forKey: .folder)
//            contentTypeDictionary.updateValue(contentImageArray, forKey: .image)
            
            
        } catch {
            return
        }
    }
    //MARK: - действие по кнопке удаления объекта в navigation bar
    
    @IBAction func barDeleteButtomItemPressed(_ sender: Any) {
        
        
        //массив для выделенных элементов
        let selectedItems = contentTypeDictionary.flatMap { $0.value
        }.filter { $0.isSelect }
        
        selectedItems.forEach { value in
            try? fileManager.removeItem(at: value.fileUrl)
            
    
            if let values = contentTypeDictionary[value.fileType], let itemURL = values.firstIndex(where: { content in
                value.fileUrl == content.fileUrl }) {
                
                contentTypeDictionary[value.fileType]?.remove(at: itemURL)
                
                self.catalogTableView.reloadData()
                self.collectionTableView.reloadData()
            }
        }

    }
    
    //MARK: - действие по кнопке check объекта в navigation bar
    @IBAction func barChekButtonItemPressed(_ sender: Any) {
        
        
        editState == .navigate ? (editState = .select) : (editState = .navigate)
        contentTypeDictionary.keys.forEach {
            contentTypeDictionary[$0]?.forEach { $0.isSelect = false}
        }
        
        self.catalogTableView.reloadData()
        self.collectionTableView.reloadData()
        
    }
    //MARK: - действие по кнопке добавления объекта в navigation bar
    @IBAction func barAddButtonItemPressed(_ sender: Any) {
        
        // alert для выбора действия
        let chooseActionAlertConttoller = UIAlertController(title: "Choose an action", message: "", preferredStyle: .alert)
        
        //MARK: - Выбрали создание директории
        
        //MARK: -Работа с алертами
        let directoryChooseButton = UIAlertAction(title: "Create a directory", style: .default) { _ in
            
            //Создаем алерт при выборе создания каталога
            let createNewCatalogAlertController = UIAlertController(title: "Create a new catalog", message: "Print a name", preferredStyle: .alert)
            
            //текст филд в алерте
            createNewCatalogAlertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Folder name"
            }
            
            //кнопка Ок в алерте
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: { [self] _ in
                
                //действие по кнопке Ок в алерте
                
                let textField = (createNewCatalogAlertController.textFields?[0] ?? UITextField()) as UITextField
                
                let catalogURL = self.startCatalogURL
                
                do {
                    
                    guard textField.hasText, var nameFolder = textField.text else {
                        
                        let emptyFieldErrorAlert = UIAlertController(title: "Error!", message: "Введите имя", preferredStyle: .alert)
                        
                        let okEmptyFieldButton = UIAlertAction(title: "Ok", style: .default)
                        
                        emptyFieldErrorAlert.addAction(okEmptyFieldButton)
                        
                        self.present(emptyFieldErrorAlert, animated: true)
                        return
                    }
                    //MARK: - Создание нового каталога
                    
                    //Убираю пробелы в названиях
                    nameFolder = nameFolder.trimmingCharacters(in: .whitespaces)
                    
                    //Добавляю в URL папки продолжение из текстового поля
                    let newCatalogURL = catalogURL?.appendingPathComponent("\(nameFolder)")
                    
                    guard let checkedNewCatalog = newCatalogURL else {return}
                    
                    //Создаю новую папку по новому URL
                    try self.fileManager.createDirectory(at: checkedNewCatalog, withIntermediateDirectories: false)
                   
                    
                    contentTypeDictionary[.folder]?.append(ContentFile(fileUrl: checkedNewCatalog, fileType: .folder, isSelect: false))
                    
                    //Обновляю данные для catalogTableView и collectionTableView
                    self.catalogTableView.reloadData()
                    self.collectionTableView.reloadData()
                    
                } catch {
                    
                    //Если попробуем создать папку с существующим именем выскочит алерт с ошибкой
                    let existErrorAlert = UIAlertController(title: "Error!", message: "Directory exists", preferredStyle: .alert)
                    
                    let okExistErrorButton = UIAlertAction(title: "Ok", style: .default)
                    
                    existErrorAlert.addAction(okExistErrorButton)
                    self.present(existErrorAlert, animated: true)
                }
                
                print("Text field: \(textField.text ?? "empty")")})
            
            //Кнопка cancel в алерте
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            print("direcory")
            
            //Добавляем кнопки в алерт при ошибке
            createNewCatalogAlertController.addAction(okButton)
            createNewCatalogAlertController.addAction(cancelButton)
            //презентуем сам алерт
            self.present(createNewCatalogAlertController, animated: true)
            
        }
        
        //MARK: - Выбрали создание картинки
        
        //Кнопка выбора создании картинки
        let imageChooseButton = UIAlertAction(title: "Create an image", style: .default) { _ in
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true //говорим, что оно редактируемое
            self.present(imagePicker, animated: true)
            
        }
        //Кнопка cancel в алерте
        let cancelChooseButton = UIAlertAction(title: "Cancel", style: .destructive)
        
        chooseActionAlertConttoller.addAction(directoryChooseButton)
        chooseActionAlertConttoller.addAction(imageChooseButton)
        chooseActionAlertConttoller.addAction(cancelChooseButton)
        
        present(chooseActionAlertConttoller, animated: true)
        
    }
    //MARK: - Работа со переключателем
    
    @IBAction func switcherControlPressed(_ sender: UISegmentedControl) {
        
        catalogTableView.isHidden = sender.selectedSegmentIndex == 0
        catalogTableView.isHidden = sender.selectedSegmentIndex != 0
        selectPositionSwitcher = sender.selectedSegmentIndex
        
        
    }
    
    //MARK: - Функция действия по тапу на ячейку
    func didTapAt(indexPath: IndexPath) {
        
        if let type = ContentTypeEnum(rawValue: indexPath.section),
           let value = contentTypeDictionary[type] {
            
            switch type {
            case .folder:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if let viewController = storyboard.instantiateViewController(withIdentifier: "Main") as? ViewController {
                    navigationController?.pushViewController(viewController, animated: true)
                    
                    navigationItem.backBarButtonItem = UIBarButtonItem(
                        title: "\(title ?? "Catalog Browser")", style: .plain, target: nil, action: nil)
                    
                    if selectPositionSwitcher == 1 {
                        viewController.selectPositionSwitcher = 1
                        
                    }
                    viewController.titleNewFolder = value[indexPath.row].fileUrl.lastPathComponent
                    viewController.startCatalogURL = value[indexPath.row].fileUrl
                    
                }
            case .image:
                let storyboard = UIStoryboard(name: "ImageStoryboard", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "ImageStoryboard") as? ImageViewController {
                    var imagesArray: [URL] = []
                    contentTypeDictionary[.image]?.forEach({ imagesArray.append($0.fileUrl)
                    viewController.urlForImage = imagesArray
                    })
                    present(viewController, animated: true)
                }
            }
        }
    }
    
}
//MARK: - Extension для работы с tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    //Определяем количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        
        contentTypeDictionary.count
    }
    
    //Количесвто ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let type = ContentTypeEnum(rawValue: section) {
            return contentTypeDictionary[type]?.count ?? 0
            
        }
        return 0
    }
    
    //Отображение ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let type = ContentTypeEnum(rawValue: indexPath.section),
           let value = contentTypeDictionary[type] {
            switch type {
                
            case .folder:
                if let catalogCell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.key) as? CatalogTableViewCell {
                    catalogCell.setSelected(indexPathArray.contains { $0 == indexPath },animated: true)
                    catalogCell.catalogCellLabel.text = value[indexPath.row].fileUrl.lastPathComponent
                    return catalogCell
                }
            case .image:
                
                if let ImageCell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.key) as? ImageTableViewCell {
                    ImageCell.contentImageView.image = UIImage(contentsOfFile: value[indexPath.row].fileUrl.path)
                    return ImageCell
                }
                
            }
        }
        
        return UITableViewCell()
    }
    
    //Высота ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}

//MARK: - Extension для работы с картинкой
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true)
    }
    
    //Действие при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let typeContent = ContentTypeEnum(rawValue: indexPath.section),
           let value = contentTypeDictionary[typeContent] {
            
            switch editState {
                
            case .navigate:
                
                didTapAt(indexPath: indexPath)
                tableView.deselectRow(at: indexPath, animated: true)
                
                print("\(indexPath)")
                
                self.collectionTableView.reloadData()
            case .select:
                
                value[indexPath.row].isSelect = true
                //deleteItemArray.append(value[indexPath.row])
                barDeleteButtonItem.isEnabled = true
                
                print("\(indexPath)")
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect\(indexPath)")
        
        if let typeContent = ContentTypeEnum(rawValue: indexPath.section),
           let value = contentTypeDictionary[typeContent] {
            
            value[indexPath.row].isSelect = false
            
            barDeleteButtonItem.isEnabled = true
            
            print("\(indexPath)")
            
        }
    }
    
    // Имя секций
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let typeName = ContentTypeEnum(rawValue: section),
           let name = contentTypeDictionary[typeName] {
            
            switch typeName {
                
            case .folder:
                if !name.isEmpty {return "folder"}
            case .image:
                if !name.isEmpty {return "image"}
            }
        }
        return ""
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("image selected")
        
        if let imageURL = info[.imageURL] as? URL,
           let editedImage = info[.editedImage] as? UIImage
        {
            
            let newImageURL = startCatalogURL.appendingPathComponent(imageURL.lastPathComponent)//берет последние символы после /
            let imageJPEGData = editedImage.jpegData(compressionQuality: 1)//от 0 до 1
            
            do {
                try imageJPEGData?.write(to: newImageURL)
                
                contentTypeDictionary[.image]?.append(ContentFile(fileUrl: newImageURL, fileType: .image, isSelect: false))
                
                //Обновляю данные для catalogTableView и collectionTableView
                self.catalogTableView.reloadData()
                self.collectionTableView.reloadData()
                
            } catch {
                print("Error")
            }
            dismiss(animated: true)
        }
    }
    
}

// MARK: - Extension для CollectionView
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        contentTypeDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let type = ContentTypeEnum(rawValue: section) {
            return contentTypeDictionary[type]?.count ?? 0
            
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let type = ContentTypeEnum(rawValue: indexPath.section),
           let value = contentTypeDictionary[type] {
            switch type {
                
            case .folder:
                if let collectionCell = collectionTableView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.key, for: indexPath) as? CollectionViewCell {

                    collectionCell.collectionViewLabel.text = value[indexPath.row].fileUrl.lastPathComponent
                    return collectionCell
                }
            case .image:
                if let collectionImageCell = collectionTableView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.key, for: indexPath) as? ImageCollectionViewCell {
                    collectionImageCell.collectionImageView.image = UIImage(contentsOfFile: value[indexPath.row].fileUrl.path)
                    return collectionImageCell
                    
                }
            }
        
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let typeContent = ContentTypeEnum(rawValue: indexPath.section),
           let value = contentTypeDictionary[typeContent] {
            
            switch editState {
                
            case .navigate:
                didTapAt(indexPath: indexPath)
                collectionView.deselectItem(at: indexPath, animated: true)
                //collectionView. deselectRow(at: indexPath, animated: true)
                print("\(indexPath)")
                
                self.collectionTableView.reloadData()
            case .select:
                value[indexPath.row].isSelect = true
                collectionTableView.allowsMultipleSelection = true
                barDeleteButtonItem.isEnabled = true
                self.catalogTableView.reloadData()
                print("\(indexPath)")
                
            }
    }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        indexPathArray = indexPathArray.filter { $0 != indexPath}
        self.catalogTableView.reloadData()    }
  
    
}

