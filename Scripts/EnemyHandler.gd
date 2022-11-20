extends Node2D

onready var easy_enemy = preload("res://Scenes/Enemie1.tscn")
onready var medium_enemy = preload("res://Scenes/Enemie2.tscn")
var count = 0

signal send_challange_and_answer(challenge, answer)

var enemiesCreated = 0
var level = 1

#############################
# Spawn de mobs
#############################

func _ready():
	pass

var levelChallenges = {
	0 : {
	"4 - 2": "2",
	"5 + 2": "7",
	"2 + 2": "4",
	"10 + 2": "12",
	"7 + 4": "11",
	"80 + 9": "89",
	"13 + 7": "20",
	"9 - 4": "5",
	"14 - 1": "13",
	"13 + 1": "14",
	"10 - 9": "1",
	"10 - 7": "3",
	"8 - 2": "6",
	"90 - 2": "88",
	"87 - 3": "84"},
	1 : {
	"3 x 18": "54",
	"66 / 6": "11",
	"2 x 4": "8",
	"2 x 15": "30",
	"80 / 4": "20",
	"3 x 3": "9",
	"4 x 4": "16",
	"9 x 2": "18",
	"10 / 2": "5",
	"21 / 3": "7"},
	2 : {
	"√9": "3",
	"3**3": "27",
	"12**2": "144",
	"√16": "4",
	"√25": "5"
	}
}

var rng = RandomNumberGenerator.new()
var n = rng.randomize()

func defineRandomChallenge(challenges_collection, level) -> Array:
	var randomLevel = floor(rng.randf_range(0, level + 1))	
	if(randomLevel > level - 1): randomLevel = level - 1
	
	var levelChoice = challenges_collection.values()[randomLevel]	
	
	var challengeIndex = floor(rng.randf_range(0, levelChoice.size()))	
	
	var challenge = levelChoice.keys()[challengeIndex]
	var answer = levelChoice.values()[challengeIndex]
	
	return [challenge, answer, randomLevel + 1]


func newEnemy(typeOfEnemy):
	count += 1
	var newEnemy = typeOfEnemy.instance()
	newEnemy.name = 'enemy'

	self.add_child(newEnemy)	


func _on_Timer_timeout():
		var random_challenge = defineRandomChallenge(levelChallenges, level)
		var challenge = random_challenge[0]
		var answer = random_challenge[1]
		var levelEnemy = random_challenge[2]
		
		emit_signal("child_entered_tree")
		
		if(levelEnemy == 1): 
			newEnemy(easy_enemy)
		else: 
			newEnemy(medium_enemy)
		
		emit_signal("send_challange_and_answer", challenge, answer)
		
		if(enemiesCreated == 15 && level < 2):
			print("Level Changed")
			level += 1
			enemiesCreated = 0	
		else: 
			enemiesCreated += 1	
			
