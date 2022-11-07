#tag Class
Protected Class AKTimer
Inherits Timer
	#tag Event
		Sub Action()
		  dim i as integer
		  dim task as aktask
		  
		  // do the animation
		  for i = 0 to ubound(AKCore.tasks)
		    task = AKCore.tasks(i)
		    if not task.hasstarted then
		      task.start
		    end
		    
		    if microseconds - task.lastframetime >= AKCore.frameperiod then
		      task.perform
		      task.lastframetime = microseconds
		    end
		  next
		  
		  // cleanup
		  for i = ubound(AKCore.tasks) downto 0
		    task = AKCore.tasks(i)
		    if task.hascompleted then
		      // animation is completed, make sure it's final position is set
		      task.perform(true)
		      AKCore.tasks.remove i
		      
		      if task.nexttask <> nil then
		        task.nexttask.run
		      end
		      if task.oncompleteaction <> nil then
		        task.oncompleteaction.invoke(task)
		      end
		    end
		  next
		  
		  if ubound(AKCore.tasks) = -1 then
		    AKCore.stop
		  end
		End Sub
	#tag EndEvent


	#tag ViewBehavior
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
			Name="Enabled"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunMode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="RunModes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
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
	#tag EndViewBehavior
End Class
#tag EndClass
