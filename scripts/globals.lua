global = {}

global.is_dev = true -- If you are building on Defold Editor then set it true. If you are bundling set it false
global.build_path = "" -- Full path for building on Defold Editor when developing: "<FULL_PATH>/res/common/assets/"
global.TOUCH = hash("touch")

return global