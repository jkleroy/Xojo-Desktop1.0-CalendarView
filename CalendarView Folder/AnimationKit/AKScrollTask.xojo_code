#tag Class
Protected Class AKScrollTask
Inherits AKTask
	#tag Event
		Sub Started()
		  me.moriginalvalue = scrollbar(me.item).value
		  me.moriginalmaximum = scrollbar(me.item).MaximumValue
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1000
		Sub Constructor(Target As Scrollbar)
		  me.item = target
		  me.value = target.value
		  me.maximum = target.MaximumValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCompleted() As Boolean
		  return (me.runtime >= (me.duration * 1000000))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OriginalValue() As Integer
		  return mOriginalValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Perform(Final As Boolean = False)
		  if final then
		    scrollbar(me.item).MaximumValue = self.Maximum
		    scrollbar(me.item).value = self.Value
		  else
		    dim start,delta,change as Integer
		    
		    start = self.mOriginalMaximum
		    delta = self.maximum - start
		    change = AKEasing.GetEaseValue(me.easingmethod,me.runtime,start,delta,me.duration * 1000000)
		    scrollbar(me.item).MaximumValue = change
		    
		    start = self.mOriginalValue
		    delta = self.value - start
		    change = AKEasing.GetEaseValue(me.easingmethod,me.runtime,start,delta,me.duration * 1000000)
		    DesktopScrollbar(me.item).value = change
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
		Maximum As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalMaximum As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalValue As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Value As Integer
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
			Name="Maximum"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
