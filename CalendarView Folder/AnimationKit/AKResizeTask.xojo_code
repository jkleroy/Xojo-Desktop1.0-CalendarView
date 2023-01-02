#tag Class
Protected Class AKResizeTask
Inherits AKTask
	#tag Event
		Sub Started()
		  if me.item isa DesktopUIControl then
		    me.moriginalwidth = DesktopUIControl(me.item).width
		    me.moriginalheight = DesktopUIControl(me.item).height
		  else
		    me.moriginalwidth = window(me.item.objectvalue).width
		    me.moriginalheight = window(me.item.objectvalue).height
		  end
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1000
		Sub Constructor(TheItem As DesktopUIControl)
		  me.item = theitem
		  me.width = theitem.width
		  me.height = theitem.height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(TheItem As Window)
		  me.item = theitem
		  me.width = theitem.width
		  me.height = theitem.height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCompleted() As Boolean
		  return (me.runtime >= (me.duration * 1000000))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OriginalHeight() As Integer
		  return me.moriginalheight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OriginalWidth() As Integer
		  return me.moriginalwidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Perform(Final As Boolean = False)
		  if final then
		    if me.item isa DesktopUIControl then
		      DesktopUIControl(me.item).width = me.width
		      DesktopUIControl(me.item).height = me.height
		    else
		      window(me.item.objectvalue).width = me.width
		      window(me.item.objectvalue).height = me.height
		    end
		  else
		    dim start,delta,newwidth,newheight as integer
		    
		    start = me.moriginalwidth
		    delta = me.width - start
		    newwidth = AKEasing.GetEaseValue(me.easingmethod,me.runtime,start,delta,me.duration * 1000000)
		    
		    start = me.moriginalheight
		    delta = me.height - start
		    newheight = AKEasing.GetEaseValue(me.easingmethod,me.runtime,start,delta,me.duration * 1000000)
		    
		    if me.item isa DesktopUIControl then
		      DesktopUIControl(me.item).width = newwidth
		      DesktopUIControl(me.item).height = newheight
		    else
		      window(me.item.objectvalue).width = newwidth
		      window(me.item.objectvalue).height = newheight
		    end
		  end
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Duration As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		EasingMethod As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Height As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Width As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EasingMethod"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
