#tag Class
Protected Class CalendarDrawPosition
	#tag Method, Flags = &h0
		Sub AddHidden(ForDay As Integer, Length As Integer)
		  Length = max(0, Length)
		  
		  Dim i As Integer
		  For i = ForDay to min(Days, ForDay + Length)
		    Hidden(i) = Hidden(i) + 1
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Days As Integer, Positions As Integer)
		  Redim DrawPos(Days, Positions)
		  Redim Hidden(Days)
		  self.Days = Days
		  self.Positions = Positions
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LockLast(ForDay As Integer, Length As Integer) As Integer
		  #pragma DisableBoundsChecking
		  #pragma DisableBackgroundTasks
		  
		  
		  Dim i As Integer 
		  Length = max(0, Length)
		  For i = 0 to Length
		    If i > Days then
		      Exit for i
		    End If
		    
		    DrawPos(ForDay + i, Positions) = True
		  Next
		  
		  Return Positions
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Remain(ForDay As Integer, ForLength As Integer = 0) As Integer
		  #pragma DisableBoundsChecking
		  #pragma DisableBackgroundTasks
		  
		  If ForLength = 0 then
		    Dim returnValue, i As Integer
		    returnValue = Positions
		    
		    For i = 0 to Positions
		      If DrawPos(ForDay, i) then
		        returnValue = returnValue - 1
		      End If
		    Next
		    
		    Return returnValue
		    
		  else
		    Dim minReturnValue, returnValue, i, j As Integer
		    Dim u As Integer = min(Days, ForDay + ForLength)
		    minReturnValue = Positions
		    
		    For j = ForDay to u
		      
		      returnValue = Positions
		      
		      For i = 0 to Positions
		        If DrawPos(j, i) then
		          returnValue = returnValue - 1
		        End If
		      Next
		      
		      minreturnValue = min(returnValue, minReturnValue)
		      
		    Next
		    
		    Return minReturnValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Search(ForDay As Integer, Length As Integer) As Integer
		  #pragma DisableBoundsChecking
		  #pragma DisableBackgroundTasks
		  
		  
		  Dim i As Integer
		  Dim Available As Integer
		  
		  For i = 0 to Positions
		    
		    If not DrawPos(ForDay, i) then
		      Available = i
		      DrawPos(ForDay, i) = True
		      Exit for i
		    End If
		  Next
		  
		  For i = 1 to Length
		    If i + ForDay > Days then
		      Exit for i
		    End If
		    
		    DrawPos(ForDay + i, Available) = True
		  Next
		  
		  Return Available
		End Function
	#tag EndMethod


	#tag Note, Name = Description
		#ignore in LR
		
	#tag EndNote

	#tag Note, Name = See Also
		Calendarview, CalendarEvent
		
	#tag EndNote


	#tag Property, Flags = &h0
		Days As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		DrawPos(0,0) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidden() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Positions As Integer
	#tag EndProperty


	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.2.0", Scope = Public
	#tag EndConstant


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
		#tag ViewProperty
			Name="Days"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Positions"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
