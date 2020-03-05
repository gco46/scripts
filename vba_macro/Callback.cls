VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Callback"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' fit_merged_cells_height() �萔
' �����������}�[�W��[px]
Private Const HEIGHT_MERGIN = 3


Sub show_multi_book()
    Windows.Arrange Arrangestyle:=xlArrangeStyleVertical
End Sub


Sub show_one_book()
    ActiveWindow.WindowState = xlMaximized
End Sub


Sub redraw_borders()
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
End Sub


Sub paint_blank()
    With Selection.Interior
        .Pattern = xlNone
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
End Sub


Sub paint_yellow()
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 65535
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
End Sub


Sub fit_merged_cells_height()
    Dim margin                  As Integer
    Dim r                       As Range
    Dim iBondWidth                              '// �������̃Z����
    Dim iStartCellWidth                         '// �����ΏۃZ���̕�
    Dim sBeforeAddress                          '// �������̌����ΏۃZ��
    Dim iBeforeHeight                           '// �ŏI�I�ɐݒ肷�鍂��
    Dim sArCell()               As String       '// �Z���͈�
    Dim bRet                    As Boolean      '// �߂�l
    Dim i                                       '// ���[�v�J�E���^
    Dim iArCount                                '// �z��v�f��
    Dim sNowAddress                             '// ���݃Z�����W
    Dim bExistFlg               As Boolean      '// �z����ɃZ�������݂��Ă��邩����t���O�iTrue�F���݂���AFalse�F���݂��Ȃ��j
    Dim iArRow()                                '// �����s�̌������̊e�s�̍���

    ' �Z���̍����̃}�[�W���w��
    margin = HEIGHT_MERGIN
    
    ReDim sArCell(0)
    
    For Each r In Selection
        '// �������̕����擾
        iBondWidth = GetWidthOfMergedCells(r)
        
        '// �������̊e�Z���̍������擾
        Call GetHightOfMergedCells(r, iArRow)
        
        iArCount = UBound(sArCell)
        
        '// �Z���z����Ɍ����[�v�̃Z��������Ώ����ΏہB�����łȂ���Ύ���Selection�����Ȃ̂Ō㑱�����Ŕz���蒼���B
        bExistFlg = False
        sNowAddress = r.Address(False, False)
        For i = 0 To iArCount
            If (sNowAddress = sArCell(i)) Then
                bExistFlg = True
                Exit For
            End If
        Next
        
        '// �z����Ɍ����[�v�̃Z�����Ȃ��ꍇ�i�����Z�������[�v�ŕς�����ꍇ�j
        If (bExistFlg = False) Then
            '// �Z���͈͂̑S�Z����z��Ŏ擾
            bRet = GetAddressesOfMergedCells(r, sArCell)
        End If
        
        '// �����Z���̏ꍇ
        If (sNowAddress = sArCell(0)) Then
            iStartCellWidth = r.ColumnWidth
            
            '// �������̌����ΏۃZ�����擾
            sBeforeAddress = r.MergeArea.Address(False, False, ReferenceStyle:=xlA1)
            
            '// ����������
            r.UnMerge
            
            '// �������̃Z�����܂Ŋg������
            r.ColumnWidth = iBondWidth
            
            '// �܂�Ԃ�ON
            r.WrapText = True
            
            '// �K�v�ȍ������擾
            r.EntireRow.AutoFit
            
            '// �Z���������擾
            iBeforeHeight = r.RowHeight + margin
            
            '// �Č���
            Range(sBeforeAddress).Merge
            
            '// ������̃Z�������̃Z�����ɖ߂�
            r.MergeArea.Item(1).ColumnWidth = iStartCellWidth
            
            '// ������̃Z���̍�����ݒ�
            Call SetHightOfMergedCells(r, iBeforeHeight, iArRow)
        End If
    Next
    
End Sub


Sub auto_fill()
    Dim myClm As Integer
    Dim myRow As Long
    Dim myRange1 As String
    Dim myRange2 As String

    myClm = Selection.Column
    myRow = ActiveSheet.Cells(Rows.Count, myClm).End(xlUp).Row
    If myClm <> 1 Then
        myRow = ActiveSheet.Cells(Rows.Count, myClm - 1).End(xlUp).Row
    Else
        myRow = ActiveSheet.Cells(Rows.Count, myClm + 1).End(xlUp).Row
    End If
    myRange1 = Selection.Address
    myRange2 = ActiveSheet.Cells(myRow, myClm).Address
    myRange2 = myRange1 & ":" & myRange2
    ActiveSheet.Range(myRange1).AutoFill Destination:=ActiveSheet.Range(myRange2)
End Sub


Sub paste_without_blank_row_cells()
    Dim data_obj As New DataObject      ' �N���b�v�{�[�h�Q�Ƃׂ̈�DataObject
    Dim cbFormat As Variant
    Dim trimmed_txt As String           ' �󔒕��������폜����������p
    Dim cells_array As Variant          ' �R�s�[�Z���͈͓��̒l��v�f�Ƃ���z��
    Dim i As Long                       ' ���[�v�J�E���^
    Dim paste_index As Long             ' �y�[�X�g��Z����index(�I���Z������Ɉړ�)
    
    paste_index = 0
    ' �N���b�v�{�[�h�̃f�[�^���e�L�X�g�ȊO�Ȃ�ΏI��
    cbFormat = Application.ClipboardFormats
    If cbFormat(1) <> 0 Then
        Exit Sub
    End If
    
    
    ' �R�s�[�Z���͈͂̒l��z��
    data_obj.GetFromClipboard
    ' �N���b�v�{�[�h�̕����񂩂�󔒕��������폜�����`
    trimmed_txt = Replace(data_obj.GetText, vbTab, "")
    trimmed_txt = Replace(trimmed_txt, vbCr, "")
    trimmed_txt = Replace(trimmed_txt, vbCrLf, "")
    cells_array = Split(trimmed_txt, vbLf)

    
    ' �I���Z������ɒl���y�[�X�g
    For i = 0 To UBound(cells_array) - 1
        ' �l�̓������Z���̂݃y�[�X�g
        If cells_array(i) <> "" Then
            ' ������Ƃ��ăZ���ɑ��
            Selection.Offset(paste_index, 0).Value = "'" & cells_array(i)
            paste_index = paste_index + 1
        End If
End Sub
