@echo off
START cmd /k python python/main.py
timeout /t 3 /nobreak
START cmd /k "Memoria Godot.exe"