#tag Class
Protected Class AKTask
	#tag Method, Flags = &h0
		Sub Constructor()
		  dim out,i as integer
		  out = 1
		  for i = 2 to 8
		    out = val(str(out) + str(self.rand(0,9)))
		  next
		  
		  midentifier = out
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCompleted() As Boolean
		  dim n as nilobjectexception
		  n = new nilobjectexception
		  n.message = "Subclasses of AKTask must override the HasCompleted method."
		  raise n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasStarted() As Boolean
		  return (me.pstarttime <> 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Item() As Variant
		  return pItem
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Item(Assigns NewItem As Variant)
		  if newitem <> nil then
		    me.pitem = newitem
		  else
		    dim n as nilobjectexception
		    n = new nilobjectexception
		    n.message = "AKTask must receive a non-nil item to animate."
		    raise n
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextTask() As AKTask
		  return me.pnexttask
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextTask(Assigns TheTask As AKTask)
		  if me.pnexttask = nil then
		    me.pnexttask = thetask
		  else
		    me.pnexttask.nexttask = thetask
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(Task As AKTask) As Integer
		  if task is nil then
		    return 1
		  else
		    if task.uniqueid = me.uniqueid then
		      return 0
		    else
		      return -1
		    end
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Perform(Final As Boolean = False)
		  RaiseEvent Perform(Final)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Rand(MinPoint As Integer, MaxPoint As Integer) As Integer
		  static myrandom as random
		  if MyRandom = nil then
		    MyRandom = new Random
		  end
		  return MyRandom.inrange(minpoint,maxpoint)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RunTime() As Double
		  return System.Microseconds - me.pstarttime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  pStartTime = System.Microseconds
		  Started
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StartTime() As Double
		  return pStartTime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UniqueID() As Integer
		  return midentifier
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Perform(Final As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Started()
	#tag EndHook


	#tag Property, Flags = &h0
		ConflictResolutionAction As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LastFrameTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIdentifier As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OnCompleteAction As AKCompletionDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pItem As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			NextTask is used to create "chained" animations. Once this animation is complete, the animation
			in NextTask will automatically begin.
		#tag EndNote
		Private pNextTask As AKTask
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pStartTime As Double
	#tag EndProperty


	#tag Constant, Name = ResolveAppend, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ResolveReplace, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
