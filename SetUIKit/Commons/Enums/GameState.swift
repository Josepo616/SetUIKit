//
//  GameState.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/17/25.
//

import Foundation

enum GameState {
    case notStarted     // El juego no ha comenzado.
    case started        // El juego ha comenzado y está en curso.
    case paused         // El juego está pausado.
    case lost           // El jugador ha perdido.
    case completed      // El juego ha terminado exitosamente.
    case skipped        // El jugador ha saltado una ronda o acción.
}
