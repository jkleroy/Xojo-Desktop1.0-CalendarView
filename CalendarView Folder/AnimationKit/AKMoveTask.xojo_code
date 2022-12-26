#tag Class
Protected Class AKMoveTask
Inherits AKTask
	#tag Event
		Sub Started()
		  me.pstartrect = me.getcurrentrect
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(TheItem As DesktopUIControl)
		  me.item = theitem
		  me.newrect = theitem.contentrect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TheItem As DesktopUIControl, TheNewRect As Xojo.Rect, TheDuration As Double, EasingMethod As Integer = 0)
		  me.item = theitem
		  me.newrect = thenewrect
		  me.duration = theduration
		  me.easingmethod = easingmethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TheItem As DesktopWindow)
		  me.item = theitem
		  me.NewRect = TheItem.contentrect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TheItem As DesktopWindow, TheNewRect As Xojo.Rect, TheDuration As Double, EasingMethod As Integer = 0)
		  me.item = theitem
		  me.newrect = thenewrect
		  me.duration = theduration
		  me.easingmethod = easingmethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Delta() As Xojo.Rect
		  dim r,delta as Xojo.Rect
		  r = me.originalrect
		  delta = new Xojo.Rect
		  delta.top = newrect.top - r.top
		  delta.left = newrect.left - r.left
		  delta.width = newrect.width - r.width
		  delta.height = newrect.height - r.height
		  return delta
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCurrentRect() As Xojo.Rect
		  if item isa DesktopUIControl then
		    return DesktopUIControl(item).contentrect
		  elseif item isa DesktopWindow then
		    return DesktopWindow(item.objectvalue).contentrect
		  else
		    // Somehow, item has become something that is not a Window or DesktopUIControl
		    break
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCompleted() As Boolean
		  return (me.runtime >= (me.duration * 1000000))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OriginalRect() As Xojo.Rect
		  return me.pstartrect
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Perform(Final As Boolean = False)
		  if final then
		    me.setrectnow me.newrect
		  else
		    dim start,delta,change as Xojo.Rect
		    start = me.originalrect
		    delta = me.delta
		    
		    // new code
		    change = new Xojo.Rect
		    change.top = floor(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.top,delta.top,me.duration * 1000000))
		    change.left = floor(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.left,delta.left,me.duration * 1000000))
		    change.width = Ceiling(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.width,delta.width,me.duration * 1000000))
		    change.height = Ceiling(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.height,delta.height,me.duration * 1000000))
		    
		    me.setrectnow change
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetRectNow(NewRect As Xojo.Rect)
		  if item isa DesktopUIControl then
		    DesktopUIControl(item).contentrect = newrect
		  elseif item isa window then
		    DesktopWindow(item.objectvalue).contentrect = newrect
		  else
		    // Somehow, item has become something that is not a Window or DesktopUIControl
		    break
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
		NewRect As Xojo.Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pStartRect As Xojo.Rect
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
	#tag EndViewBehavior
End Class
#tag EndClass
