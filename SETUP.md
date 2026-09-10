ChromaSlide setup instructions

This folder contains SwiftUI source files only. It is not a ready made
Xcode project file, because hand writing an Xcode project file by hand
is unreliable and often fails to open correctly. Follow these steps
instead, they take about two minutes.

1. Open Xcode and choose File, New, Project.
2. Choose iOS, App, then Next.
3. Product Name: ChromaSlide. Interface: SwiftUI. Language: Swift.
4. Save it wherever you like. Xcode creates a starter project with a
   default ChromaSlideApp.swift and ContentView.swift already inside.
5. In Finder, delete the starter ChromaSlideApp.swift and ContentView.swift
   that Xcode generated (you will replace them with the versions in this
   folder).
6. Drag the entire contents of the ChromaSlide folder from this zip
   (ChromaSlideApp.swift, ContentView.swift, Models, Views, Extensions)
   into your Xcode project navigator. When prompted, check "Copy items
   if needed" and make sure your app target is checked.
7. Build and run on a simulator or device (iOS 17 or later recommended
   for the newer SwiftUI syntax used here).

That is it, no extra dependencies or packages required.
