# articy-to-nylon-conversion-tool
Parses an Articy JSON export and translates it into a NylonScene.tscn.

Requires Nylon for Godot, by TheDuriel. Tested on Nylon version 0.18.0.
> [!WARNING]
> This tool isn't finished yet, and a lot of features are still broken / not implemented!
>
> This repo is only public so that I can easily share it - this tool does not yet have any official release and you probably shouldn't use it until it gets one. Who knows what broken nonsense I'm going to commit to main before then?

## Example Usage

This tool allows you to design and organize a complex dialogue scene within Articy (including divergant and convergant branches, nested sub-scenes, global variables, conditions...) that might look something like this:

<details>
<summary>Articy Flow Example</summary>

![A crudely annotated collection of screenshots illustrating the relationship between nested nodes in an example Articy Flow.](/assets/images/articy_flow_example.png)
</details>

...and automatically convert that scene into a packed NylonScene.tscn file, which might look like this:

<details>
<summary>NylonScene Example</summary>
    
![A screenshot of the Godot SceneTree, with a NylonScene as its root, representing the same scene logic as the previous image but translated into NylonNodes](/assets/images/nylon_scene_example.png)
</details>

## Installation

### Articy
1. Save the **_/articy-templates-for-nylon/_** directory somewhere sensible. (NOT inside your Godot project directory.)
2. Launch _Articy:Draft X_ and select _**open from file**_ on the project selection screen.
3. Navigate to **_/articy-templates-for-nylon/_** and select _**ProjectInfo.aph**_.
4. Right click the newly added project, and select _**clone project**_. Use this copy as the foundation of your own project.
> [!IMPORTANT]
> Articy, by design, is unable to import new templates into an existing project. This is why a pre-configured project is included in this repo. I intend to replace this with a script to auto-genrate the templates using the Articy Dev API, at some point.
>
> If you would like to use this tool with an existing project, you must create the templates yourself. Make sure that the names, technical names, and properties of the templates you create are identical to those in the pre-configured project; otherwise, the parser will fail.
>
> _ArticyData.gd_ contains the list of template names this tool expects to recieve. It will also indicate the ArticyResource-derived Class that defines any non-default properties that the template is expected to have.

### Godot
1. Copy the _/NylonContent_ directory from _/godot-project-files_ into the root directory of your own Godot project.
> [!IMPORTANT]
> Make sure you've installed Nylon itself first, following all the instructions (don't forget to set _Nylon.gd_ as an autoloaded class within the _Globals_ tab of the _Project Settings_ menu.)


## Usage

### Articy
1. Open your Articy project, then open the _**Export dialogue**_ (Crtl + Shift + E).
2. Scroll down to _Technical exports_ and select _**.json**_.
3. In the panel labelled "_Which top-level nodes should be created in the json file_", tick the following checkboxes: _**GlobalVariables**_, _**ObjectDefinitions**_, and _**Packages**_.
4. Initiate the export by clicking **_OK_**. Ensure that your export includes the following files:
    - package_*_objects.json
    - package_*_localization.json
    - object_definitions.json
    - object_definitions_localization.json
    - global_variables.json
3. Copy these files into your Godot project directory, into the folder **_/NylonContent/Articy/JSON Exports/_**

### Godot
1. Navigate to **_/NylonContent/Articy/Converter/_** within your Godot project directory.
2. Open _**ArticyNylonConverter.tscn**_ and select the node in the inspector.
3. Run the currently active scene (while _**ArticyNylonConverter.tscn**_ is active.)
