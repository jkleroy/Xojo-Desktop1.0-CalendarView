#tag Class
Protected Class AKFrameTask
Inherits AKTask
	#tag Method, Flags = &h0
		Sub Constructor(TheItem As AKFrameTarget)
		  me.item = theitem
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCompleted() As Boolean
		  return pComplete
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Perform(Final As Boolean = False)
		  #Pragma Unused Final
		  
		  
		  if me.item isa akframetarget then
		  else
		    return
		  end
		  
		  dim frameDuration as double = (duration * 1000000) / (frames.LastIndex + 1)
		  
		  if System.Microseconds - pcurrentframestart >= frameduration then
		    pcurrentframestart = System.Microseconds
		  else
		    return
		  end
		  
		  if currentframe >= frames.LastIndex then
		    if me.looping then
		      currentframe = 0
		    else
		      pcomplete = true
		      return
		    end
		  else
		    currentframe = currentframe + 1
		  end
		  
		  if me.item <> nil then
		    dim k as akframetarget
		    k = akframetarget(me.item)
		    k.changeframe(currentframe,me.frames(currentframe))
		  end
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CurrentFrame As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Duration As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Frames() As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		Looping As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pComplete As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pCurrentFrameStart As Double
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
			Name="CurrentFrame"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Looping"
			Visible=false
			Group="Behavior"
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
