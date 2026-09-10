ChromaSlide

Overview

ChromaSlide is an original iOS puzzle game built with SwiftUI by Ayush Jaiswal. It takes the familiar feel of a sliding tile puzzle and replaces the usual number doubling mechanic with paint mixing. Tiles carry colors instead of numbers. When two tiles of the same color collide they merge and grow stronger. When two different colors collide they blend into a brand new color, following a small mixing graph inspired by how paint actually works, such as red and yellow becoming orange, or blue and purple becoming indigo.

Gameplay

The board is a four by four grid. Swipe up, down, left, or right to slide every tile in that direction. A rotating target color is shown at the top of the screen. Producing a tile of that color during a merge awards a bonus and a new target is chosen. The game ends when the board is completely full and no two neighboring tiles can merge in any direction, either by matching color or by a valid paint recipe.

What makes it original

Every color, every mixing recipe, the scoring rules, the target color objective, and the visual design were designed from scratch for this project. There is no shared codebase with any other project.

Project structure

ChromaSlideApp.swift is the SwiftUI app entry point.
ContentView.swift wires up gestures and lays out the screen.
Models holds Tile.swift, ColorMixer.swift, and GameViewModel.swift, which together contain the game state and all of the sliding and merging logic.
Views holds GridView.swift, TileView.swift, and HeaderView.swift, the visual components.
Extensions holds Color+Hex.swift, a small helper for turning hex codes into SwiftUI colors.

Requirements

Xcode 15 or later and iOS 17 or later as the deployment target, since the project uses recent SwiftUI syntax.

Setup

See SETUP.md in this repository for step by step instructions on creating a new Xcode project and adding these source files to it.

License

This project is offered under the MIT License. See LICENSE for details.
