Attribute VB_Name = "UnlockMacro"
Option Explicit
' Excel 2010でのみ動作確認--------------------------------------------------


Private Const PAGE_EXECUTE_READWRITE = &H40
Private Declare Sub MoveMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Long, Source As Long, ByVal Length As Long)
Private Declare Function VirtualProtect Lib "kernel32" (lpAddress As Long, ByVal dwSize As Long, ByVal flNewProtect As Long, lpflOldProtect As Long) As Long
Private Declare Function GetModuleHandleA Lib "kernel32" (ByVal lpModuleName As String) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function DialogBoxParam Lib "user32" Alias "DialogBoxParamA" (ByVal hInstance As Long, ByVal pTemplateName As Long, ByVal hWndParent As Long, ByVal lpDialogFunc As Long, ByVal dwInitParam As Long) As Integer
Dim HookBytes(0 To 5) As Byte
Dim OriginBytes(0 To 5) As Byte
Dim pFunc As Long
Dim Flag As Boolean
 
Private Function GetPtr(ByVal Value As Long) As Long
    GetPtr = Value
End Function
 
Private Sub RecoverBytes()
    If Flag Then MoveMemory ByVal pFunc, ByVal VarPtr(OriginBytes(0)), 6
End Sub
 
Private Function Hook() As Boolean
    Dim TmpBytes(0 To 5) As Byte
    Dim p As Long
    Dim OriginProtect As Long
 
    Hook = False
    pFunc = GetProcAddress(GetModuleHandleA("user32.dll"), "DialogBoxParamA")
    If VirtualProtect(ByVal pFunc, 6, PAGE_EXECUTE_READWRITE, OriginProtect) <> 0 Then
        MoveMemory ByVal VarPtr(TmpBytes(0)), ByVal pFunc, 6
        If TmpBytes(0) <> &H68 Then
            MoveMemory ByVal VarPtr(OriginBytes(0)), ByVal pFunc, 6
            p = GetPtr(AddressOf MyDialogBoxParam)
            HookBytes(0) = &H68
            MoveMemory ByVal VarPtr(HookBytes(1)), ByVal VarPtr(p), 4
            HookBytes(5) = &HC3
            MoveMemory ByVal pFunc, ByVal VarPtr(HookBytes(0)), 6
            Flag = True
            Hook = True
        End If
    End If
End Function
 
Private Function MyDialogBoxParam(ByVal hInstance As Long, ByVal pTemplateName As Long, ByVal hWndParent As Long, ByVal lpDialogFunc As Long, ByVal dwInitParam As Long) As Integer
    If pTemplateName = 4070 Then
        MyDialogBoxParam = 1
    Else
        RecoverBytes
        MyDialogBoxParam = DialogBoxParam(hInstance, pTemplateName, _
        hWndParent, lpDialogFunc, dwInitParam)
        Hook
    End If
End Function

Public Sub unprotected()
    If Hook Then
        MsgBox "VBA Project is unprotected!", vbInformation, "*****"
    End If
End Sub


