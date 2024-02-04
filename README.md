# GodotVisionExample

An example Xcode project which has [GodotVision](https://github.com/multijam/GodotVision) as a package dependency, and an example Godot project in `Godot_Project`. 

## To Run

- Get the newest Xcode (15.2).
- Install the visionOS SDK when it asks you which platforms you'd like to deploy to.
- Clone this repository.
- Open `Godot_Project/project.godot` in Godot. (This is so that Godot's asset importers run.)
- Back in Xcode, set the target next to the play button to be Apple Vision Pro simulator.
- Hit play. You'll get an error that you need to "Trust and Enable" the macros in `SwiftGodot` and `SwiftGodotKit`. You may need to click the build error in the issues tab to enable them.
- Hit play again. The first build will be slow, since we need to compile SwiftGodot, which includes Swift bindings for all of Godot's gdextension API. Subsequent builds will be faster!

