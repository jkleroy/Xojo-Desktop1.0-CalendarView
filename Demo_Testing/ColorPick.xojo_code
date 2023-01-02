#tag Class
Protected Class ColorPick
Inherits DesktopCanvas
	#tag Event
		Sub Activated()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub Closing()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Function ConstructContextualMenu(base As DesktopMenuItem, x As Integer, y As Integer) As Boolean
		  #pragma Unused base
		  #pragma Unused x
		  #pragma Unused y
		End Function
	#tag EndEvent

	#tag Event
		Function ContextualMenuItemSelected(selectedItem As DesktopMenuItem) As Boolean
		  #pragma Unused selectedItem
		End Function
	#tag EndEvent

	#tag Event
		Sub Deactivated()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub DoublePressed(x As Integer, y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		End Sub
	#tag EndEvent

	#tag Event
		Function DragEnter(obj As DragItem, action As DragItem.Types) As Boolean
		  #pragma Unused obj
		  #pragma Unused action
		End Function
	#tag EndEvent

	#tag Event
		Sub DragExit(obj As DragItem, action As DragItem.Types)
		  #pragma Unused obj
		  #pragma Unused action
		End Sub
	#tag EndEvent

	#tag Event
		Function DragOver(x As Integer, y As Integer, obj As DragItem, action As DragItem.Types) As Boolean
		  #pragma Unused x
		  #pragma Unused y
		  #pragma Unused obj
		  #pragma Unused action
		End Function
	#tag EndEvent

	#tag Event
		Sub DropObject(obj As DragItem, action As DragItem.Types)
		  #pragma Unused obj
		  #pragma Unused action
		End Sub
	#tag EndEvent

	#tag Event
		Sub FocusLost()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub FocusReceived()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  #pragma Unused Key
		End Function
	#tag EndEvent

	#tag Event
		Sub KeyUp(key As String)
		  #pragma Unused Key
		End Sub
	#tag EndEvent

	#tag Event
		Sub MenuBarSelected()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  
		  'Dim w As new ColorWheelWindow
		  
		  'w.Show(myColor, self, 420)
		  'w.Show(&cFFFFFF, Self)
		  
		  If Checkbox then
		    me.Value = not me.Value
		    Action()
		    Refresh(False)
		    
		  else
		    
		    If SelectColor(myColor, "") then
		      ColorChange
		      Refresh(False)
		    End If
		    
		  End If
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(x As Integer, y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(x As Integer, y As Integer, deltaX As Integer, deltaY As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  #pragma Unused deltaX
		  #pragma Unused deltaY
		End Function
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas
		  
		  If Checkbox and me.Value = False then
		    
		    g.ForeColor = &cFFFFFF
		    g.FillRect(0,0, g.Width, g.Height)
		    
		    g.ForeColor = &c0
		    
		    Dim i As Integer
		    For i = 0 to Width*2 Step 3
		      
		      g.DrawLine(0, i, i, 0)
		      
		    Next
		    
		    
		    Dim p As Picture = New Picture(Width, Height, 32)
		    Dim gp As Graphics = p.Graphics
		    gp.ForeColor = myColor
		    gp.FillRect(0, 0, gp.Width, gp.Height)
		    
		    gp = p.Mask.Graphics
		    gp.ForeColor = &cA0A0A0
		    gp.FillRect(0, 0, gp.Width, gp.Height)
		    
		    g.DrawPicture(p, 0, 0)
		    
		  else
		    
		    g.ForeColor = myColor
		    g.FillRect(0,0, g.Width, g.Height)
		    
		  End If
		  
		  g.ForeColor = &c0
		  g.DrawRect(0,0, g.Width, g.Height)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub SetColor(C As Color)
		  myColor = C
		  ColorChange
		  
		  Refresh(False)
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Action()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ColorChange()
	#tag EndHook


	#tag Property, Flags = &h0
		Checkbox As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		myColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		Value As Boolean = True
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="20"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="20"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
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
			Name="myColor"
			Visible=true
			Group="Appearance"
			InitialValue="&h000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Checkbox"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
