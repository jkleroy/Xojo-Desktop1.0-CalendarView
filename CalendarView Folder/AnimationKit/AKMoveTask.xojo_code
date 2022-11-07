#tag Class
Protected Class AKMoveTask
Inherits AKTask
	#tag Event
		Sub Started()
		  me.pstartrect = me.getcurrentrect
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(TheItem As RectControl)
		  me.item = theitem
		  me.newrect = theitem.contentrect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TheItem As RectControl, TheNewRect As REALbasic.Rect, TheDuration As Double, EasingMethod As Integer = 0)
		  me.item = theitem
		  me.newrect = thenewrect
		  me.duration = theduration
		  me.easingmethod = easingmethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TheItem As Window)
		  me.item = theitem
		  me.newrect = theitem.contentrect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TheItem As Window, TheNewRect As REALbasic.Rect, TheDuration As Double, EasingMethod As Integer = 0)
		  me.item = theitem
		  me.newrect = thenewrect
		  me.duration = theduration
		  me.easingmethod = easingmethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Delta() As REALbasic.Rect
		  dim r,delta as REALbasic.Rect
		  r = me.originalrect
		  delta = new realbasic.rect
		  delta.top = newrect.top - r.top
		  delta.left = newrect.left - r.left
		  delta.width = newrect.width - r.width
		  delta.height = newrect.height - r.height
		  return delta
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCurrentRect() As REALbasic.Rect
		  if item isa rectcontrol then
		    return rectcontrol(item).contentrect
		  elseif item isa window then
		    return window(item.objectvalue).contentrect
		  else
		    // Somehow, item has become something that is not a Window or RectControl
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
		Function OriginalRect() As REALbasic.Rect
		  return me.pstartrect
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Perform(Final As Boolean = False)
		  if final then
		    me.setrectnow me.newrect
		  else
		    dim start,delta,change as REALbasic.Rect
		    start = me.originalrect
		    delta = me.delta
		    
		    // new code
		    change = new realbasic.rect
		    change.top = floor(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.top,delta.top,me.duration * 1000000))
		    change.left = floor(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.left,delta.left,me.duration * 1000000))
		    change.width = ceil(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.width,delta.width,me.duration * 1000000))
		    change.height = ceil(AKEasing.GetEaseValue(me.easingmethod,me.runtime,start.height,delta.height,me.duration * 1000000))
		    
		    me.setrectnow change
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetRectNow(NewRect As REALbasic.Rect)
		  if item isa rectcontrol then
		    rectcontrol(item).contentrect = newrect
		  elseif item isa window then
		    window(item.objectvalue).contentrect = newrect
		  else
		    // Somehow, item has become something that is not a Window or RectControl
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
		NewRect As REALbasic.Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pStartRect As REALbasic.Rect
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ConflictResolutionAction"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastFrameTime"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
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
