VERSION 5.00
Begin VB.Form frmElement 
   BackColor       =   &H00C0FFFF&
   BorderStyle     =   0  'None
   Caption         =   "元素查询器"
   ClientHeight    =   5610
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5760
   Icon            =   "frmElement.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5610
   ScaleWidth      =   5760
   StartUpPosition =   1  '所有者中心
   Begin VB.CommandButton cmdCopy 
      Caption         =   "复制到剪切板"
      Height          =   495
      Left            =   2400
      TabIndex        =   7
      Top             =   4920
      Width           =   3015
   End
   Begin VB.TextBox texElementOut 
      BeginProperty Font 
         Name            =   "微软雅黑"
         Size            =   12
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1935
      Left            =   2400
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   6
      Text            =   "frmElement.frx":1DDBA
      Top             =   2880
      Width           =   3015
   End
   Begin VB.CommandButton cmdElement 
      Caption         =   "查询！"
      Default         =   -1  'True
      Height          =   495
      Left            =   4560
      TabIndex        =   1
      Top             =   2280
      Width           =   855
   End
   Begin VB.TextBox texElementIn 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   12
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0C0C0&
      Height          =   495
      Left            =   0
      TabIndex        =   0
      Top             =   2280
      Width           =   4455
   End
   Begin VB.Image imgClose 
      Height          =   450
      Left            =   5280
      Picture         =   "frmElement.frx":1DDD1
      Stretch         =   -1  'True
      Top             =   0
      Width           =   450
   End
   Begin VB.Image imgTitle 
      Appearance      =   0  'Flat
      Height          =   2145
      Left            =   -600
      Picture         =   "frmElement.frx":1F6C9
      Stretch         =   -1  'True
      Top             =   0
      Width           =   7335
   End
   Begin VB.Label lblElementMass 
      BackStyle       =   0  'Transparent
      Caption         =   "1.008"
      BeginProperty Font 
         Name            =   "Calibri"
         Size            =   21.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      TabIndex        =   5
      Top             =   4800
      Width           =   1215
   End
   Begin VB.Label lblElementAbbr 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "H"
      BeginProperty Font 
         Name            =   "Calibri"
         Size            =   48
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   975
      Left            =   120
      TabIndex        =   4
      Top             =   3600
      Width           =   1215
   End
   Begin VB.Label lblElementName 
      BackStyle       =   0  'Transparent
      Caption         =   "氢"
      BeginProperty Font 
         Name            =   "黑体"
         Size            =   36
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   975
      Left            =   1200
      TabIndex        =   3
      Top             =   3840
      Width           =   975
   End
   Begin VB.Label lblElementNumber 
      BackStyle       =   0  'Transparent
      Caption         =   "1"
      BeginProperty Font 
         Name            =   "Calibri"
         Size            =   27.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   120
      TabIndex        =   2
      Top             =   3000
      Width           =   975
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFF00&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00FF0000&
      FillColor       =   &H00FFFF80&
      Height          =   2535
      Left            =   0
      Top             =   2880
      Width           =   2295
   End
End
Attribute VB_Name = "frmElement"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private InTip As String

Private Sub cmdCopy_Click()
    UICopy (texElementOut)
End Sub

Private Sub cmdElement_Click()
    Dim n As Integer, ElementOutput As String, ElementOutputHtml As String
    n = calElementChoose(texElementIn.Text)
    If n > 0 Then
        lblElementNumber = n
        lblElementName = ElementName(n)
        lblElementAbbr = ElementAbbr(n)
        lblElementMass = ElementMass(n)
        HisElement = texElementIn.Text
        Call dataBaseWrite(DataUsername, "Element", HisElement)
    End If
    ElementOutput = calElementStr(n)
    texElementOut = CutHtml(ElementOutput)
    If n > 0 Then
        ElementOutputHtml = ElementOutput & Chr(10) & "<a href='https://en.wikipedia.org/wiki/" & ElementIUPAC(n) & "'>访问维基百科</a>"
        HisElementOutput = texElementOut
        Call dataBaseWrite(DataUsername, "ElementOutput", HisElementOutput)
        If Not DataUsername = "访客" And n > 0 Then
            Call dataHtmlChange("historyElementOutputHtml", CStr(ElementOutputHtml))
            Call dataHtmlChange("historyElementOutput", CStr(ElementOutput))
            Call dataHtmlChange("historyElementNumber", CStr(n))
            Call dataHtmlChange("historyElement", CStr(HisElement))
        End If
    End If
End Sub

Private Sub Form_Load()
    Dim n As Integer
    InTip = "请在此处输入元素序号/名称/符号"
    texElementIn.Text = InTip
    If HisElement <> "" Then
        n = calElementChoose(HisElement)
        lblElementNumber = n
        lblElementName = ElementName(n)
        lblElementAbbr = ElementAbbr(n)
        lblElementMass = ElementMass(n)
    End If
    If HisElementOutput <> "" Then
        texElementOut = HisElementOutput
    End If
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    ReleaseCapture
    SendMessage hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&
End Sub

Private Sub imgClose_Click()
    Unload Me
End Sub

Private Sub imgTitle_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    ReleaseCapture
    SendMessage hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&
End Sub

Private Sub texElementIn_Click()
    If texElementIn.Text = InTip Then
        texElementIn.Text = ""
        texElementIn.ForeColor = RGB(0, 0, 0)
    End If
End Sub

Private Sub texElementIn_KeyPress(KeyAscii As Integer)
    If texElementIn.Text = InTip Then
        texElementIn.Text = ""
        texElementIn.ForeColor = RGB(0, 0, 0)
    End If
End Sub

