@echo off
cd /d "%~dp0"
git rm --cached IELTSFLOW/TestGemini.java
git rm --cached commit_code.bat
del IELTSFLOW\TestGemini.java
del commit_code.bat
git commit --amend --no-edit
