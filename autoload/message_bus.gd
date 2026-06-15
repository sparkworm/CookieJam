extends Node

@warning_ignore_start("unused_signal")

## Sent by: UI items, Level (on completion)
## Recieved by: Main
## Changes the active level (can include non-playable levels like main menu)
signal level_changed(new_level: SceneAccess.Levels)
## Sent by: Weapon
## Recieved by: Level
## Triggers a bullet to spawn
signal bullet_spawned(pos: Vector2, dir: Vector2, data: BulletData)
