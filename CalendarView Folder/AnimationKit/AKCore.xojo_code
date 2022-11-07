#tag Module
Protected Module AKCore
	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub AKCompletionDelegate(CompletedTask As AKTask)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Sub Animate(Extends Item As AKFrameTarget, Frames() As Picture, Duration As Double, Looping As Boolean = True)
		  dim task as akframetask
		  task = item.newframetask
		  task.frames = frames
		  task.duration = duration
		  task.looping = looping
		  task.run
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Animate(Extends Item As RectControl, ToRect As REALbasic.Rect, Duration As Double, EasingMethod As Integer = 0)
		  dim task as akmovetask
		  task = item.newmovetask
		  task.duration = duration
		  task.newrect = torect
		  task.easingmethod = easingmethod
		  
		  task.run
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Animate(Extends Item As Window, ToRect As REALbasic.Rect, Duration As Double, EasingMethod As Integer = 0)
		  dim task as akmovetask
		  task = item.newmovetask
		  task.duration = duration
		  task.newrect = torect
		  task.easingmethod = easingmethod
		  
		  task.run
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cancel(Extends Task As AKTask)
		  dim i as integer
		  for i = ubound(tasks) downto 0
		    if tasks(i) = task then
		      tasks.remove i
		    end
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Complete(Extends Task As AKTask)
		  task.perform(true)
		  if task.nexttask <> nil then
		    task.nexttask.run
		  end
		  if task.oncompleteaction <> nil then
		    task.oncompleteaction.invoke(task)
		  end
		  task.cancel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ContentRect(Extends Item As RectControl) As REALbasic.Rect
		  dim r as new REALbasic.Rect
		  r.left = item.left
		  r.top = item.top
		  r.width = item.width
		  r.height = item.height
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ContentRect(Extends Item As RectControl, Assigns NewRect As REALbasic.Rect)
		  item.left = newrect.left
		  item.top = newrect.top
		  item.width = newrect.width
		  item.height = newrect.height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ContentRect(Extends Item As Window) As REALbasic.Rect
		  dim r as new REALbasic.Rect
		  r.left = item.left
		  r.top = item.top
		  r.width = item.width
		  r.height = item.height
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ContentRect(Extends Item As Window, Assigns NewRect As REALbasic.Rect)
		  #if TargetCocoa
		    If Item IsA ContainerControl Then
		      if item.left <> newrect.left then
		        item.left = newrect.left
		      end if
		      if item.top <> newrect.top then
		        item.top = newrect.top
		      end if
		      if item.width <> newrect.width then
		        item.width = newrect.width
		      end if
		      if item.height <> newrect.height then
		        item.height = newrect.height
		      end if
		    Else
		      Dim Bottom As Integer = Screen(0).Height
		      
		      Dim Content As NSRect
		      Content.Origin.X = NewRect.Left
		      Content.Origin.Y = Bottom - (NewRect.Top + NewRect.Height)
		      Content.Dimensions.Width = NewRect.Width
		      Content.Dimensions.Height = NewRect.Height
		      
		      Declare Function GetFrame Lib "Cocoa.framework" Selector "frameRectForContentRect:" (Target As Integer, Content As NSRect) As NSRect
		      Dim Frame As NSRect = GetFrame(Item.Handle,Content)
		      
		      Declare Sub SetFrame Lib "Cocoa.framework" Selector "setFrame:display:" (Target As Integer, Frame As NSRect, Display As Boolean)
		      SetFrame(Item.Handle,Frame,True)
		    End If
		  #else
		    if item.top <> newrect.top then
		      item.top = newrect.top
		    end if
		    if item.left <> newrect.left then
		      item.left = newrect.left
		    end if
		    if item.width <> newrect.width then
		      item.width = newrect.width
		    end if
		    if item.height <> newrect.height then
		      item.height = newrect.height
		    end if
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FramePeriod() As Double
		  return 1000000 / fps
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewFrameTask(Extends Item As AKFrameTarget) As AKFrameTask
		  dim task as akframetask
		  task = new akframetask(item)
		  return task
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewMoveTask(Extends Item As RectControl) As akmovetask
		  dim task as akmovetask
		  task = new akmovetask(item)
		  return task
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewMoveTask(Extends Item As Window) As akmovetask
		  dim task as akmovetask
		  task = new akmovetask(item)
		  return task
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PicturePart(Source As Picture, X As Integer, Y As Integer, Width As Integer, Height As Integer) As Picture
		  dim p as picture
		  
		  p = new picture(width,height,32)
		  
		  p.mask.graphics.drawpicture source.mask,0,0,width,height,x,y,width,height
		  source.mask.graphics.forecolor = &c000000
		  source.mask.graphics.fillrect x,y,width,height
		  p.graphics.drawpicture source,0,0,width,height,x,y,width,height
		  source.mask.graphics.drawpicture p.mask,x,y
		  
		  return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ReverseFrames(Frames() As Picture) As Picture()
		  dim results() as picture
		  dim i as integer
		  for i = ubound(frames) downto 0
		    results.append frames(i)
		  next
		  return results
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Run(Extends Task As AKTask)
		  if animtimer = nil then
		    Start
		  end
		  
		  dim i as integer
		  if task.item <> nil then
		    for i = 0 to ubound(tasks)
		      if tasks(i).item = task.item then
		        // we already have this one to work on
		        if tasks(i).conflictresolutionaction = aktask.resolveappend then
		          tasks(i).nexttask = task
		          return
		        elseif tasks(i).conflictresolutionaction = aktask.resolvereplace then
		          tasks(i).cancel
		          exit
		        end if
		      end
		    next
		  end if
		  
		  // the task in question does not already exist, so add it
		  tasks.append task
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SplitGraphic(Value As Picture, Width As Integer, Height As Integer) As Picture()
		  dim results() as picture
		  dim x,y as integer
		  
		  for x = 0 to value.width - width step width
		    for y = 0 to value.height - height step height
		      results.append picturepart(value,x,y,width,height)
		    next
		  next
		  
		  return results
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Start()
		  if animtimer = nil then
		    animtimer = new AKTimer
		    animtimer.period = 10
		    animtimer.mode = timer.modemultiple
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Stop()
		  animtimer.mode = timer.modeoff
		  animtimer = nil
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private AnimTimer As AKTimer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected FPS As Integer = 32
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Tasks() As AKTask
	#tag EndProperty


	#tag Structure, Name = NSPoint, Flags = &h21
		X As Single
		Y As Single
	#tag EndStructure

	#tag Structure, Name = NSRect, Flags = &h21
		Origin As NSPoint
		Dimensions As NSSize
	#tag EndStructure

	#tag Structure, Name = NSSize, Flags = &h21
		Width As Single
		Height As Single
	#tag EndStructure


	#tag ViewBehavior
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
End Module
#tag EndModule
