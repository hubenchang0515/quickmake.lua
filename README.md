# quickmake.lua
A simple script of Lua used to generate Makefile

## Demo 
```Lua
-- filename : make.lua
SetCompiler("clang++")
SetFlags("-W -Wall -O2 -std=c++11")

-- libs depend , will be linked by -l
AddLib("SDL2")
AddLib("SDL2_image")

-- source files , will be compiled to .o
AddFile("main.cpp")
AddFile("file1.cpp")
AddFile("file2.cpp")

-- set final target
SetTarget.OUT("main","main.o file1.o file2.o")

```

## Instruction

### Set compiler 
```Lua
SetCompiler(str)
```
 
### Set compiler's flags
```Lua
SetFlags(str)
```
 
### Add library to link  
```Lua
AddLib(str)
```

### Add file to compile
```Lua
AddFile(str)
```

### Set final target
```Lua
-- target is executable file(.out)
SetTarget.OUT(target,depend)

-- target is shared object(.so)
SetTarget.SO(target,depend)

-- target is static library(.s)
SetTarget.A(target,depend) 
```

