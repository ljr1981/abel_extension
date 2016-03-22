cd C:\Users\LJR19\Documents\GitHub\abel_extension
del eifgens /F /Q
rmdir eifgens /S /Q
ec -config abel_extension.ecf -target abel_extension
ec -config abel_extension.ecf -target test
dir
