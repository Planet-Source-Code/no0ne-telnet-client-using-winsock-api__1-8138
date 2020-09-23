VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "The Client"
   ClientHeight    =   2190
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4230
   LinkTopic       =   "Form1"
   ScaleHeight     =   2190
   ScaleWidth      =   4230
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox ChatBoxtxt 
      Height          =   975
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   7
      Top             =   1200
      Width           =   4215
   End
   Begin VB.Frame Frame1 
      Caption         =   "Remote Host Info"
      Height          =   1095
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   4215
      Begin VB.CommandButton disconnectbtn 
         Caption         =   "Disconnect"
         Height          =   255
         Left            =   3000
         TabIndex        =   6
         Top             =   600
         Width           =   1095
      End
      Begin VB.CommandButton Connectbtn 
         Caption         =   "Connect"
         Height          =   255
         Left            =   3000
         TabIndex        =   5
         Top             =   240
         Width           =   1095
      End
      Begin VB.TextBox Porttxt 
         Height          =   285
         Left            =   1200
         TabIndex        =   4
         Text            =   "23"
         Top             =   600
         Width           =   1575
      End
      Begin VB.TextBox IPtxt 
         Height          =   285
         Left            =   960
         TabIndex        =   3
         Text            =   "127.0.0.1"
         Top             =   240
         Width           =   1815
      End
      Begin VB.Label Label2 
         Caption         =   "Port Number"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   600
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "Server IP"
         Height          =   255
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   735
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'/////////////////////////////////////
'// Name: The Client
'// By: no()ne
'// Email: Data_Tune@hotmail.com
'// Date 05-16-00 <- 1900 (None Y2K)
'//
'// This is part two of the winsock example.
'// this is used with the server. (Included)
'//
'// Instructions::
'// Open up the server code compile it and then
'// run it, Make sure you tell it to "listen"
'// for a connection.
'//
'// Then compile this (client) code and run it.
'// 127.0.0.1 is a standerd loob back, and 23 is
'// the telnet port the server is using. Once you
'// connect just start typeing in the text box.
'// Then go back and look in the servers window :)
'//////////////////

Dim Start_up_Data As WSADataType

Dim Socket_Number As Long
Dim Read_Sock As Long

Dim Socket_Buffer As sockaddr
Dim Read_Sock_Buffer As sockaddr

Dim Read_Buffer As String * 1024
Dim X As Long

Private Sub ChatBoxtxt_KeyPress(KeyAscii As Integer)

    X = send(Socket_Number, KeyAscii, Len(KeyAscii), 0)
    
End Sub

Private Sub Connectbtn_Click()

    Socket_Number = socket(AF_INET, SOCK_STREAM, 0)
    
    If Socket_Number < 1 Then
        Exit Sub
    End If
    

    Dim RemoteIP As Long
    Dim RemotePort As Integer
    
    RemoteIP = inet_addr(IPtxt.Text) 'Text1.Text
    RemotePort = Int(Porttxt.Text)   'Text2.Text

    
    Socket_Buffer.sin_family = AF_INET
    Socket_Buffer.sin_port = htons(RemotePort)      '// Port 23 is telnet.
    Socket_Buffer.sin_addr = RemoteIP
    Socket_Buffer.sin_zero = String$(8, 0)
    
    X = connect(Socket_Number, Socket_Buffer, sockaddr_size)
    
    If X > 0 Then
        X = WSACleanup()
        Exit Sub
    End If
    
End Sub

'///////////////////////////////////////
'// The rest of this is to keep it clean.
'///////////

Private Sub disconnectbtn_Click()
    
    RC = WSACleanup()
    
End Sub

Private Sub Form_Load()

    RC = WSACleanup()
    RC = WSAStartup(&H101, Start_up_Data)
    
End Sub
Private Sub Form_Unload(Cancel As Integer)
    
    RC = WSACleanup()
    
End Sub

