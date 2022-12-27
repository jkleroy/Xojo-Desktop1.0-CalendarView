#tag DesktopWindow
Begin DesktopWindow EditEvent
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   False
   DefaultLocation =   0
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   Height          =   357
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   False
   Title           =   "New Event"
   Type            =   8
   Visible         =   True
   Width           =   375
   Begin DesktopLabel lblDate
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "#klocalDate"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   14
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   63
   End
   Begin DesktopLabel lblTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "#klocalTitle"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   141
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   63
   End
   Begin DesktopTextField tfiTitle
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF00
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   22
      Hint            =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   112
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   139
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   243
   End
   Begin DesktopButton btnOK
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "#kLocalOK"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   22
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   275
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   315
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopLabel lblDateSelection
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   112
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   14
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   243
   End
   Begin DesktopCanvas cnvColor
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   283
      Transparent     =   True
      Visible         =   True
      Width           =   335
   End
   Begin DesktopTextField tfiLocation
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF00
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   22
      Hint            =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   112
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   173
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   243
   End
   Begin DesktopLabel lblLocation
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "#klocalLocation"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   175
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   63
   End
   Begin DesktopLabel lblDescription
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "#klocalDescription"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   207
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   86
   End
   Begin DesktopTextArea tarDescription
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF00
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   68
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   112
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   203
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   0
      ValidationMask  =   ""
      Visible         =   True
      Width           =   243
   End
   Begin DesktopButton DeleteButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "#klocalDelete"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   22
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   315
      Transparent     =   False
      Underline       =   False
      Visible         =   False
      Width           =   80
   End
   Begin DesktopCanvas Canvas2
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   90
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   47
      Transparent     =   True
      Visible         =   True
      Width           =   335
      Begin DesktopComboBox Combo_Start
         AllowAutoComplete=   False
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Hint            =   ""
         Index           =   -2147483648
         InitialParent   =   "Canvas2"
         InitialValue    =   ""
         Italic          =   False
         Left            =   111
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         SelectedRowIndex=   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   72
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   95
      End
      Begin DesktopLabel Lbl_To
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas2"
         Italic          =   False
         Left            =   211
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#klocalTo"
         TextAlignment   =   2
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   72
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   36
      End
      Begin DesktopComboBox Combo_End
         AllowAutoComplete=   False
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Hint            =   ""
         Index           =   -2147483648
         InitialParent   =   "Canvas2"
         InitialValue    =   ""
         Italic          =   False
         Left            =   256
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         SelectedRowIndex=   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   72
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   95
      End
      Begin DesktopCheckBox Chk_AllDay
         AllowAutoDeactivate=   True
         Bold            =   False
         Caption         =   "#klocalAllday"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas2"
         Italic          =   False
         Left            =   111
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   49
         Transparent     =   False
         Underline       =   False
         Value           =   False
         Visible         =   True
         VisualState     =   0
         Width           =   240
      End
   End
   Begin DesktopCanvas Canvas3
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   False
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   297
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   396
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   14
      Transparent     =   True
      Visible         =   True
      Width           =   391
      Begin DesktopLabel lblRepeats
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   396
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#klocalRepeats"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   14
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopPopupMenu Popup_Repeat
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         InitialValue    =   ""
         Italic          =   False
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         SelectedRowIndex=   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   14
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   135
      End
      Begin DesktopLabel lblRepeatInterval
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   396
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#klocalRepeatEvery"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopPopupMenu Popup_Interval
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         InitialValue    =   ""
         Italic          =   False
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         SelectedRowIndex=   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   50
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   50
      End
      Begin DesktopLabel lblRepeatOn
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   396
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#kLocalRepeatOn"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   86
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopLabel lblStartsOn
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   396
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   13
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#kLocalStartsOn"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   119
         Transparent     =   True
         Underline       =   False
         Visible         =   False
         Width           =   100
      End
      Begin DesktopLabel lblEnds
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   396
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   14
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#klocalEnds"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   152
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopLabel lblStartsOnSelection
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   15
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "..."
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   119
         Transparent     =   True
         Underline       =   False
         Visible         =   False
         Width           =   259
      End
      Begin DesktopRadioButton radioEnd
         AllowAutoDeactivate=   True
         Bold            =   False
         Caption         =   "#klocalNever"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   0
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   16
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   152
         Transparent     =   False
         Underline       =   False
         Value           =   True
         Visible         =   True
         Width           =   100
      End
      Begin DesktopRadioButton radioEnd
         AllowAutoDeactivate=   True
         Bold            =   False
         Caption         =   "#klocalAfter"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   1
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   17
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   177
         Transparent     =   False
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   58
      End
      Begin DesktopTextField txtNb
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         AllowSpellChecking=   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF00
         Bold            =   False
         Enabled         =   False
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         Height          =   22
         Hint            =   ""
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   578
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   18
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "10"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   176
         Transparent     =   False
         Underline       =   False
         ValidationMask  =   "###"
         Visible         =   True
         Width           =   44
      End
      Begin DesktopLabel lblOccurences
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   634
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   19
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#kLocalOccurences"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   177
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopRadioButton radioEnd
         AllowAutoDeactivate=   True
         Bold            =   False
         Caption         =   "#klocalOn"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   2
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   21
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   203
         Transparent     =   False
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   58
      End
      Begin DesktopLabel lblSummary
         AllowAutoDeactivate=   True
         Bold            =   True
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   396
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   22
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#klocalSummary"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   232
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopLabel lblRepeatUnit
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   567
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   16
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "#klocalDays"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   73
      End
      Begin DesktopLabel lbl_Summary
         AllowAutoDeactivate=   True
         Bold            =   True
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   70
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Italic          =   False
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   True
         Scope           =   0
         Selectable      =   False
         TabIndex        =   23
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Summary:"
         TextAlignment   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   232
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   250
      End
      BeginDesktopSegmentedButton DesktopSegmentedButton sgbDays
         Enabled         =   True
         Height          =   24
         Index           =   -2147483648
         InitialParent   =   "Canvas3"
         Left            =   508
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MacButtonStyle  =   0
         Scope           =   0
         Segments        =   "MO\n\nFalse\rTU\n\nFalse\rWE\n\nFalse\rTH\n\nFalse\rFR\n\nFalse\rSA\n\nFalse\rSU\n\nFalse"
         SelectionStyle  =   0
         TabIndex        =   24
         TabPanelIndex   =   0
         TabStop         =   False
         Tooltip         =   ""
         Top             =   86
         Transparent     =   False
         Visible         =   True
         Width           =   226
      End
   End
   Begin DesktopLabel lblEndDate
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   False
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   580
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Select Date"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   203
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   187
   End
   Begin DesktopCheckBox Chk_Repeat
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "#klocalRepeat"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   112
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   18
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   106
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   232
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  If not OkToClose then
		    
		    Hide()
		    
		  Else
		    
		    Close
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  
		  Colors.Add &c444444
		  Colors.Add &c5484ED
		  Colors.Add &cA4BDFC
		  Colors.Add &c46D6DB
		  Colors.Add &c7AE7BF
		  Colors.Add &c51B749
		  Colors.Add &cFBD75B
		  Colors.Add &cFFB878
		  Colors.Add &cFF887C
		  Colors.Add &cDBADFF
		  Colors.Add &cE1E1E1
		  'Colors.Add &c99C8E9
		  
		  cnvColor.Refresh
		  
		  
		  #if TargetWindows
		    Self.HasBackgroundColor = True
		    Self.BackgroundColor = Color.White
		  #endif
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Function CreateRecurrence() As CalendarRecurrence
		  // http://msdn.microsoft.com/en-us/library/ms178644.aspx
		  
		  Dim R As New CalendarRecurrence
		  
		  Dim Row As Integer = Popup_Repeat.SelectedRowIndex
		  
		  //Repeat
		  If Popup_Repeat.RowTagAt(Row) = "Daily" then
		    R.RepeatType = R.TypeDaily
		    'R.RepeatInterval = max(1, val(Popup_Interval.SelectedRowValue))
		    R.Repeat_Recurrence_Factor = max(1, val(Popup_Interval.SelectedRowValue))
		    
		    
		  elseif Popup_Repeat.RowTagAt(Row) = "Weekday" then
		    R.RepeatType = R.TypeWeekDay
		    R.RepeatInterval = R.Interval8Monday + R.Interval8Tuesday + _
		    R.Interval8Wednesday + R.Interval8Thursday + R.Interval8Friday
		    
		  elseif Popup_Repeat.RowTagAt(Row) = "Weekly" then
		    R.RepeatType = R.TypeWeekly
		    R.Repeat_Recurrence_Factor = max(1, val(Popup_Interval.SelectedRowValue))
		    
		    If sgbDays.SegmentAt(0).selected then
		      R.RepeatInterval = R.RepeatInterval + R.Interval8Monday
		    End If
		    If sgbDays.SegmentAt(1).selected then
		      R.RepeatInterval = R.RepeatInterval + R.Interval8Tuesday
		    End If
		    If sgbDays.SegmentAt(2).selected then
		      R.RepeatInterval = R.RepeatInterval + R.Interval8Wednesday
		    End If
		    If sgbDays.SegmentAt(3).selected then
		      R.RepeatInterval = R.RepeatInterval + R.Interval8Thursday
		    End If
		    If sgbDays.SegmentAt(4).selected then
		      R.RepeatInterval = R.RepeatInterval + R.Interval8Friday
		    End If
		    If sgbDays.SegmentAt(5).selected then
		      R.RepeatInterval = R.RepeatInterval + R.Interval8Saturday
		    End If
		    If sgbDays.SegmentAt(6).selected then
		      R.RepeatInterval = R.RepeatInterval + R.Interval8Sunday
		    End If
		    
		  elseif Popup_Repeat.RowTagAt(Row) = "Monthly" then
		    R.RepeatType = R.TypeMonthly
		    R.Repeat_Recurrence_Factor = max(1, val(Popup_Interval.SelectedRowValue))
		    
		  elseif Popup_Repeat.RowTagAt(Row) = "Monthly Relative" then
		    R.RepeatType = R.TypeMonthlyRelative
		    R.Repeat_Recurrence_Factor = max(1, val(Popup_Interval.SelectedRowValue))
		    R.Repeat_Relative_Interval = GetRelativeDay(StartDate)
		    R.RepeatInterval = StartDate.DayOfWeek
		    
		  elseif Popup_Repeat.RowTagAt(Row) = "Yearly" then
		    R.RepeatType = R.TypeYearly
		    R.Repeat_Recurrence_Factor = max(1, val(Popup_Interval.SelectedRowValue))
		    
		  End If
		  
		  //End of recurrence
		  If radioEnd(0).Value then
		    R.EndDate = Nil
		    R.EndAmount = 0
		    
		  Elseif radioEnd(1).Value then
		    R.EndDate = Nil
		    R.EndAmount = max(1, val(txtNb.Text))
		    
		  Elseif radioEnd(2).Value and RecurEndDate <> Nil then
		    'R.EndDate = New Date
		    'R.EndDate.SQLDate = RecurEndDate.SQLDate
		    R.EndDate = New DateTime(RecurEndDate)
		  End If
		  
		  
		  
		  
		  Return R
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetRelativeDay(StartDate As Date) As Integer
		  
		  If StartDate.Day <= 7 then
		    Return CalendarRecurrence.RelativeFirst
		  Elseif StartDate.Day <= 14 then
		    Return CalendarRecurrence.RelativeSecond
		  Elseif StartDate.Day <= 21 then
		    Return CalendarRecurrence.RelativeThird
		  Elseif StartDate.Day <= 28 then
		    Return CalendarRecurrence.RelativeFourth
		  Else
		    Return CalendarRecurrence.RelativeLast
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PopupItemByTag(Tag As String, Popup As DesktopPopupMenu)
		  
		  If Popup.RowCount = 0 then Return
		  Dim i As Integer
		  
		  For i = 0 to Popup.RowCount-1
		    If Popup.RowTagAt(i) = Tag then
		      Popup.SelectedRowIndex = i
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PopupItemByText(pText As String, Popup As DesktopPopupMenu)
		  
		  If Popup.RowCount = 0 then Return
		  Dim i As Integer
		  
		  For i = 0 to Popup.RowCount-1
		    If Popup.RowValueAt(i) = pText then
		      Popup.SelectedRowIndex = i
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetRecurrence(R As CalendarRecurrence)
		  Chk_Repeat.Value = true
		  
		  Select Case R.RepeatType
		  Case R.TypeDaily
		    PopupItemByTag("Daily", Popup_Repeat)
		    PopupItemByText(str(R.Repeat_Recurrence_Factor), Popup_Interval)
		    
		  Case R.TypeWeekDay
		    PopupItemByTag("Weekday", Popup_Repeat)
		    
		  Case R.TypeWeekly
		    PopupItemByTag("Weekly", Popup_Repeat)
		    PopupItemByText(str(R.Repeat_Recurrence_Factor), Popup_Interval)
		    
		    Dim interval As Integer
		    Interval = R.RepeatInterval
		    If Interval >= R.Interval8Saturday then
		      Interval = Interval mod R.Interval8Saturday
		      sgbDays.SegmentAt(5).selected = True
		    End If
		    If Interval >= R.Interval8Friday then
		      Interval = Interval mod R.Interval8Friday
		      sgbDays.SegmentAt(4).selected = True
		    End If
		    If Interval >= R.Interval8Thursday then
		      Interval = Interval mod R.Interval8Thursday
		      sgbDays.SegmentAt(3).selected = True
		    End If
		    If Interval >= R.Interval8Wednesday then
		      Interval = Interval mod R.Interval8Wednesday
		      sgbDays.SegmentAt(2).selected = True
		    End If
		    If Interval >= R.Interval8Tuesday then
		      Interval = Interval mod R.Interval8Tuesday
		      sgbDays.SegmentAt(1).selected = True
		    End If
		    If Interval >= R.Interval8Monday then
		      Interval = Interval mod R.Interval8Monday
		      sgbDays.SegmentAt(0).selected = True
		    End If
		    If Interval >= R.Interval8Sunday then
		      Interval = Interval mod R.Interval8Sunday
		      sgbDays.SegmentAt(6).selected = True
		    End If
		    
		  Case R.TypeMonthly
		    PopupItemByTag("Monthly", Popup_Repeat)
		    PopupItemByText(str(R.Repeat_Recurrence_Factor), Popup_Interval)
		    
		  Case R.TypeMonthlyRelative
		    PopupItemByTag("Monthly Relative", Popup_Repeat)
		    PopupItemByText(str(R.Repeat_Recurrence_Factor), Popup_Interval)
		    
		  Case R.TypeYearly
		    PopupItemByTag("Yearly", Popup_Repeat)
		    PopupItemByText(str(R.Repeat_Recurrence_Factor), Popup_Interval)
		  End Select
		  
		  //End of recurrence
		  if R.EndAmount>0 then
		    txtNb.Text = str(R.EndAmount)
		    radioEnd(1).Value = True
		    R.EndAmount = max(1, val(txtNb.Text))
		    
		  Elseif R.EndDate <> Nil then
		    radioEnd(2).Value = True
		    RecurEndDate = New DateTime(R.EndDate)
		    lblEndDate.Text = RecurEndDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		    
		  Else
		    radioEnd(0).Value = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ShowModal(cEvent As CalendarEvent, ByRef Delete As Boolean, Owner As CalendarView) As CalendarEvent
		  //this is used to edit an event
		  
		  StartDate = cEvent.StartDate
		  EndDate = cEvent.EndDate
		  
		  Reference = New WeakRef(Owner)
		  
		  ResizeWindow = False
		  
		  
		  If cEvent.StartDate.SQLDate = cEvent.EndDate.SQLDate then
		    lblDateSelection.Text = cEvent.StartDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		  else
		    lblDateSelection.Text = cEvent.StartDate.ToString(DateTime.FormatStyles.Medium, DateTime.FormatStyles.None) + " - " + cEvent.EndDate.ToString(DateTime.FormatStyles.Medium, DateTime.FormatStyles.None)
		    Canvas2.Enabled = False
		  End If
		  lblStartsOnSelection.Text = cEvent.StartDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		  
		  Chk_AllDay.Value = cEvent.DayEvent
		  
		  If cEvent.DayEvent = False then
		    Combo_Start.Text = Format(cEvent.StartDate.Hour, "0#") + ":" + Format(cEvent.StartDate.Minute, "0#")
		    Combo_End.Text = Format(cEvent.EndDate.Hour, "0#") + ":" + Format(cEvent.EndDate.Minute, "0#")
		  End If
		  
		  
		  tfiTitle.Text = cEvent.Title
		  tfiLocation.Text = cEvent.Location
		  tarDescription.Text = cEvent.Description
		  
		  Title = "Edit Event"
		  
		  DeleteButton.Visible = True
		  DeleteButton.Caption = "Delete"
		  
		  //Event color
		  SelectColor = -1
		  For i as Integer = 0 to Colors.LastIndex
		    If Colors(i) = cEvent.EventColor then
		      SelectColor = i
		      Exit for i
		    End If
		  Next
		  If SelectColor = -1 then
		    Colors.Append cEvent.EventColor
		    SelectColor = Colors.LastIndex
		  End If
		  
		  //Recurrence
		  If cEvent.Recurrence <> Nil then
		    SetRecurrence(cEvent.Recurrence)
		  End If
		  
		  
		  mOpen = True
		  super.ShowModal
		  OkToClose = True
		  If Handle = Nil then
		    Close
		    Return Nil
		  else
		    
		    If DeleteEvent then
		      Delete = True
		      Close
		      Return cEvent
		    else
		      
		      if Chk_AllDay.Value = False then
		        'cEvent.StartDate.Hour = val(Combo_Start.Text.NthField(":", 1))
		        'cEvent.StartDate.Minute = val(Combo_Start.Text.NthField(":", 2))
		        cEvent.StartDate = cEvent.StartDate - New DateInterval(0,0,0,cEvent.StartDate.Hour,cEvent.StartDate.Minute) + New DateInterval(0,0,0,val(Combo_Start.Text.NthField(":", 1)),val(Combo_Start.Text.NthField(":", 2)))
		        
		        'cEvent.EndDate.Hour = val(Combo_End.Text.NthField(":", 1))
		        'cEvent.EndDate.Minute = val(Combo_End.Text.NthField(":", 2))
		        cEvent.EndDate = cEvent.EndDate - New DateInterval(0,0,0,cEvent.EndDate.Hour,cEvent.EndDate.Minute) + New DateInterval(0,0,0,val(Combo_End.Text.NthField(":", 1)),val(Combo_End.Text.NthField(":", 2)))
		        
		        
		      End If
		      
		      Dim lText As String = tfiTitle.Text
		      Dim location As String = tfiLocation.Text
		      Dim Description As String = tarDescription.Text
		      
		      cEvent.Location = location
		      cEvent.Description = Description
		      cEvent.Title = lText
		      cEvent.EventColor = Colors(SelectColor)
		      
		      If Chk_Repeat.value then
		        cEvent.Recurrence = CreateRecurrence()
		      End If
		      
		      Close
		      Return cEvent
		    End If
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ShowModal(StartDate As DateTime, EndDate As DateTime, Owner As CalendarView) As CalendarEvent
		  //This is used to create an event
		  
		  self.StartDate = StartDate
		  self.EndDate = EndDate
		  
		  Reference = New WeakRef(Owner)
		  
		  ResizeWindow = True
		  
		  If StartDate.SQLDate = EndDate.SQLDate then
		    lblDateSelection.Text = StartDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		    lblStartsOnSelection.Text = StartDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		    
		    If StartDate.Hour <> 0 or EndDate.Hour <> 0 then
		      Combo_Start.Text = Format(StartDate.Hour, "0#") + ":" + Format(StartDate.Minute, "0#")
		      Combo_End.Text = Format(EndDate.Hour, "0#") + ":" + Format(EndDate.Minute, "0#")
		    else
		      Chk_AllDay.Value = True
		      Combo_Start.Text = "00:00"
		      Combo_End.Text = "00:00"
		    End If
		  else
		    lblDateSelection.Text = StartDate.ToString(DateTime.FormatStyles.Medium, DateTime.FormatStyles.None) + " - " + EndDate.ToString(DateTime.FormatStyles.Medium, DateTime.FormatStyles.None)
		    Chk_AllDay.Value = true
		    Chk_AllDay.Enabled = False
		  End If
		  
		  'DeleteButton.Visible = False
		  DeleteButton.Visible = True
		  DeleteButton.Caption = klocalCancel
		  
		  #if DebugBuild
		    Dim abc As Integer
		    abc = (StartDate.DayOfWeek+6) mod 7
		  #endif
		  sgbDays.SegmentAt((StartDate.DayOfWeek+6) mod 7).Selected = True
		  
		  
		  mOpen = True
		  super.ShowModal
		  OkToClose = True
		  If Handle = Nil or DeleteEvent then
		    Close
		    Return Nil
		  else
		    
		    Dim lText As String = tfiTitle.Text
		    If StartDate = EndDate then
		      
		      If IsNumeric(lText.left(2)) and IsNumeric(lText.Middle(4, 2)) then
		        'StartDate.Hour = val(lText.left(2))
		        'StartDate.Minute = val(lText.Middle(4, 2))
		        StartDate = StartDate - New DateInterval(0,0,0,StartDate.Hour, StartDate.Minute) + New DateInterval(0,0,0,val(lText.left(2)),val(lText.Middle(4, 2)))
		        'EndDate.SQLDateTime = StartDate.SQLDateTime
		        'EndDate.Hour = EndDate.Hour + 1
		        EndDate = StartDate - New DateInterval(0,0,0,StartDate.Hour, StartDate.Minute) + New DateInterval(0,0,0,1)
		        lText = lText.Middle(7)
		      End If
		    End If
		    
		    If StartDate.SQLDate = EndDate.SQLDate and Chk_AllDay.Value then
		      'StartDate.Hour = 0
		      'StartDate.Minute = 0
		      'StartDate.Second = 0
		      'EndDate.SecondsFrom1970 = StartDate.SecondsFrom1970
		      StartDate = StartDate - New DateInterval(0,0,0,StartDate.Hour,StartDate.Minute,startdate.Second)
		      EndDate = New DateTime(StartDate)
		    elseif Chk_AllDay.Value = False then
		      'StartDate.Hour = val(Combo_Start.Text.NthField(":", 1))
		      'StartDate.Minute = val(Combo_Start.Text.NthField(":", 2))
		      StartDate = StartDate - New DateInterval(0,0,0,StartDate.Hour, StartDate.Minute) + New DateInterval(0,0,0,val(Combo_Start.Text.NthField(":", 1)),val(Combo_Start.Text.NthField(":", 2)))
		      'EndDate.Hour = val(Combo_End.Text.NthField(":", 1))
		      'EndDate.Minute = val(Combo_End.Text.NthField(":", 2))
		      EndDate = EndDate - New DateInterval(0,0,0,EndDate.Hour, EndDate.Minute) + New DateInterval(0,0,0,val(Combo_End.Text.NthField(":", 1)),val(Combo_End.Text.NthField(":", 2)))
		    End If
		    
		    
		    Dim location As String = tfiLocation.Text
		    Dim Description As String = tarDescription.Text
		    
		    
		    
		    Dim C As New CalendarEvent(lText, StartDate, EndDate, Colors(SelectColor), location, Description)
		    
		    If Chk_Repeat.value then
		      C.Recurrence = CreateRecurrence()
		    End If
		    Close
		    C.Editable = True
		    Return C
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub UpdateSummary()
		  Dim lText As String
		  
		  Select case Popup_Repeat.RowTagAt(Popup_Repeat.SelectedRowIndex)
		    
		  Case "Daily"
		    
		    If Popup_Interval.SelectedRowValue = "1" then
		      
		      lText = "Daily"
		      
		    Else
		      
		      lText = "Every " + Popup_Interval.SelectedRowValue + " days"
		    End If
		    
		  Case "Weekday"
		    
		    lText = "Weekly on weekdays"
		    
		  Case "Weekly"
		    
		    Dim FoundDay As Boolean
		    
		    If Popup_Interval.SelectedRowValue = "1" then
		      lText = "Weekly on "
		      
		    Else
		      lText = "Every " + Popup_Interval.SelectedRowValue + " weeks on "
		    End If
		    
		    If sgbDays.SegmentAt(0).Selected and sgbDays.SegmentAt(1).Selected and sgbDays.SegmentAt(2).Selected and _
		      sgbDays.SegmentAt(3).Selected and sgbDays.SegmentAt(4).Selected and sgbDays.SegmentAt(5).Selected and _
		      sgbDays.SegmentAt(6).Selected then
		      lText = lText + "all days"
		      
		    Elseif sgbDays.SegmentAt(0).Selected and sgbDays.SegmentAt(1).Selected and sgbDays.SegmentAt(2).Selected and _
		      sgbDays.SegmentAt(3).Selected and sgbDays.SegmentAt(4).Selected then
		      
		      lText = lText + "weekdays"
		      
		    elseif not sgbDays.SegmentAt(0).Selected and not sgbDays.SegmentAt(1).Selected and not sgbDays.SegmentAt(2).Selected and _
		      not sgbDays.SegmentAt(3).Selected and not sgbDays.SegmentAt(4).Selected and sgbDays.SegmentAt(5).Selected and _
		      sgbDays.SegmentAt(6).Selected then
		      
		      lText = lText + "week-end days"
		      
		    Else
		      
		      If sgbDays.SegmentAt(0).Selected then
		        lText = lText + CalendarView.DayNames(2) + ", "
		        FoundDay = True
		      End If
		      If sgbDays.SegmentAt(1).Selected then
		        lText = lText + CalendarView.DayNames(3) + ", "
		        FoundDay = True
		      End If
		      If sgbDays.SegmentAt(2).Selected then
		        lText = lText + CalendarView.DayNames(4) + ", "
		        FoundDay = True
		      End If
		      If sgbDays.SegmentAt(3).Selected then
		        lText = lText + CalendarView.DayNames(5) + ", "
		        FoundDay = True
		      End If
		      If sgbDays.SegmentAt(4).Selected then
		        lText = lText + CalendarView.DayNames(6) + ", "
		        FoundDay = True
		      End If
		      If sgbDays.SegmentAt(5).Selected then
		        lText = lText + CalendarView.DayNames(7) + ", "
		        FoundDay = True
		      End If
		      If sgbDays.SegmentAt(6).Selected then
		        lText = lText + CalendarView.DayNames(1) + ", "
		        FoundDay = True
		      End If
		      
		      If not FoundDay then
		        lText = lText + CalendarView.DayNames(StartDate.DayOfWeek)
		      End If
		      
		      If lText.Right(2) = ", " then
		        lText = lText.Left(lText.Length - 2)
		      End If
		      
		    End If
		    
		    
		    
		  Case "Monthly"
		    
		    If Popup_Interval.SelectedRowValue = "1" then
		      lText = "Monthly on "
		      
		    Else
		      lText = "Every " + Popup_Interval.SelectedRowValue + " months on "
		    End If
		    
		    lText = lText + "day " + str(StartDate.Day)
		    
		  Case "Monthly Relative"
		    
		    If Popup_Interval.SelectedRowValue = "1" then
		      lText = "Monthly on "
		      
		    Else
		      lText = "Every " + Popup_Interval.SelectedRowValue + " months on "
		    End If
		    
		    Select Case GetRelativeDay(StartDate)
		    Case CalendarRecurrence.RelativeFirst
		      lText = lText + "the first " + CalendarView.DayNames(StartDate.DayOfWeek)
		    Case CalendarRecurrence.RelativeSecond
		      lText = lText + "the second " + CalendarView.DayNames(StartDate.DayOfWeek)
		    Case CalendarRecurrence.RelativeThird
		      lText = lText + "the third " + CalendarView.DayNames(StartDate.DayOfWeek)
		    Case CalendarRecurrence.RelativeFourth
		      lText = lText + "the fourth " + CalendarView.DayNames(StartDate.DayOfWeek)
		    Case CalendarRecurrence.RelativeLast
		      lText = lText + "the last " + CalendarView.DayNames(StartDate.DayOfWeek)
		    End Select
		    
		    
		  Case "Yearly"
		    
		    If Popup_Interval.SelectedRowValue = "1" then
		      lText = "Annually on "
		      
		    Else
		      lText = "Every " + Popup_Interval.SelectedRowValue + " years on "
		    End If
		    
		    lText = lText + Trim(StartDate.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.Short).Replace(str(StartDate.Year), ""))
		    If lText.Right(1) = "," then
		      lText = lText.Left(lText.Length - 1)
		    End If
		    
		    
		  End Select
		  
		  if radioEnd(1).Value then
		    lbl_Summary.Text = lText + ", " + txtNb.Text + " times"
		  Elseif radioEnd(2).Value and RecurEndDate <> Nil Then
		    lbl_Summary.Text = lText + ", " + RecurEndDate.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None)
		  Else
		    lbl_Summary.Text = lText
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Colors() As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		DeleteEvent As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		EndDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOpen As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		OkToClose As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if me.Reference <> nil then
			    return CalendarView(me.Reference.Value)
			  else
			    return nil
			  end if
			End Get
		#tag EndGetter
		Private owner As CalendarView
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		RecurEndDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Reference As weakRef
	#tag EndProperty

	#tag Property, Flags = &h0
		ResizeWindow As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		SelectColor As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StartDate As DateTime
	#tag EndProperty


	#tag Constant, Name = klocalAfter, Type = String, Dynamic = True, Default = \"After", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Apr\xC3\xA8s"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"After"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Nach"
	#tag EndConstant

	#tag Constant, Name = klocalAllDay, Type = String, Dynamic = True, Default = \"All day", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Toute la journ\xC3\xA9e"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"All day"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Ganzt\xC3\xA4gig"
	#tag EndConstant

	#tag Constant, Name = klocalCancel, Type = String, Dynamic = True, Default = \"Cancel", Scope = Private
		#Tag Instance, Platform = Any, Language = en, Definition  = \"Cancel"
		#Tag Instance, Platform = Any, Language = en-GB, Definition  = \"Cancel"
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Annuler"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Abbrechen"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Cancel"
	#tag EndConstant

	#tag Constant, Name = klocalDaily, Type = String, Dynamic = True, Default = \"Daily", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Quotidien"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Daily"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"T\xC3\xA4glich"
	#tag EndConstant

	#tag Constant, Name = klocalDate, Type = String, Dynamic = True, Default = \"Date:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Date :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Date :"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Datum"
	#tag EndConstant

	#tag Constant, Name = klocalDays, Type = String, Dynamic = True, Default = \"days", Scope = Private
		#Tag Instance, Platform = Any, Language = en, Definition  = \"days"
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"jours"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Tage"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"days"
	#tag EndConstant

	#tag Constant, Name = klocalDelete, Type = String, Dynamic = True, Default = \"Delete", Scope = Private
		#Tag Instance, Platform = Any, Language = en, Definition  = \"Delete"
		#Tag Instance, Platform = Any, Language = en-GB, Definition  = \"Delete"
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Supprimer"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"L\xC3\xB6schen"
	#tag EndConstant

	#tag Constant, Name = klocalDescription, Type = String, Dynamic = True, Default = \"Description:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Description :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Description"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Beschreibung"
	#tag EndConstant

	#tag Constant, Name = klocalEnds, Type = String, Dynamic = True, Default = \"Ends:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Fin :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Ends:"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Endet am:"
	#tag EndConstant

	#tag Constant, Name = klocalLocation, Type = String, Dynamic = True, Default = \"Location:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Lieu :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Location :"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Ort"
	#tag EndConstant

	#tag Constant, Name = klocalMonthly, Type = String, Dynamic = True, Default = \"Monthly", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Mensuel"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Monthly"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Monatlich"
	#tag EndConstant

	#tag Constant, Name = klocalMonthlyRelative, Type = String, Dynamic = True, Default = \"Monthly relative", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Mensuel (jour de la semaine)"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Monthly relative"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Monatlich (relativ)"
	#tag EndConstant

	#tag Constant, Name = klocalMonths, Type = String, Dynamic = True, Default = \"months", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"months"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Months"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Monate"
	#tag EndConstant

	#tag Constant, Name = klocalNever, Type = String, Dynamic = True, Default = \"Never", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Never"
		#Tag Instance, Platform = Any, Language = en, Definition  = \"Never"
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Jamais"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Niemals"
	#tag EndConstant

	#tag Constant, Name = kLocalOccurences, Type = String, Dynamic = True, Default = \"Occurences", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Occurences"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Wiederholungen"
	#tag EndConstant

	#tag Constant, Name = kLocalOK, Type = String, Dynamic = True, Default = \"OK", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"OK"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"OK"
	#tag EndConstant

	#tag Constant, Name = klocalOn, Type = String, Dynamic = True, Default = \"On", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Le"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"On"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Am"
	#tag EndConstant

	#tag Constant, Name = klocalRepeat, Type = String, Dynamic = True, Default = \"Repeat", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"R\xC3\xA9currence"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Repeat"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Wiederholen"
	#tag EndConstant

	#tag Constant, Name = klocalRepeatEvery, Type = String, Dynamic = True, Default = \"Repeat every:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Fr\xC3\xA9quence :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Repeat every :"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Wiederholen alle :"
	#tag EndConstant

	#tag Constant, Name = klocalRepeaton, Type = String, Dynamic = True, Default = \"Repeat on:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"R\xC3\xA9p\xC3\xA9ter le :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Repeat on :"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Wiederholen am"
	#tag EndConstant

	#tag Constant, Name = klocalRepeats, Type = String, Dynamic = True, Default = \"Repeats:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"R\xC3\xA9currence :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Repeats :"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Wiederholung"
	#tag EndConstant

	#tag Constant, Name = kLocalStartsOn, Type = String, Dynamic = True, Default = \"Starts on:", Scope = Private
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Starts on:"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Beginnt am:"
	#tag EndConstant

	#tag Constant, Name = klocalSummary, Type = String, Dynamic = True, Default = \"Summary:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"R\xC3\xA9sum\xC3\xA9 :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Summary"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Zusammenfassung"
	#tag EndConstant

	#tag Constant, Name = klocalTitle, Type = String, Dynamic = True, Default = \"Title:", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Titre :"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Title :"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Titel"
	#tag EndConstant

	#tag Constant, Name = klocalTo, Type = String, Dynamic = True, Default = \"to", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"\xC3\xA0"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"to"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"bis"
	#tag EndConstant

	#tag Constant, Name = klocalWeekdays, Type = String, Dynamic = True, Default = \"Every weekday (Monday to Friday)", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Jours de la semaine (lundi au vendredi)"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Every weekday (Monday to Friday)"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Werktags (Montag bis Freitag)"
	#tag EndConstant

	#tag Constant, Name = klocalWeekly, Type = String, Dynamic = True, Default = \"Weekly", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Hebdomadaire"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Weekly"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"W\xC3\xB6chentlich"
	#tag EndConstant

	#tag Constant, Name = klocalWeeks, Type = String, Dynamic = True, Default = \"weeks", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"semaines"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"weeks"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Wochen"
	#tag EndConstant

	#tag Constant, Name = klocalYearly, Type = String, Dynamic = True, Default = \"Yearly", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Annuel"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Yearly"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"J\xC3\xA4hrlich"
	#tag EndConstant

	#tag Constant, Name = klocalYears, Type = String, Dynamic = True, Default = \"years", Scope = Private
		#Tag Instance, Platform = Any, Language = fr, Definition  = \"ann\xC3\xA9es"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"years"
		#Tag Instance, Platform = Any, Language = de, Definition  = \"Jahre"
	#tag EndConstant


#tag EndWindowCode

#tag Events tfiTitle
	#tag Event
		Function KeyDown(key As String) As Boolean
		  If key = EndOfLine or key = Chr(13) then
		    btnOK.Press
		    Return True
		  End If
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events btnOK
	#tag Event
		Sub Pressed()
		  
		  If Val(Combo_End.Text) > Val(Combo_Start.Text) or Chk_AllDay.Value then
		    Hide
		    Return
		  elseif Val(Combo_End.Text) = Val(Combo_Start.Text) then
		    If Val(Combo_End.Text.Middle(4)) > Val(Combo_Start.Text.Middle(4)) then
		      Hide
		      Return
		    End If
		  End If
		  
		  MsgBox("End Time cannot be smaller than start time")
		  Combo_End.SetFocus
		  Combo_End.SelectionStart = 0
		  Combo_End.SelectionLength = Combo_End.Text.Length
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events lblDateSelection
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #Pragma Unused Y
		  
		  Dim w As New DatePickerWindow
		  Dim d As DateTime
		  
		  If StartDate.SQLDate = EndDate.SQLDate then
		    
		    d = w.showmodal(self.left + me.Left, self.top + me.top + me.Height, me, StartDate)
		    
		    If d <> Nil then
		      StartDate = d
		      EndDate = d
		      lblDateSelection.Text = StartDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		    End If
		    
		  else
		    
		    Dim diff As Double = EndDate.SecondsFrom1970 - StartDate.SecondsFrom1970
		    If X < me.Width\2 then
		      
		      d = w.showmodal(self.left + me.Left, self.top + me.top + me.Height, me,  StartDate)
		      
		      If d <> Nil then
		        StartDate = d
		        If StartDate > EndDate then
		          EndDate = StartDate + new DateInterval(0,0,0,0,0,diff)
		        End If
		      End If
		      
		    else
		      
		      d = w.showmodal(self.left + me.Left, self.top + me.top + me.Height, me, EndDate)
		      
		      If d <> Nil then
		        EndDate = d
		        If StartDate.SecondsFrom1970 > EndDate.SecondsFrom1970 then
		          StartDate = EndDate - new DateInterval(0,0,0,0,0,diff)
		        End If
		      End If
		      
		    End If
		    
		    lblDateSelection.Text = StartDate.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None) + " - " + EndDate.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None)
		    
		  End If
		  
		  If owner <> Nil then
		    owner.Redisplay()
		  End If
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  me.Underline = True
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  me.Underline = False
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events cnvColor
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas
		  
		  Dim x, i As Integer
		  
		  For i = 0 to Colors.LastIndex
		    
		    g.DrawingColor = Colors(i)
		    
		    g.FillRectangle(x, 0, me.Height,me.Height)
		    
		    If i = SelectColor then
		      g.DrawingColor = FrameColor
		      g.DrawRectangle(x+1, 1, me.Height-2, me.Height-2)
		      g.DrawingColor = &cFFFFFF
		      g.DrawRectangle(x+2, 2, me.Height-4, me.Height-4)
		    End If
		    
		    x = x + me.Height + 3
		  Next
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #pragma Unused Y
		  
		  Dim xx As Integer
		  
		  For i as Integer = 0 to me.Width
		    If x >= xx and x < xx + me.Height then
		      SelectColor = i
		      me.Refresh(False)
		      Return True
		    End If
		    xx = xx + 3 + me.Height
		    
		    If xx > (me.Height + 3) * Colors.LastIndex then
		      exit for i
		    End If
		  Next
		  
		  SelectColor = 0
		  me.Refresh(False)
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events tfiLocation
	#tag Event
		Function KeyDown(key As String) As Boolean
		  If key = EndOfLine or key = Chr(13) then
		    btnOK.Press
		    Return True
		  End If
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events DeleteButton
	#tag Event
		Sub Pressed()
		  DeleteEvent = True
		  Hide()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Combo_Start
	#tag Event
		Sub Opening()
		  For i as Integer = 0 to 47
		    
		    If i mod 2 = 0 then
		      me.AddRow Str(Floor(i/2), "0#") + ":00"
		    else
		      me.AddRow Str(Floor(i/2), "0#") + ":30"
		    End If
		  Next
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub FocusLost()
		  If IsNumeric(me.Text.Left(2)) and IsNumeric(me.Text.Middle(4)) and me.Text.Middle(3, 1) = ":" then
		    //nothing
		    
		  else
		    Dim hours As Integer
		    Dim minutes As Integer
		    
		    If len(me.Text) = 4 and val(me.Text)<=2359 and val(me.Text.Middle(3, 2))<60 then
		      hours = val(me.Text.left(2))
		      minutes = val(me.Text.Middle(3,2))
		    else
		      
		      hours = min(23, val(me.Text))
		      minutes = min(60, val(me.Text.NthField(":", 2)))
		    End If
		    
		    me.Text = str(hours, "0#") + ":" + str(minutes, "0#")
		  End If
		  
		  Dim LastText As String = Combo_End.Text
		  
		  Combo_End.RemoveAllRows
		  Dim start As Integer
		  If val(me.Text.Middle(4))>0 then
		    start = val(me.Text)*2+2
		  else
		    start = val(me.Text)*2+1
		  End If
		  For i as Integer = start to 47
		    
		    If i mod 2 = 0 then
		      Combo_End.AddRow Str(Floor(i/2), "0#") + ":00"
		    else
		      Combo_End.AddRow Str(Floor(i/2), "0#") + ":30"
		    End If
		  Next
		  
		  Combo_End.Text = LastText
		  
		  If Val(Combo_End.Text)<=Val(Combo_Start.Text) then
		    Combo_End.SelectedRowIndex = 0
		  End If
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function KeyDown(key As String) As Boolean
		  
		  If asc(key)<=58 and asc(key)>=(48) then
		    //nothing
		  elseif asc(key)<32 then
		    //nothing
		  else
		    Return True
		  End If
		End Function
	#tag EndEvent
	#tag Event
		Sub TextChanged()
		  Dim LastText As String = Combo_End.Text
		  
		  Combo_End.RemoveAllRows
		  Dim start As Integer
		  If val(me.Text.Middle(4))>0 then
		    start = val(me.Text)*2+2
		  else
		    start = val(me.Text)*2+1
		  End If
		  For i as Integer = start to 47
		    
		    If i mod 2 = 0 then
		      Combo_End.AddRow Str(Floor(i/2), "0#") + ":00"
		    else
		      Combo_End.AddRow Str(Floor(i/2), "0#") + ":30"
		    End If
		  Next
		  
		  Combo_End.Text = LastText
		  
		  If Val(Combo_End.Text)<=Val(Combo_Start.Text) then
		    Combo_End.SelectedRowIndex = 0
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  Dim LastText As String = Combo_End.Text
		  
		  Combo_End.RemoveAllRows
		  Dim start As Integer
		  If val(me.Text.Middle(4))>0 then
		    start = val(me.Text)*2+2
		  else
		    start = val(me.Text)*2+1
		  End If
		  For i as Integer = start to 47
		    
		    If i mod 2 = 0 then
		      Combo_End.AddRow Str(Floor(i/2), "0#") + ":00"
		    else
		      Combo_End.AddRow Str(Floor(i/2), "0#") + ":30"
		    End If
		  Next
		  
		  Combo_End.Text = LastText
		  
		  If Val(Combo_End.Text)<=Val(Combo_Start.Text) then
		    Combo_End.SelectedRowIndex = 0
		  End If
		  
		  
		  if mOpen then
		    Var lNewHour As Double = val(Combo_Start.Text.NthField(":", 1))
		    Var lNewMin As Double = val(Combo_Start.Text.NthField(":", 2))
		    StartDate = StartDate - new DateInterval(0,0,0,StartDate.Hour,StartDate.Minute) + new DateInterval(0,0,0,lNewHour,lNewMin)
		    lNewHour = val(Combo_End.Text.NthField(":", 1))
		    lNewMin = val(Combo_End.Text.NthField(":", 2))
		    EndDate = EndDate - new DateInterval(0,0,0,EndDate.Hour,EndDate.Minute) + new DateInterval(0,0,0,lNewHour,lNewMin)
		    
		    If owner <> Nil then
		      owner.Redisplay
		    End If
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Combo_End
	#tag Event
		Sub Opening()
		  For i as Integer = 0 to 47
		    
		    If i mod 2 = 0 then
		      me.AddRow Str(Floor(i/2), "0#") + ":00"
		    else
		      me.AddRow Str(Floor(i/2), "0#") + ":30"
		    End If
		  Next
		End Sub
	#tag EndEvent
	#tag Event
		Function KeyDown(key As String) As Boolean
		  
		  
		  If asc(key)<=58 and asc(key)>=(48) then
		    //nothing
		  elseif asc(key)<32 then
		    //nothing
		  else
		    Return True
		  End If
		End Function
	#tag EndEvent
	#tag Event
		Sub FocusLost()
		  If IsNumeric(me.Text.Left(2)) and IsNumeric(me.Text.Middle(4)) and me.Text.Middle(3, 1) = ":" then
		    //nothing
		    
		  else
		    Dim hours As Integer
		    Dim minutes As Integer
		    
		    If len(me.Text) = 4 and val(me.Text)<=2359 and val(me.Text.Middle(3, 2))<60 then
		      hours = val(me.Text.left(2))
		      minutes = val(me.Text.Middle(3,2))
		    else
		      
		      hours = min(23, val(me.Text))
		      minutes = min(60, val(me.Text.NthField(":", 2)))
		    End If
		    
		    me.Text = str(hours, "0#") + ":" + str(minutes, "0#")
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  
		  if mOpen then
		    Var lNewHour As Double = val(Combo_Start.Text.NthField(":", 1))
		    Var lNewMin As Double = val(Combo_Start.Text.NthField(":", 2))
		    StartDate = StartDate - new DateInterval(0,0,0,StartDate.Hour,StartDate.Minute) + new DateInterval(0,0,0,lNewHour,lNewMin)
		    lNewHour = val(Combo_End.Text.NthField(":", 1))
		    lNewMin = val(Combo_End.Text.NthField(":", 2))
		    EndDate = EndDate - new DateInterval(0,0,0,EndDate.Hour,EndDate.Minute) + new DateInterval(0,0,0,lNewHour,lNewMin)
		    
		    If owner <> Nil then
		      owner.Redisplay
		    End If
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Chk_AllDay
	#tag Event
		Sub ValueChanged()
		  
		  
		  Combo_Start.Enabled = not me.Value
		  Combo_End.Enabled = not me.Value
		  Lbl_To.Enabled = not me.Value
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Popup_Repeat
	#tag Event
		Sub Opening()
		  
		  
		  //You are free to change this text
		  'me.AddRow "Daily"
		  'me.AddRow "Every weekday (Monday to Friday)"
		  'me.AddRow "Weekly"
		  'me.AddRow "Monthly"
		  'me.AddRow "Monthly Relative"
		  'me.AddRow "Yearly"
		  
		  me.AddRow klocalDaily
		  me.AddRow klocalWeekdays
		  me.AddRow klocalWeekly
		  me.AddRow klocalMonthly
		  me.AddRow klocalMonthlyRelative
		  me.AddRow klocalYearly
		  
		  
		  //Do not change the text of the rowtags or you will need to change the code in CreateRecurrence and the Change event.
		  me.RowTagAt(0) = "Daily"
		  me.RowTagAt(1) = "Weekday"
		  me.RowTagAt(2) = "Weekly"
		  me.RowTagAt(3) = "Monthly"
		  me.RowTagAt(4) = "Monthly Relative"
		  me.RowTagAt(5) = "Yearly"
		  
		  me.SelectedRowIndex = 0
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  Dim a As String
		  a = me.RowTagAt(me.SelectedRowIndex)
		  Select case me.RowTagAt(me.SelectedRowIndex)
		    
		  Case "Daily"
		    
		    lblRepeatOn.Visible = False
		    sgbDays.Visible = False
		    
		    lblRepeatInterval.Visible = True
		    Popup_Interval.Visible = True
		    lblRepeatUnit.Visible = True
		    
		    lblRepeatUnit.Text = klocalDays
		    
		  Case "Weekday"
		    
		    lblRepeatOn.Visible = False
		    sgbDays.Visible = False
		    
		    lblRepeatInterval.Visible = False
		    Popup_Interval.Visible = False
		    lblRepeatUnit.Visible = False
		    
		  Case "Weekly"
		    
		    lblRepeatOn.Visible = True
		    sgbDays.Visible = True
		    
		    lblRepeatInterval.Visible = True
		    Popup_Interval.Visible = True
		    lblRepeatUnit.Visible = True
		    
		    lblRepeatUnit.Text = klocalWeeks
		    
		  Case "Monthly"
		    
		    lblRepeatOn.Visible = True
		    sgbDays.Visible = False
		    
		    lblRepeatInterval.Visible = True
		    Popup_Interval.Visible = True
		    lblRepeatUnit.Visible = True
		    
		    lblRepeatUnit.text = klocalMonths
		    
		  Case "Monthly Relative"
		    
		    lblRepeatOn.Visible = True
		    sgbDays.Visible = False
		    
		    lblRepeatInterval.Visible = True
		    Popup_Interval.Visible = True
		    lblRepeatUnit.Visible = True
		    
		    lblRepeatUnit.text = klocalMonths
		    
		  Case "Yearly"
		    
		    lblRepeatOn.Visible = False
		    sgbDays.Visible = False
		    
		    lblRepeatInterval.Visible = True
		    Popup_Interval.Visible = True
		    lblRepeatUnit.Visible = True
		    
		    lblRepeatUnit.text = klocalyears
		    
		    
		    
		  End Select
		  
		  
		  UpdateSummary()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Popup_Interval
	#tag Event
		Sub Opening()
		  For i as Integer = 1 to 30
		    me.AddRow str(i)
		  Next
		  
		  me.SelectedRowIndex = 0
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  UpdateSummary()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events radioEnd
	#tag Event
		Sub ValueChanged(index as Integer)
		  #Pragma Unused index
		  
		  UpdateSummary()
		  
		  If radioEnd(2).Value then
		    lblEndDate.Enabled = True
		    txtNb.Enabled = False
		  Elseif radioEnd(1).Value then
		    lblEndDate.Enabled = False
		    txtNb.Enabled = True
		  Else
		    lblEndDate.Enabled = False
		    txtNb.Enabled = False
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events txtNb
	#tag Event
		Sub TextChanged()
		  UpdateSummary()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events sgbDays
	#tag Event
		Sub Opening()
		  If CalendarView.DayNames(1) = "" then Return
		  
		  For i as Integer = 0 to 6
		    
		    me.SegmentAt(i).Title = CalendarView.DayNames((i+1) mod 7 + 1).Left(2).Uppercase
		    
		  Next
		  
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Pressed(segmentIndex As Integer)
		  #Pragma Unused segmentIndex
		  
		  UpdateSummary()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events lblEndDate
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  Dim w As New DatePickerWindow
		  Dim d As DateTime
		  If RecurEndDate is Nil then
		    RecurEndDate = DateTime.Now
		  End If
		  
		  d = w.showmodal(self.left + me.Left, self.top + me.top + me.Height, me, RecurEndDate)
		  
		  If d <> Nil then
		    RecurEndDate = d
		    me.Text = d.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		    UpdateSummary()
		  End If
		  
		  
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  If me.Enabled then
		    me.Underline = True
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  
		  me.Underline = False
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Chk_Repeat
	#tag Event
		Sub ValueChanged()
		  'If me.Value then
		  'self.Width = 787
		  '
		  'else
		  'self.Width = 375
		  'End If
		  Dim delta As Integer = 787-375
		  
		  
		  if not me.value then
		    self.animate new Xojo.Rect(self.left+delta/2,self.top,self.width-delta,self.height),0.25, AKEasing.kLinearTween
		  elseif ResizeWindow then
		    self.animate new Xojo.Rect(self.left-delta/2,self.top,self.width+delta,self.height),0.25,AKEasing.kLinearTween
		  else
		    self.Width = 787
		  end
		  
		  ResizeWindow = True
		  
		  'self.Left = Self.owner.TrueWindow.Left + (self.owner.TrueWindow.Width - self.Width)\2
		  
		  btnOK.Left = self.Width-btnOK.Width-20
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="SelectColor"
		Visible=false
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="OkToClose"
		Visible=false
		Group="Behavior"
		InitialValue="0"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DeleteEvent"
		Visible=false
		Group="Behavior"
		InitialValue="0"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ResizeWindow"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
