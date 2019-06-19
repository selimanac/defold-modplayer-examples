# Defold Mod Player Examples

![Mod Player](https://github.com/selimanac/defold-modplayer-examples/blob/master/assets/ScreenShot.png?raw=true)

## Settings

Don't forget to set your files path in [scripts/globals.lua](https://github.com/selimanac/defold-modplayer-examples/blob/master/scripts/globals.lua) for [player.build_path(full_path:string)](https://github.com/selimanac/defold-modplayer#api)

```lua
global = {}

global.is_dev = true -- If you are building on Defold Editor then set it true. If you are bundling set it false
global.build_path = "" -- Full path for building on Defold Editor when developing: "<FULL_PATH>/res/common/assets/"
global.TOUCH = hash("touch")

return global
```

### Mod Player
https://github.com/selimanac/defold-modplayer