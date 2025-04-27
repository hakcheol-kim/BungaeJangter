//
//  UserResponse.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import Foundation
import Combine

struct Address: Codable {
    struct Coordinates: Codable {
        var lat: Double
        var lng: Double
        
        enum CodingKeys: CodingKey {
            case lat
            case lng
        }
        init(lat: Double = 0, lng: Double = 0) {
            self.lat = lat
            self.lng = lng
        }
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Address.Coordinates.CodingKeys> = try decoder.container(keyedBy: Address.Coordinates.CodingKeys.self)
            self.lat = try container.decodeIfPresent(Double.self, forKey: Address.Coordinates.CodingKeys.lat) ?? 0
            self.lng = try container.decodeIfPresent(Double.self, forKey: Address.Coordinates.CodingKeys.lng) ?? 0
        }
    }
    var address: String  //"1814 Cedar Street",
    var city: String  //"Charlotte",
    var state: String  //"Indiana",
    var stateCode: String  //"IN",
    var postalCode: String  //"21191",
    var coordinates: Coordinates
    var country: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.stateCode = try container.decodeIfPresent(String.self, forKey: .stateCode) ?? ""
        self.postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode) ?? ""
        self.coordinates = try container.decodeIfPresent(Address.Coordinates.self, forKey: .coordinates) ?? Address.Coordinates()
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
    }
}

struct Hair: Codable {
    var color: String
    var type: String

    enum CodingKeys: CodingKey {
        case color
        case type
    }
    init(color: String = "", type: String = "") {
        self.color = color
        self.type = type
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try container.decodeIfPresent(String.self, forKey: .color) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
    }
}
struct UserInfo: Codable, Equatable, Hashable {
    var id: Int
    var firstName: String
    var lastName: String
    var maidenName: String
    var age: Int
    var gender: String
    var email: String
    var phone: String
    var username: String
    var password: String
    var birthDate: String
    var image: String
    var bloodGroup: String
    var height: Double
    var weight: Double
    var eyeColor: String
    var hair: Hair?
    var ip: String
    var address: Address?
    var university: String
    
    //이름, 나이, 성별, 생년월일, 전화번호 같으면 동일 명으로 간주 제거
    func hash(into hasher: inout Hasher) {
        hasher.combine(firstName)
        hasher.combine(maidenName)
        hasher.combine(age)
        hasher.combine(gender)
        hasher.combine(birthDate)
        hasher.combine(phone)
    }
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.firstName == rhs.firstName &&
                lhs.maidenName == rhs.maidenName &&
                lhs.age == rhs.age &&
                lhs.gender == rhs.gender &&
                lhs.birthDate == rhs.birthDate &&
                lhs.phone == rhs.phone
        )
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.maidenName = try container.decodeIfPresent(String.self, forKey: .maidenName) ?? ""
        self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        self.birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate) ?? ""
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.bloodGroup = try container.decodeIfPresent(String.self, forKey: .bloodGroup) ?? ""
        self.height = try container.decodeIfPresent(Double.self, forKey: .height) ?? 0
        self.weight = try container.decodeIfPresent(Double.self, forKey: .weight) ?? 0
        self.eyeColor = try container.decodeIfPresent(String.self, forKey: .eyeColor) ?? ""
        self.hair = try container.decodeIfPresent(Hair.self, forKey: .hair)
        self.ip = try container.decodeIfPresent(String.self, forKey: .ip) ?? ""
        self.address = try container.decodeIfPresent(Address.self, forKey: .address)
        self.university = try container.decodeIfPresent(String.self, forKey: .university) ?? ""
    }
}

struct UserResponse: Codable {
    var users: [UserInfo]
    var total: Int
    var limit: Int
    var skip: Int
    
    enum CodingKeys: CodingKey {
        case users
        case total
        case limit
        case skip
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.users = try container.decodeIfPresent([UserInfo].self, forKey: .users) ?? []
        self.total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit) ?? 0
        self.skip = try container.decodeIfPresent(Int.self, forKey: .skip) ?? 0
    }
}

/*
    "id": 31,
    "firstName": "Gabriel",
    "lastName": "Adams",
    "maidenName": "",
    "age": 36,
    "gender": "male",
    "email": "gabriel.adams@x.dummyjson.com",
    "phone": "+91 936-400-4116",
    "username": "gabriela",
    "password": "gabrielapass",
    "birthDate": "1988-9-5",
    "image": "https://dummyjson.com/icon/gabriela/128",
    "bloodGroup": "B+",
    "height": 181.72,
    "weight": 79.14,
    "eyeColor": "Green",
    "hair": {
      "color": "Blonde",
      "type": "Curly"
    },
    "ip": "22.129.163.106",
    "address": {
      "address": "1814 Cedar Street",
      "city": "Charlotte",
      "state": "Indiana",
      "stateCode": "IN",
      "postalCode": "21191",
      "coordinates": {
        "lat": 52.410844,
        "lng": 23.60067
      },
      "country": "United States"
    },
    "macAddress": "a6:1e:22:5f:fd:49",
    "university": "Massachusetts Institute of Technology (MIT)",
    "bank": {
      "cardExpire": "03/27",
      "cardNumber": "3430117055178040",
      "cardType": "RuPay",
      "currency": "GBP",
      "iban": "8CWPTN20RQPDSYBIFFBKST0Y"
    },
*/
