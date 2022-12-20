extends Light2D

export(OpenSimplexNoise) var noise: OpenSimplexNoise
# Position on the noise texture
var noise_pos: float = 0.0
# Speed of the flickering light
export(int) var speed = 100

# In case the light gets rescaled in the editor
onready var original_scale = texture_scale

func _ready():
	noise_pos = rand_range(0, 1000)

func _process(delta):
	noise_pos = delta * speed
	texture_scale = original_scale + (noise.get_noise_1d(noise_pos) * original_scale) * 0.2
