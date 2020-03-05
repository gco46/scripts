Attribute VB_Name = "Shortcuts"
Option Explicit

Private Sub startMacro()
'
' マクロ実行前処理(高速化のために各種処理を無効化)
'
    With Application
        .ScreenUpdating = False              '描画を省略
        .Calculation = xlCalculationManual   '手動計算
        .DisplayAlerts = False               '警告を省略
        .EnableEvents = False                'イベント無効
    End With
End Sub

Private Sub endMacro()
'
' マクロ実行後処理(各種処理有効化)
'
    With Application
        .ScreenUpdating = True                '描画する
        .Calculation = xlCalculationAutomatic '自動計算
        .DisplayAlerts = True                 '警告を行う
        .EnableEvents = True                  'イベント有効
    End With
End Sub


Private Sub executeMacro(method As String)
'
' マクロ実行関数
' method でコールバック関数を指定する
'
    Dim cbObj As New Callback
    startMacro
    executeCallback Array(cbObj, method)
    endMacro
End Sub

Private Sub executeCallback(cb_arr)
    CallByName cb_arr(0), cb_arr(1), VbMethod
End Sub
 
 
Sub ShowMultiBook()
Attribute ShowMultiBook.VB_ProcData.VB_Invoke_Func = "A\n14"
'
' 開いているブックを横に並べて表示 (ctrl + shift + a)
'
    executeMacro "show_multi_book"
End Sub


Sub ShowOneBook()
Attribute ShowOneBook.VB_ProcData.VB_Invoke_Func = "S\n14"
'
' アクティブなブックを全画面表示 (ctrl + shift + s)
'
    executeMacro "show_one_book"
End Sub


Sub ReDrawBorders()
Attribute ReDrawBorders.VB_ProcData.VB_Invoke_Func = "q\n14"
'
' 選択範囲のセルを囲うように罫線を引く (ctrl + q)
'
    executeMacro "redraw_borders"
End Sub


Sub NoPaint()
Attribute NoPaint.VB_ProcData.VB_Invoke_Func = "N\n14"
'
' 選択セルを"塗りつぶしなし"にする (ctrl + shift + n)
'
    executeMacro "paint_blank"
End Sub


Sub YellowPaint()
Attribute YellowPaint.VB_ProcData.VB_Invoke_Func = "Y\n14"
'
' 選択セルを黄色に塗りつぶす (ctrl + shift + y)
'
    executeMacro "paint_yellow"
End Sub


Sub AutoFitMergedCellsHeight()
Attribute AutoFitMergedCellsHeight.VB_ProcData.VB_Invoke_Func = "R\n14"
'
' 結合セルの高さを自動調節 (ctrl + shift + r)
'
    executeMacro "fit_merged_cells_height"
End Sub


Sub AutoFill()
Attribute AutoFill.VB_ProcData.VB_Invoke_Func = "F\n14"
'
' 選択セルの横列に合わせてオートフィル (ctrl + shift + f)
'
    executeMacro "auto_fill"
End Sub


Sub PasteWithoutBlankRowCells()
Attribute PasteWithoutBlankRowCells.VB_ProcData.VB_Invoke_Func = "V\n14"
'
' 結合セルの空白部分を除いて、コピー範囲のセルをペーストする
' 列方向結合に対応、複数列のコピーは不可 (ctrl + shift + v)
'
    executeMacro "paste_without_blank_row_cells"
End Sub
