#tag Window
Begin Window DatePickerWindow
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   False
   Composite       =   False
   Frame           =   2
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   165
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   1040
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   False
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   False
   Title           =   ""
   Visible         =   True
   Width           =   207
   Begin Timer Timer1
      Enabled         =   True
      Index           =   -2147483648
      InitialParent   =   ""
      LockedInPosition=   False
      Period          =   100
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   "0"
   End
   Begin CalendarView CalendarPicker
      AdaptWeeksPerMonth=   True
      AllowAutoDeactivate=   True
      AllowFocus      =   True
      AllowFocusRing  =   False
      AllowTabs       =   False
      Animate         =   False
      Backdrop        =   0
      Border          =   True
      ColorWeekend    =   False
      CreateWithDrag  =   False
      DayEndHour      =   0.0
      DayStartHour    =   0.0
      DisableScroll   =   False
      DisplayWeeknumber=   False
      DoubleBuffer    =   False
      DragEvents      =   False
      Enabled         =   True
      EraseBackground =   False
      FilterEvents    =   False
      FirstDayOfWeek  =   ""
      ForceAM_PM      =   False
      Freeze          =   False
      Height          =   165
      HelpTagFormat   =   ""
      HighlightLockedEvents=   False
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockDayEventsHeight=   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      minHGap         =   0
      minHourHeight   =   0
      minVGap         =   0
      Scope           =   0
      ScrollPosition  =   0.0
      StyleType       =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      TransparentBackground=   False
      ViewDays        =   5
      ViewType        =   0
      Visible         =   True
      VisibleHours    =   0
      WeekHeaderTextFormat=   ""
      Width           =   207
      YearHeatMap     =   False
      YearMonthsAmount=   0
      YearMultipleEvents=   False
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Deactivate()
		  hide()
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #Pragma Unused x
		  #Pragma Unused y
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  #if TargetWin32
		    Const WS_BORDER = &H800000
		    ChangeWindowStyle( self, WS_BORDER, false )
		    
		    Const WS_CAPTION = &h00C00000
		    ChangeWindowStyle( self, WS_CAPTION, false )
		  #endif
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AddChildWindowOrderedAbove(wParent as Window, wChild as Window)
		  //# Adds a given window as a child window of the window.
		  
		  //@After the childWindow is added as a child of the window, it is maintained in relative position _
		  // indicated by orderingMode for subsequent ordering operations involving either window. _
		  // While this attachment is active, moving childWindow will not cause the window to move _
		  // (as in sliding a drawer in or out), but moving the window will cause childWindow to move.
		  
		  //@Note that you should not create cycles between parent and child windows. _
		  // For example, you should not add window B as child of window A, then add window A as a child of window B.
		  
		  //@This code will summon the ChildWindow but leaves it inactive. _
		  // You'll still have to manually call the ChildWindow.Show method to 'activate' the ChildWindow.
		  
		  #if TargetCocoa then
		    declare sub addChildWindow lib "Cocoa" selector "addChildWindow:ordered:" (WindowRef As Integer, ChildWindowRef as Integer, OrderingMode as Integer)
		    
		    addChildWindow wParent.Handle, wChild.Handle, 1
		  #else
		    #pragma Unused wParent
		    #pragma Unused wChild
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ChangeWindowStyle(w as Window, flag as Integer, set as Boolean)
		  #Pragma Unused w
		  
		  #if TargetWin32
		    Dim oldFlags as Integer
		    Dim newFlags as Integer
		    Dim styleFlags As Integer
		    
		    Const SWP_NOSIZE = &H1
		    Const SWP_NOMOVE = &H2
		    Const SWP_NOZORDER = &H4
		    Const SWP_FRAMECHANGED = &H20
		    
		    Const GWL_STYLE = -16
		    
		    Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (hwnd As Integer,  _
		    nIndex As Integer) As Integer
		    Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (hwnd As Integer, _
		    nIndex As Integer, dwNewLong As Integer) As Integer
		    Declare Function SetWindowPos Lib "user32" (hwnd as Integer, hWndInstertAfter as Integer, _
		    x as Integer, y as Integer, cx as Integer, cy as Integer, flags as Integer) as Integer
		    
		    oldFlags = GetWindowLong(w.WinHWND, GWL_STYLE)
		    
		    if not set then
		      newFlags = BitwiseAnd( oldFlags, Bitwise.OnesComplement( flag ) )
		    else
		      newFlags = BitwiseOr( oldFlags, flag )
		    end
		    
		    
		    styleFlags = SetWindowLong( w.WinHWND, GWL_STYLE, newFlags )
		    styleFlags = SetWindowPos( w.WinHWND, 0, 0, 0, 0, 0, SWP_NOMOVE +_
		    SWP_NOSIZE + SWP_NOZORDER + SWP_FRAMECHANGED )
		    
		  #else
		    #Pragma Unused flag
		    #Pragma Unused set
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function show(left as integer, top as integer, owner As RectControl, SelectedDate As Date = Nil) As Date
		  //get options
		  If SelectedDate <> Nil then
		    CalendarPicker.DisplayDate = SelectedDate
		  else
		    CalendarPicker.DisplayDate = new Date
		  End If
		  
		  me.Left = Left
		  me.Top = top
		  
		  if me.top + me.Height > Screen(0).Height then
		    me.Top = Screen(0).Height - me.Height
		  end if
		  
		  AddChildWindowOrderedAbove(owner.Window, self)
		  
		  Super.Show
		  super.SetFocus
		  
		  
		  StartTimer
		  Return self.SelectedDate
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function showmodal(left as integer, top as integer, owner As RectControl, SelectedDate As Date = Nil) As Date
		  //get options
		  If SelectedDate <> Nil then
		    CalendarPicker.DisplayDate = SelectedDate
		  else
		    CalendarPicker.DisplayDate = new Date
		  End If
		  
		  me.Left = Left
		  me.Top = top
		  
		  if me.top + me.Height > Screen(0).Height then
		    me.Top = Screen(0).Height - me.Height
		  end if
		  
		  AddChildWindowOrderedAbove(owner.Window, self)
		  
		  Super.ShowModal
		  super.SetFocus
		  
		  
		  StartTimer
		  Return self.SelectedDate
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StartTimer()
		  //this is a workaround to close the window without crashing, don't know why
		  timer1.Mode = timer.ModeSingle
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private optionSubmitted As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SelectedDate As Date
	#tag EndProperty


#tag EndWindowCode

#tag Events Timer1
	#tag Event
		Sub Action()
		  self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CalendarPicker
	#tag Event
		Sub Open()
		  me.ViewType = me.TypePicker
		  me.MyStyle.MFirstDayOfMonthBold = False
		End Sub
	#tag EndEvent
	#tag Event
		Sub DateSelected(D As Date)
		  SelectedDate = new Date(d)
		  
		  Hide()
		End Sub
	#tag EndEvent
	#tag Event
		Sub LostFocus()
		  Hide()
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
		Type="Color"
		EditorType="Color"
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
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="300"
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
		InitialValue="False"
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
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
