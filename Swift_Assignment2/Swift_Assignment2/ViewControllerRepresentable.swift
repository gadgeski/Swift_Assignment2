//
//  ViewControllerRepresentable.swift
//  Swift_Assignment2
//
//  Created by Dev Tech on 2025/08/02.
//

import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {

    // このメソッドで、表示したいUIKitのViewControllerを生成して返します。
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    // SwiftUI側でビューの更新があった場合に呼ばれるメソッドです。
    // 今回は特に何もしないので、中身は空のままでOKです。
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // 例: SwiftUIからViewControllerへデータを渡したい場合などに使います。
    }
}
