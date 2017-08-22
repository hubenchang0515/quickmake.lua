# quickmake.lua
A simple script of Lua used to generate Makefile

## Demo : Generate Makeifle for Lua
### Script make.lua
```Lua

-- Set compiler and flags
SetCompiler("gcc")
SetFlags("-O2 -W -Wall -fPIC -DLUA_USE_LINUX")

-- link libreadline libm and libdl
AddLib("readline")
AddLib("m")
AddLib("dl")

-- files
AddFiles("lapi.c      lcorolib.c  ldump.c   llex.c      lopcodes.c  lstrlib.c  luac.c \
		lauxlib.c   lctype.c    lfunc.c   lmathlib.c  loslib.c    ltable.c   lundump.c \
		lbaselib.c  ldblib.c    lgc.c     lmem.c      lparser.c   ltablib.c  lutf8lib.c \
		lbitlib.c   ldebug.c    linit.c   loadlib.c   lstate.c    ltm.c      lvm.c \
		lcode.c     ldo.c       liolib.c  lobject.c   lstring.c   lua.c      lzio.c")

-- liblua.a
SetTarget.A("liblua.a","lapi.o      lcorolib.o  ldump.o   llex.o      lopcodes.o  lstrlib.o \
			lauxlib.o   lctype.o    lfunc.o   lmathlib.o  loslib.o    ltable.o   lundump.o \
			lbaselib.o  ldblib.o    lgc.o     lmem.o      lparser.o   ltablib.o  lutf8lib.o \
			lbitlib.o   ldebug.o    linit.o   loadlib.o   lstate.o    ltm.o      lvm.o \
			lcode.o     ldo.o       liolib.o  lobject.o   lstring.o   lzio.o")

-- lua
SetTarget.OUT("lua","lua.o liblua.a")

-- luac
SetTarget.OUT("luac","luac.o liblua.a")


```
### Execute
```Shell
$ quickmake make.lua 
$ make
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

### Add a file to compile
```Lua
AddFile(str)
```

### Add files to compile
```
AddFiles(str)
```

### Set final target
```Lua
-- target is executable file(.out)
SetTarget.OUT(target,depend)

-- target is shared object(.so)
SetTarget.SO(target,depend)

-- target is static library(.a)
SetTarget.A(target,depend) 
```

