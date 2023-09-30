import SwiftUI

struct AsyncImageLoader: View {
    @State private var imageData: Data?
    let url: URL

    var body: some View {
        Group {
            if let data = imageData, let nsImage = NSImage(data: data) {
                Image(nsImage: nsImage)
                    .resizable()
            } else {
                // Placeholder till the image loads
                Rectangle()
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }
        .resume()
    }
}

struct AsyncImageLoader_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageLoader(url: URL(string: "https://example.com/image.jpg")!)
    }
}
