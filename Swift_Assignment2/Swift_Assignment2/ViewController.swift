//
//  ViewController.swift
//  Swift_Assignment2
//
//  Created by Dev Tech on 2025/08/01.
//

import UIKit

// class宣言を修正
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // viewDidLoadでデリゲートを設定
    // tableView.delegate = self

    private var tasks: [Task] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Delegateを設定
        // 追加した行
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        loadTasks()
        
        // DatabaseManagerを初期化
        let _ = DatabaseManager.shared
    }

    private func setupUI() {
        // ... ここにUI（TableViewや追加ボタンなど）のセットアップコードを書く ...
        // 例:
        tableView.frame = view.bounds
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    private func loadTasks() {
        // データベースからタスクを読み込む
        tasks = DatabaseManager.shared.fetchAllTasks()
        // テーブルを更新
        tableView.reloadData()
    }

    // UITableViewDelegate のメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var task = tasks[indexPath.row]
        // isDoneの状態を反転させる
        task.isDone.toggle()
        
        // データベースを更新
        let success = DatabaseManager.shared.updateTaskStatus(id: task.id, isDone: task.isDone)
        
        if success {
            // 画面も更新
            loadTasks()
        }
    }
    // MARK: - UITableViewDataSource

    // 1. 各セクションの行数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 表示したい行の数（今回はタスクの数）を返す
        return tasks.count
    }

    // 2. 各行のセルを構成するメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "cell"という識別子で再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 表示するタスクを取得する
        let task = tasks[indexPath.row]
        
        // セルの内容を設定する
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        
        // タスクが完了していればチェックマークを表示する
        if task.isDone {
            content.image = UIImage(systemName: "checkmark")
        } else {
            content.image = nil
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    // ... cellForRowAt の後に追加 ...

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            
            // データベースから削除
            let success = DatabaseManager.shared.deleteTask(id: taskToDelete.id)
            
            if success {
                // 配列から削除し、テーブルの行も削除
                tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
