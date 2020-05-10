#!/usr/bin/env lua

--[[
E-Mail : hubenchang0515@outlook.com
Blog   : blog.kurukurumi.com
MIT License
Copyright (c) 2017 Plan C
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

-- 私有函数

-- list转换成string
local function list2string(files)
    local filesString = ""
    if type(files) == "string" then
        filesString = files
    elseif type(files) == "table" then
        local count = 0
        for i, file in ipairs(files) do
            filesString = filesString .. " " .. file
            count = count + 1
            if count >=7 then
                filesString = filesString .. " \\\n"
                count = 0
            end
        end
    else
        return ""
    end
    
    return filesString
end

-- 生成源文件的编译规则
-- file : 源文件,例如 "main.c"
local function makeSourceRule(file, compiler, flags)
    local cmd = compiler .. " -MM " .. file
    local fp = io.popen(cmd)

    if fp == nil then
        print("Failed : " .. cmd)
        return nil
    end
    
    local depend = fp:read("a")
    fp:close()
    
    if string.len(depend) == 0 then
        print("Failed : " .. cmd)
        return nil
    end
    
    cmd = string.format("\t%s %s -c %s \n", compiler, flags, file)
    local rule = depend .. cmd
    return rule
end


-- 生成静态库的编译规则
-- target : 目标文件,例如 "liblua.a"
-- files : 依赖文件列表,例如 "lapi.o lfunc.o"
local function makeATargetRule(target, files)
    -- 类型转换
    local filesString = list2string(files)
    
    local depend = string.format("%s: %s\n", target, filesString)
    local cmd = string.format("\t$(AR) rcs %s %s\n", target, filesString)
    local rule = depend .. cmd
   
    return rule
end

-- 生成动态库的编译规则
-- target : 目标文件,例如 "liblua.so"
-- files : 依赖文件列表,例如 "lapi.o lfunc.o"
local function makeSoTargetRule(target, files, compiler, flags)
    -- 类型转换
    local filesString = list2string(files)
    
    local depend = string.format("%s: %s\n", target, filesString)
    local cmd = string.format("\t%s %s -shared -o %s %s\n", compiler, flags, target, filesString)
    local rule = depend .. cmd
   
    return rule
end

-- 生成.out文件的编译规则
-- target : 目标文件,例如"a.out"
-- files : 依赖文件列表, 例如 "main.o liblua.a"
local function makeOutTargetRule(target, files, compiler, flags)
    -- 类型转换
    local filesString = list2string(files)
    
    local depend = string.format("%s: %s\n", target, filesString)
    local cmd = string.format("\t%s -o %s %s %s\n", compiler, target, filesString, flags)
    local rule = depend .. cmd
    
    return rule
end


-- 导出接口
-- 创建一个table来返回对象
local quickmake = {}


-- 初始化
function quickmake:init()
    self.compiler = "gcc"
    self.compile_flags = "-O2 -W -Wall -std=c99"
    self.link_flags = ""
    
    self.SOURCE = {}
    self.OUT_TARGET = {} -- key为目标  value为依赖列表(table)
    self.SO_TARGET = {}
    self.A_TARGET = {}
end

-- 输出文件
function quickmake:output(file)
    file = file or "Makefile"
    fp = io.open(file,"w")
    
    -- 伪目标
    fp:write(".PHONY: all clean\n\n")
    fp:write("all:")
    for target in pairs(self.OUT_TARGET) do
        fp:write(target, " ")
    end
    for target in pairs(self.SO_TARGET) do
        fp:write(target, " ")
    end
    for target in pairs(self.A_TARGET) do
        fp:write(target, " ")
    end
    fp:write("\n\n")
    fp:write("clean:\n")
    fp:write("\t$(RM) *.o\n\n")
    
    
    -- out文件
    for target, files in pairs(self.OUT_TARGET) do
        local rule = makeOutTargetRule(target, files, self.compiler, self.link_flags)
        fp:write(rule, "\n")
        print(rule)
    end
    
    -- 静态库
    for target, files in pairs(self.A_TARGET) do
        local rule = makeATargetRule(target, files)
        fp:write(rule, "\n")
        print(rule)
    end
    
    -- 动态库
    for target, files in pairs(self.SO_TARGET) do
        local flags = self.compile_flags .. ' ' .. self.link_flags
        local rule = makeSoTargetRule(target, files, self.compiler, flags)
        fp:write(rule, "\n")
        print(rule)
    end
    
    -- 源文件
    for i, file in ipairs(self.SOURCE) do
        local rule = makeSourceRule(file, self.compiler, self.compile_flags)
        fp:write(rule, "\n")
        print(rule)
    end
    
    -- 保存
    fp:close()
end

-- 设置编译器
function quickmake:setCompiler(compiler)
    self.compiler = compiler
end

-- 设置编译参数
function quickmake:setCompileFlags(flags)
    self.compile_flags = flags
end

-- 设置链接参数
function quickmake:setLinkFlags(flags)
    self.link_flags = flags
end

-- 设置out文件目标
function quickmake:addOutTarget(target, files)
    self.OUT_TARGET[target] = files
end

-- 设置动态库目标
function quickmake:addSoTarget(target, files)
    self.SO_TARGET[target] = files
end

-- 设置静态库目标
function quickmake:addATarget(target, files)
    self.A_TARGET[target] = files
end

-- 设置源文件
function quickmake:setSource(files)
    self.SOURCE = files
end

return quickmake
