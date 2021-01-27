//
//  CreateCastle.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

protocol CreateCastle {
  func execute() -> Result<Void, CastlesError>
}

final class CreateCastleAdapter: CreateCastle {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  private let dependencies: Dependencies
  private let castleNames: [String] = [
    "Galadhor Stronghold",
    "Stormholme Hold",
    "Redford Fort",
    "Earnside Palace",
    "Seanton Castle",
    "Yarlmouth Hold",
    "Stappleton Stronghold",
    "Warlton Castle",
    "Ely Castle",
    "Hewgill Keep",
    "Sangeries Castle",
    "Wardhurst Hold",
    "Gundor Fortress",
    "Scatterby Fort",
    "Goulpass Hold",
    "Lakewell Stronghold",
    "Bellton Keep",
    "Waernell Fortress",
    "Cadworth Fort",
    "Corftey Keep"
  ]
  private let castleImageNames: [String] = [
    "castle1",
    "castle2",
    "castle3",
    "castle4"
  ]
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> Result<Void, CastlesError> {
    let name = castleNames.randomElement() ?? ""
    let imageName = castleImageNames.randomElement() ?? ""
    do {
      try dependencies.kingdomService.modifyGoldWith(quantity: -Kingdom.newCastlePrice)
      dependencies.kingdomService.createCastle(withName: name, imageName: imageName)
      return .success(())
    } catch {
      return .failure(error as? CastlesError ?? .unknown)
    }
  }
}
