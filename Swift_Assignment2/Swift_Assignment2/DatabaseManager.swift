//
//  DatabaseManager.swift
//  Swift_Assignment2
//
//  Created by Dev Tech on 2025/08/01.
//

import Foundation
import FMDB // FMDBをインポート

class DatabaseManager {
    static let shared = DatabaseManager() // シングルトンインスタンス

    private let database: FMDatabase?

    private init() {
        // データベースファイルのパスを取得
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("tasks.sqlite")

        // FMDatabaseオブジェクトを初期化
        database = FMDatabase(url: fileURL)

        // データベースを開く
        if database?.open() == false {
            print("Error: データベースを開けませんでした。")
        }

        // テーブルを作成する
        createTable()
    }
    func addTask(title: String) -> Bool {
        guard let db = database else { return false }
        
        let sql = "INSERT INTO tasks (title, is_done) VALUES (?, ?)"
        
        do {
            // is_doneの初期値は0 (未完了)
            try db.executeUpdate(sql, values: [title, 0])
            print("タスクを追加しました: \(title)")
            return true
        } catch {
            print("タスクの追加に失敗しました: \(error.localizedDescription)")
            return false
        }
    }
    
    // ... addTask の後に追加 ...

    func fetchAllTasks() -> [Task] {
        guard let db = database else { return [] }
        
        let sql = "SELECT id, title, is_done FROM tasks"
        var tasks: [Task] = []
        
        do {
            let results = try db.executeQuery(sql, values: nil)
            
            // 取得したデータを1行ずつループ
            while results.next() {
                let id = Int(results.int(forColumn: "id"))
                let title = results.string(forColumn: "title") ?? ""
                let isDone = results.bool(forColumn: "is_done")
                
                let task = Task(id: id, title: title, isDone: isDone)
                tasks.append(task)
            }
        } catch {
            print("データの取得に失敗しました: \(error.localizedDescription)")
        }
        
        return tasks
    }
    
    // ... fetchAllTasks の後に追加 ...

    func updateTaskStatus(id: Int, isDone: Bool) -> Bool {
        guard let db = database else { return false }

        let sql = "UPDATE tasks SET is_done = ? WHERE id = ?"
        
        do {
            // isDoneがtrueなら1、falseなら0を保存
            try db.executeUpdate(sql, values: [isDone ? 1 : 0, id])
            print("タスクID: \(id) を更新しました。")
            return true
        } catch {
            print("タスクの更新に失敗しました: \(error.localizedDescription)")
            return false
        }
    }
    
    // ... updateTaskStatus の後に追加 ...

    func deleteTask(id: Int) -> Bool {
        guard let db = database else { return false }
        
        let sql = "DELETE FROM tasks WHERE id = ?"
        
        do {
            try db.executeUpdate(sql, values: [id])
            print("タスクID: \(id) を削除しました。")
            return true
        } catch {
            print("タスクの削除に失敗しました: \(error.localizedDescription)")
            return false
        }
    }
    
    // tasksテーブルを作成するメソッド
    private func createTable() {
        guard let db = database else { return }
        
        let sql = """
        CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            is_done INTEGER NOT NULL
        );
        """
        
        do {
            try db.executeUpdate(sql, values: nil)
            print("テーブルの準備ができました。")
        } catch {
            print("テーブル作成に失敗しました: \(error.localizedDescription)")
        }
    }
}
