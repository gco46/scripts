Attribute VB_Name = "MyFunc"
Option Explicit


Function CONCAT(ParamArray par())
  Dim i As Integer
  Dim tR As Range
  
  CONCAT = ""
  For i = LBound(par) To UBound(par)
    If TypeName(par(i)) = "Range" Then
      For Each tR In par(i)
        CONCAT = CONCAT & tR.Value2
      Next
    Else
      CONCAT = CONCAT & par(i)
    End If
  Next
End Function

Function StrReverseHex(a_str) As String
    Dim sRev    As String
    Dim i       As Long
    Dim iLen    As Long
    Dim sRet    As String
    
    '// 引数文字列の文字列長を取得
    iLen = Len(a_str)
    
    '// 文字列長が偶数でない場合
    If (iLen Mod 2) <> 0 Then
        Debug.Print "２文字ずつの引数文字列でない"
        Exit Function
    End If
    
    '// 引数文字列を反転
    sRev = StrReverse(a_str)
    
    '// 戻り値文字列を初期化
    sRet = ""
    
    '// ２文字ずつループ
    For i = 1 To iLen Step 2
        '// ２文字目を先に取得
        sRet = sRet & Mid(sRev, i + 1, 1)
        '// １文字目を後に取得
        sRet = sRet & Mid(sRev, i, 1)
    Next
    
    StrReverseHex = sRet
End Function
