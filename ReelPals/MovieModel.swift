import Foundation

struct MovieSearchResult: Decodable {
    let results: [Movie]
}

struct Movie: Identifiable, Decodable, Hashable {
    var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
    }
}
