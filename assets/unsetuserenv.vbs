Option Explicit

Dim WSHShell, userpath, originalpath, changed
Set WSHShell = CreateObject("WScript.Shell")

On Error Resume Next
userpath = WSHShell.RegRead("HKCU\Environment\Path")
originalpath = userpath
If Err.Number <> 0 Then
    userpath = ""
    Err.Clear
End If
On Error GoTo 0

userpath = Replace(userpath, "%NVM_HOME%;", "")
userpath = Replace(userpath, ";%NVM_HOME%", "")
userpath = Replace(userpath, "%NVM_HOME%", "")

userpath = Replace(userpath, "%NVM_SYMLINK%;", "")
userpath = Replace(userpath, ";%NVM_SYMLINK%", "")
userpath = Replace(userpath, "%NVM_SYMLINK%", "")

Do While InStr(userpath, ";;") > 0
    userpath = Replace(userpath, ";;", ";")
Loop

If Right(userpath, 1) = ";" Then
    userpath = Left(userpath, Len(userpath) - 1)
End If

If userpath <> originalpath Then
    WSHShell.RegWrite "HKCU\Environment\Path", userpath, "REG_EXPAND_SZ"
End If