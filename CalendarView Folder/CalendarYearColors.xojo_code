#tag Class
Protected Class CalendarYearColors
	#tag Method, Flags = &h0
		Sub AppendColor(C As Color, Unique As Boolean = True)
		  If Unique then
		    
		    For i as Integer = 0 to EventColor.LastIndex
		      If EventColor(i) = C then
		        Return
		      End If
		    Next
		  End If
		  
		  EventColor.Add C
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(C As Color)
		  EventColor.Add C
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  Return EventColor.LastIndex + 1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FirstColor() As Color
		  Return EventColor(0)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		EventColor() As Color
	#tag EndProperty


	#tag ViewBehavior
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
			InitialValue="-2147483648"
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
			InitialValue="0"
			Type="Integer"
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
