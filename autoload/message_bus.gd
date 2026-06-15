extends Node

@warning_ignore_start("unused_signal")

signal level_changed(new_level: SceneAccess.Levels)
## Sent by: Weapon
## Recieved by: Level
## Triggers a bullet to spawn
signal bullet_spawned(pos: Vector2, dir: Vector2, data: BulletData)
