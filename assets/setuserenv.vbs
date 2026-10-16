Option Explicit

Dim WSHShell, userpath, changed
Set WSHShell = CreateObject("WScript.Shell")

On Error Resume Next
userpath = WSHShell.RegRead("HKCU\Environment\Path")
If Err.Number <> 0 Then
    userpath = ""
    Err.Clear
End If
On Error GoTo 0

If Len(userpath) > 0 And Right(userpath, 1) <> ";" Then
    userpath = userpath & ";"
End If

changed = False

If InStr(1, userpath, "%NVM_HOME%", vbTextCompare) = 0 Then
    userpath = userpath & "%NVM_HOME%;"
    changed = True
End If

If InStr(1, userpath, "%NVM_SYMLINK%", vbTextCompare) = 0 Then
    userpath = userpath & "%NVM_SYMLINK%;"
    changed = True
End If

Do While InStr(userpath, ";;") > 0
    userpath = Replace(userpath, ";;", ";")
Loop

If Right(userpath, 1) = ";" Then
    userpath = Left(userpath, Len(userpath) - 1)
End If

If changed Then
    WSHShell.RegWrite "HKCU\Environment\Path", userpath, "REG_EXPAND_SZ"
End If