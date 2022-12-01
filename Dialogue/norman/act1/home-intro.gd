extends Resource

const dialogue = [
  {
    "Name": "Norman",
    "Text": "Well, I've arrived, not much to do left but unpack and sleep through the night, it's pretty late.",
    "Speaking": "left",
    "PortraitLeft": "norman-a",
    "PortraitRight": "",
    "ShowExtraInfo": "",
    "Choice": false
  },
  {
    "Name": "Norman",
    "Text": "My room's upstairs, best get to it.",
    "Speaking": "left",
    "PortraitLeft": "norman-a",
    "PortraitRight": "",
    "ShowExtraInfo": "",
    "Choice": false
  },
  {
    "Name": "Narrator",
    "Text": "As you walk up the stairs a red glow becomes visible trough the window.",
    "Speaking": "left",
    "PortraitLeft": "norman-e",
    "PortraitRight": "",
    "ShowExtraInfo": "",
    "Choice": false
  },
  {
    "Name": "Norman",
    "Text": "That's odd, perhaps it's related to the goings on in the town.",
    "Speaking": "left",
    "PortraitLeft": "norman-b",
    "PortraitRight": "",
    "ShowExtraInfo": "",
    "Choice": true,
    "Choice1": ["Investigate, the town's more important than my sleep schedule.", "dialogue_event", "MoveOut"],
    "Choice2": ["Not much can be done, Imma sleep.", "dialogue_event", "Sleep"]
  }
]
