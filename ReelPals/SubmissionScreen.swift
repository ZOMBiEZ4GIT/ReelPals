import SwiftUI

struct FilmSearchResult: Decodable {
    let results: [Film]
}

struct Film: Identifiable, Decodable, Hashable {
    var id: Int
    var title: String
    var overview: String
    var poster_path: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case poster_path // Match the JSON key exactly
    }
}

struct SubmissionScreenView: View {
    // Placeholder for the username (replace with actual username)
    let username = "USERNAME"
    let apiKey = "601e17d0b54e38258c8934c8c2fc2b32" // Your API key
    let baseURL = "https://api.themoviedb.org/3/search/movie"
    
    @State private var searchText = ""
    @State private var films: [Film] = []

    var body: some View {
        VStack {
            Text("Welcome \(username) to the Submission Screen")
            
            VStack(spacing: 20) {
                HStack {
                    TextField("Search for a film or TV show...", text: $searchText, onCommit: {
                        searchFilms(query: searchText) { results in
                            self.films = Array(Set(results)).sorted(by: { $0.title < $1.title })
                            print("Number of films received: \(self.films.count)")
                        }
                    })
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    
                    Button("Search") {
                        searchFilms(query: searchText) { results in
                            self.films = Array(Set(results)).sorted(by: { $0.title < $1.title })
                            print("Number of films received: \(self.films.count)")
                        }
                    }
                    .padding(.trailing)
                }
                .padding([.leading, .trailing])
                
                List(films, id: \.title) { film in
                    HStack {
                        if let poster_path = film.poster_path, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)") {
                            AsyncImageLoader(url: imageUrl)
                                .frame(width: 50, height: 75)
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 75)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(film.title)
                                .font(.headline)
                            Text(film.overview)
                                .font(.subheadline)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                    }
                }
                
                Spacer()
            }
            .padding([.top], 40)
            .background(Color.green.opacity(0.2)) // Temporary background color
        }
    }
    
    // Function to search for films
    func searchFilms(query: String, completion: @escaping ([Film]) -> Void) {
        guard let url = URL(string: "\(baseURL)?api_key=\(apiKey)&query=\(query)&sort_by=vote_count.desc") else { return }

        print("Fetching data from URL: \(url)")
        print("Initiating search for: \(query)")

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print("Received data from TMDb.")
            print("Received data: \(String(data: data, encoding: .utf8) ?? "No readable data")")

            do {
                let searchResult = try JSONDecoder().decode(FilmSearchResult.self, from: data)
                DispatchQueue.main.async {
                    completion(searchResult.results)
                }
            } catch {
                print("Data received: \(String(data: data, encoding: .utf8) ?? "No readable data")")
                print("Decoding error: \(error)")
                print("Error fetching films: \(error)")
            }
        }.resume()
    }

}

struct SubmissionScreen: View {
    var body: some View {
        SubmissionScreenView()
    }
}
// Test

