# quickmake.lua
A simple script of Lua used to generate Makefile

## Demo : Generate Makeifle for Lua
### Script make.lua
```lua
#! /usr/bin/env lua

-- 导入
qm = require("quickmake")

-- 源文件列表
sourceFiles = {"lapi.c","lcorolib.c", "ldump.c", "llex.c", "lopcodes.c", "lstrlib.c", "luac.c",
		"lauxlib.c", "lctype.c", "lfunc.c", "lmathlib.c", "loslib.c", "ltable.c", "lundump.c",
		"lbaselib.c", "ldblib.c", "lgc.c", "lmem.c", "lparser.c", "ltablib.c", "lutf8lib.c",
		"lbitlib.c", "ldebug.c", "linit.c", "loadlib.c", "lstate.c", "ltm.c", "lvm.c",
		"lcode.c", "ldo.c", "liolib.c", "lobject.c", "lstring.c", "lua.c", "lzio.c"}
        
-- 库文件依赖列表
libDependFiles = {"lapi.o", "lcorolib.o", "ldump.o", "llex.o", "lopcodes.o", "lstrlib.o",
			"lauxlib.o", "lctype.o", "lfunc.o", "lmathlib.o", "loslib.o", "ltable.o", "lundump.o",
			"lbaselib.o", "ldblib.o", "lgc.o", "lmem.o", "lparser.o", "ltablib.o", "lutf8lib.o",
			"lbitlib.o", "ldebug.o", "linit.o", "loadlib.o", "lstate.o", "ltm.o", "lvm.o",
			"lcode.o", "ldo.o", "liolib.o", "lobject.o", "lstring.o", "lzio.o"}

-- 初始化并设置编译器及选项
qm:init()
qm:setCompiler("gcc")
qm:setCompileFlags("-O2 -W -Wall -fPIC")
qm:setLinkFlags("-llua -L.")

-- 设置源文件
qm:setSource(sourceFiles)

-- 添加静态库目标
qm:addATarget("liblua.a", libDependFiles)

-- 添加可执行文件目标
qm:addOutTarget("lua", {"lua.o", "liblua.a"})
qm:addOutTarget("luac", {"luac.o", "liblua.a"})

-- 输出Makefile
qm:output()

```

### Execute
```bash
./make.lua
make
```

## APIs
```Lua
quickmake:init()

quickmake:output(file="Makefile")

quickmake:setCompiler(compiler)

quickmake:setCompileFlags(flags)

quickmake:setLinkFlags(flags)

quickmake:setSource(files)

quickmake:addATarget(target, files)

quickmake:addSoTarget(target, files)

quickmake:addOutTarget(target, files)
```
