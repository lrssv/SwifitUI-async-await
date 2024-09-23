import Foundation

enum NetworkError: Error {

    case badRequest
    case unexpected
    case parsingError
}

struct Post: Decodable {

    let title: String
}

class Continuation {

    static var shared = Continuation()

    func getPosts(completion: @escaping (Result<[Post], NetworkError>) -> Void) {
        guard let url = URL(string: "https://ember-sparkly-rule.glitch.me/current-date") else {
            completion(.failure(.unexpected))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.unexpected))
                return
            }

            if let result = try? JSONDecoder().decode([Post].self, from: data) {
                completion(.success(result))
            } else {
                completion(.failure(.parsingError))
            }
        }.resume()
    }

    func getPosts() async throws -> [Post] {
        return try await withCheckedThrowingContinuation { continuation in
            getPosts { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }

    func tryContinuation() {
        Task {
            do {
                let posts = try await getPosts()
                print(posts)
            } catch {
                print(error)
            }
        }
    }
}
