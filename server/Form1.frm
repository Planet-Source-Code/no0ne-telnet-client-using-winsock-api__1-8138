VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "www.planet-source-code.com"
   ClientHeight    =   1965
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3915
   LinkTopic       =   "Form1"
   ScaleHeight     =   1965
   ScaleWidth      =   3915
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton listenBtn 
      Caption         =   "Listen"
      Height          =   375
      Left            =   1320
      TabIndex        =   3
      Top             =   1560
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   1455
      Left            =   0
      MultiLine       =   -1  'True
      TabIndex        =   2
      Top             =   0
      Width           =   3855
   End
   Begin VB.CommandButton Databtn 
      Caption         =   "DataBtn"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   1560
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton Reqbtn 
      Caption         =   "reqbtn"
      Height          =   255
      Left            =   2520
      TabIndex        =   0
      Top             =   1560
      Visible         =   0   'False
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'//////////////////////////////////////////
'// This is a basic telnet server useing winsock API.
'// I put this to gether because of the lack of Socket
'// code for VB.
'//
'// This is only the Server. Next isue, The client
'//////

Dim Start_up_Data As WSADataType

Dim Socket_Number As Long
Dim Read_Sock As Long

Dim Socket_Buffer As sockaddr
Dim Read_Sock_Buffer As sockaddr

Dim Read_Buffer As String * 1024

Private Sub Form_Load()
    
    RC = WSACleanup()
    RC = WSAStartup(&H101, Start_up_Data)
    
    If RC = SOCKET_ERROR Then Exit Sub
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    RC = WSACleanup()
    
End Sub

Private Sub listenBtn_Click()

    Socket_Number = socket(AF_INET, SOCK_STREAM, 0)
    
    If Socket_Number < 1 Then
        Exit Sub
    End If
    
    Socket_Buffer.sin_family = AF_INET
    Socket_Buffer.sin_port = htons(23)      '// Port 23 is telnet.
    Socket_Buffer.sin_addr = 0
    Socket_Buffer.sin_zero = String$(8, 0)
    
    X = bind(Socket_Number, Socket_Buffer, sockaddr_size)
    
    If X <> 0 Then
        X = WSACleanup()
        Exit Sub
    End If
    
    X = listen(Socket_Number, 1)
    X = WSAAsyncSelect(Socket_Number, Databtn.hWnd, &H202, FD_CONNECT Or FD_ACCEPT)
    
    Text1.Text = "Socket opend = " & Socket_Number & vbCrLf
    
End Sub

'///////////////////
'// Controlers::MouseUp
'/////

Private Sub Reqbtn_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

On Error Resume Next    '// This alows for the Socket Stay open

    Bytes = recv(Read_Sock, Read_Buffer, 1024, 0)
    
    If Bytes <> 0 Then
        Text1.Text = Text1.Text + Left$(Read_Buffer, Bytes)
            
    '/////////////////////////////
    '// This is where you would put your code.
    '//
    '// if Left$(Read_Buffer, Bytes) = vbCrLf then
    '//     doSomething(comandSent$)
    '// end if
    '/////////
      
    End If
    
End Sub


Private Sub Databtn_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    Read_Sock = accept(Socket_Number, Read_Sock_Buffer, Len(Read_Sock_Buffer))
    X = WSAAsyncSelect(Read_Sock, Reqbtn.hWnd, ByVal &H202, ByVal FD_READ Or FD_CLOSE)
    Text1.Text = Text1.Text & "Connected" & vbCrLf
End Sub

