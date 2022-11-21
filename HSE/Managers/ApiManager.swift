//
//  ApiManager.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 21.11.2022.
//

import Foundation

extension URLSession {
    func dataTask(
        with url: URL,
        result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

struct Users : Codable {
    let name: String
}


enum APIServiceError: Error {
    case apiError
    case invalidEndPoint
    case invalidResponse
    case noData
    case decodeError
}

protocol EndPoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String : Any]? { get }
    var body: [String: Any]? { get }
}

extension EndPoint {
    var url: String {
        return baseURLString + path
    }
}

enum EndPointCases: EndPoint {
    case getSampleAPIResponse(_ city: String) // sample
    case postSampleAPIResponse
    
    var httpMethod: String {
        switch self {
        case .getSampleAPIResponse:
            return "GET"
        case .postSampleAPIResponse:
            return "POST"
        }
    }
    
    var baseURLString: String {
        // return "main base url"
        switch self {
            //
        case .getSampleAPIResponse:
            // ваш урл api
            return "https://"
        case .postSampleAPIResponse:
            return "https://"
        }
    }
    
    var path: String {
        switch self {
        case .getSampleAPIResponse(let city):
            // ваш endpoint у api
            return "\(city)"
        case .postSampleAPIResponse:
            return "post"
        }
    }
    
    var headers: [String : Any]? {
        return [
            "Content-Type": "application/json",
            // "authorization": "1234"
            // other headers
        ]
    }
    
    var body: [String : Any]? {
        switch self {
        case .postSampleAPIResponse:
            return [:]
        default:
            return [:]
        }
    }
    
}

protocol ApiManagerWeatherProtocol {
    func getUsers(
        from city: String,
        completion: @escaping (Result<Users, APIServiceError>) -> Void
    )
}

class ApiManagerWeather: ApiManagerWeatherProtocol {
    private func request<T: Codable>(
        _ endpoint: EndPointCases,
        completion: @escaping (Result<T, APIServiceError>) -> Void
    ) {
        guard let url = URL(string: endpoint.url) else {
            return
        }
        URLSession.shared.dataTask(with: url) { result in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                // добавить проверку на 400 и 500 ошибки
                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    func getUsers(
        from city: String,
        completion: @escaping (Result<Users, APIServiceError>) -> Void
    ) {
        request(.getSampleAPIResponse(city)) { (result: Result<Users, APIServiceError>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}


//class APIFetcher {
//
//    func getNews() {
//        guard let url = URL(string: "https:\\") else {
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                let modelTemp = try? JSONDecoder().decode(Users.self, from: data)
//                print(modelTemp?.name)
//                do {
//                    let model = try JSONDecoder().decode(Users.self, from: data)
//                    print(model)
//                } catch (let error) {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//
//}
// ДЗ
//
//protocol RequestBuilder {
//    func request<T>(
//        _ endpoint: EndPoint,
//        completion: @escaping (Result<T, APIServiceError>) -> Void
//    )
//}
//
//extension RequestBuilder {
//    func request<T>(
//        _ endpoint: EndPoint,
//        completion: @escaping (Result<T, APIServiceError>) -> Void
//    ) where T: Codable {
//        guard let url = URL(string: endpoint.url) else {
//            return
//        }
//
//        // query params
////        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
////            completion(.failure(.invalidEndPoint))
////            return
////        }
////
////        if let queryItems = queryItems {
////            var query = [URLQueryItem]()
////            for (key, value) in queryItems {
////                query.append(URLQueryItem(name: key, value: value))
////            }
////            urlComponents.queryItems = query
////        }
//
//        var urlRequest = URLRequest(url: url)
//
//        urlRequest.httpMethod = endpoint.httpMethod
//
//        endpoint.headers?.forEach({ header in
//            urlRequest.setValue(
//                header.value as? String,
//                forHTTPHeaderField: header.key
//            )
//        })
//
//        URLSession.shared.dataTask(with: url) { result in
//            switch result {
//            case .success(let (response, data)):
//                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
//                    completion(.failure(.invalidResponse))
//                    return
//                }
//                do {
//                    let data = try JSONDecoder().decode(T.self, from: data)
//                    completion(.success(data))
//                } catch {
//                    completion(.failure(.decodeError))
//                }
//            case .failure(_):
//                completion(.failure(.apiError))
//            }
//        }.resume()
//    }
//}
