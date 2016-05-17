: 删除原来程序,防止有时候编译不通过也不知道
del %1%.exe;
del %1%.obj;


masm %1%;
link %1%;


del bin\bin.exe
copy %1%.exe bin\bin.exe